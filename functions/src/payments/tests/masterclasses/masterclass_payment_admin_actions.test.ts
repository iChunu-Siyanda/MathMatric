import {
  describe,
  expect,
  it,
  beforeAll,
  afterAll,
  beforeEach,
} from "vitest";

import functionsTest from "firebase-functions-test";

import type { CallableRequest } from "firebase-functions/v2/https";
import type { DecodedIdToken } from "firebase-admin/auth";

import { db } from "../../../shared/firebase";

import {
  MasterclassPaymentStatus,
} from "../../masterclasses/payment/masterclass_payment_entity";

import {
  MasterclassPaymentService,
} from "../../masterclasses/payment/masterclass_payment_service";

import {
  PaymentProvider,
} from "../../provider/payment_provider";

import * as masterclassPaymentAdminActions from "../../masterclasses/payment/masterclass_payment_admin_actions";
import { MasterclassEnrollmentStatus } from "../../masterclasses/enrollment/masterclass_enrollment_entity";

const testEnv = functionsTest();


function buildCallableRequest(
  data: Record<string, unknown>,
  auth?: {
    uid: string;
    token?: Partial<DecodedIdToken>;
  },
): CallableRequest<any> {
  return {
    data,
    auth: auth
      ? {
          uid: auth.uid,
          token: auth.token as DecodedIdToken,
        }
      : undefined,
  } as unknown as CallableRequest<any>;
}


async function clearCollection(
  collectionName: string,
): Promise<void> {
  const snapshot =
    await db.collection(collectionName).get();

  if (snapshot.empty) return;

  const batch = db.batch();

  for (const document of snapshot.docs) {
    batch.delete(document.ref);
  }

  await batch.commit();
}


describe(
  "masterclass payment admin actions",
  () => {
    let paymentService: MasterclassPaymentService;

    beforeAll(() => {
      const paymentProvider: PaymentProvider = {
        name: "mock",
        createPayment: async () => {
          throw new Error("Not used in these tests.");
        },
        refundPayment: async () => {
          throw new Error("Not used in these tests.");
        },
        verifyWebhook: () => {
          throw new Error("Not used in these tests.");
        },
      };

      paymentService = new MasterclassPaymentService(
        db,
        paymentProvider,
      );
    });

    afterAll(() => {
      testEnv.cleanup();
    });

    beforeEach(async () => {
      await clearCollection("masterclassPayments");
      await clearCollection("masterclassEnrollments");
      await clearCollection("transactions");
      await clearCollection("transactionReferences");
    });


    async function seedStuckPayment(
      enrollmentId: string,
      studentId: string = "student-1",
    ) {
      await db
        .collection("masterclassPayments")
        .doc(enrollmentId)
        .set({
          enrollmentId,
          masterclassId: "masterclass-1",
          studentId,
          tutorId: "tutor-1",
          amountCents: 15000,
          currency: "ZAR",
          status: MasterclassPaymentStatus.processing,
          provider: "mock",
          providerPaymentId: `mock-${enrollmentId}`,
          createdAt: new Date(),
          updatedAt: new Date(),
          paidAt: null,
          failureReason: null,
        });

      await paymentService.markStuck(enrollmentId);
    }


    describe("requireAdmin gate", () => {

      it(
        "rejects resolveMasterclassPaymentAsFailed when unauthenticated",
        async () => {
          const wrapped = testEnv.wrap(
            masterclassPaymentAdminActions.resolveMasterclassPaymentAsFailed,
          );

          await expect(
            wrapped(
              buildCallableRequest({
                enrollmentId: "masterclass-1_student-1",
                resolutionNote: "note",
              }),
            ),
          ).rejects.toMatchObject({
            code: "unauthenticated",
          });
        },
      );


      it(
        "rejects resolveMasterclassPaymentAsFailed when authenticated without the admin claim",
        async () => {
          const wrapped = testEnv.wrap(
            masterclassPaymentAdminActions.resolveMasterclassPaymentAsFailed,
          );

          await expect(
            wrapped(
              buildCallableRequest(
                {
                  enrollmentId: "masterclass-1_student-1",
                  resolutionNote: "note",
                },
                { uid: "user-1", token: {} },
              ),
            ),
          ).rejects.toMatchObject({
            code: "permission-denied",
          });
        },
      );


      it(
        "rejects resolveMasterclassPaymentAsPaid when unauthenticated",
        async () => {
          const wrapped = testEnv.wrap(
            masterclassPaymentAdminActions.resolveMasterclassPaymentAsPaid,
          );

          await expect(
            wrapped(
              buildCallableRequest({
                enrollmentId: "masterclass-1_student-1",
                providerPaymentId: "mock-x",
              }),
            ),
          ).rejects.toMatchObject({
            code: "unauthenticated",
          });
        },
      );


      it(
        "rejects listStuckMasterclassPaymentCandidates when unauthenticated",
        async () => {
          const wrapped = testEnv.wrap(
            masterclassPaymentAdminActions.listStuckMasterclassPaymentCandidates,
          );

          await expect(
            wrapped(buildCallableRequest({})),
          ).rejects.toMatchObject({
            code: "unauthenticated",
          });
        },
      );
    });


    describe(
      "resolveMasterclassPaymentAsFailed (as admin)",
      () => {

        it(
          "resolves a stuck payment",
          async () => {
            await seedStuckPayment(
              "masterclass-1_student-1",
            );

            const wrapped = testEnv.wrap(
              masterclassPaymentAdminActions.resolveMasterclassPaymentAsFailed,
            );

            const result = await wrapped(
              buildCallableRequest(
                {
                  enrollmentId:
                    "masterclass-1_student-1",
                  resolutionNote:
                    "Confirmed never charged.",
                },
                { uid: "admin-1", token: { admin: true } },
              ),
            );

            expect(result.resolved).toBe(true);

            const snapshot =
              await db
                .collection("masterclassPayments")
                .doc("masterclass-1_student-1")
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(MasterclassPaymentStatus.failed);
          },
        );


        it(
          "rejects a missing enrollmentId",
          async () => {
            const wrapped = testEnv.wrap(
              masterclassPaymentAdminActions.resolveMasterclassPaymentAsFailed,
            );

            await expect(
              wrapped(
                buildCallableRequest(
                  { resolutionNote: "note" },
                  { uid: "admin-1", token: { admin: true } },
                ),
              ),
            ).rejects.toMatchObject({
              code: "invalid-argument",
            });
          },
        );


        it(
          "surfaces a domain error as failed-precondition when the payment is not stuck",
          async () => {
            await db
              .collection("masterclassPayments")
              .doc("masterclass-1_student-2")
              .set({
                enrollmentId: "masterclass-1_student-2",
                masterclassId: "masterclass-1",
                studentId: "student-2",
                tutorId: "tutor-1",
                amountCents: 15000,
                currency: "ZAR",
                status: MasterclassPaymentStatus.pending,
                provider: null,
                providerPaymentId: null,
                createdAt: new Date(),
                updatedAt: new Date(),
                paidAt: null,
                failureReason: null,
              });

            const wrapped = testEnv.wrap(
              masterclassPaymentAdminActions.resolveMasterclassPaymentAsFailed,
            );

            await expect(
              wrapped(
                buildCallableRequest(
                  {
                    enrollmentId:
                      "masterclass-1_student-2",
                    resolutionNote: "note",
                  },
                  { uid: "admin-1", token: { admin: true } },
                ),
              ),
            ).rejects.toMatchObject({
              code: "failed-precondition",
              message:
                "Only a stuck masterclass payment can be resolved as failed.",
            });
          },
        );
      },
    );


    describe(
      "resolveMasterclassPaymentAsPaid (as admin)",
      () => {

        it(
          "resolves a stuck payment via markPaymentPaid",
          async () => {
            const enrollmentId = "masterclass-1_student-3";

            await db
              .collection("masterclassEnrollments")
              .doc(enrollmentId)
              .set({
                masterclassId: "masterclass-1",
                studentId: "student-3",
                tutorId: "tutor-1",
                priceCents: 15000,
                currency: "ZAR",
                status: MasterclassEnrollmentStatus.pendingPayment,
                downloadedAt: null,
                enrolledAt: new Date(),
                updatedAt: new Date(),
                cancelledAt: null,
                refundedAt: null,
              });

            await seedStuckPayment(
                enrollmentId,
                "student-3",
            );

            const wrapped = testEnv.wrap(
              masterclassPaymentAdminActions.resolveMasterclassPaymentAsPaid,
            );

            const result = await wrapped(
              buildCallableRequest(
                {
                  enrollmentId,
                  providerPaymentId: `mock-${enrollmentId}`,
                },
                { uid: "admin-1", token: { admin: true } },
              ),
            );

            expect(result.payment.status).toBe(
              MasterclassPaymentStatus.paid,
            );
          },
        );


        it(
          "rejects a missing providerPaymentId",
          async () => {
            const wrapped = testEnv.wrap(
              masterclassPaymentAdminActions.resolveMasterclassPaymentAsPaid,
            );

            await expect(
              wrapped(
                buildCallableRequest(
                  {
                    enrollmentId:
                      "masterclass-1_student-1",
                  },
                  { uid: "admin-1", token: { admin: true } },
                ),
              ),
            ).rejects.toMatchObject({
              code: "invalid-argument",
            });
          },
        );
      },
    );


    describe(
      "listStuckMasterclassPaymentCandidates (as admin)",
      () => {

        it(
          "returns stuck-eligible candidates and does not mutate them",
          async () => {
            const enrollmentId =
              "masterclass-1_student-4";

            await db
              .collection("masterclassPayments")
              .doc(enrollmentId)
              .set({
                enrollmentId,
                masterclassId: "masterclass-1",
                studentId: "student-4",
                tutorId: "tutor-1",
                amountCents: 15000,
                currency: "ZAR",
                status: MasterclassPaymentStatus.processing,
                provider: "mock",
                providerPaymentId: `mock-${enrollmentId}`,
                createdAt: new Date(),
                updatedAt: new Date(
                  Date.now() - 60 * 60 * 1000,
                ),
                paidAt: null,
                failureReason: null,
              });

            const wrapped = testEnv.wrap(
              masterclassPaymentAdminActions.listStuckMasterclassPaymentCandidates,
            );

            const result = await wrapped(
              buildCallableRequest(
                {},
                { uid: "admin-1", token: { admin: true } },
              ),
            );

            expect(
              result.candidates.map(
                (c: { id: string }) => c.id,
              ),
            ).toContain(enrollmentId);

            const snapshot =
              await db
                .collection("masterclassPayments")
                .doc(enrollmentId)
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(MasterclassPaymentStatus.processing);
          },
        );
      },
    );
  },
);
