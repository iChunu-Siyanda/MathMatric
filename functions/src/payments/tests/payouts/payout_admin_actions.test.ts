import {
  describe,
  expect,
  it,
  beforeAll,
  afterAll,
  beforeEach,
} from "vitest";

import functionsTest from "firebase-functions-test";

import { db } from "../../../shared/firebase";

import {
  PayoutStatus,
} from "../../payout/payout_entity";

import {
  TutorPayoutEligibilityService,
} from "../../payout/tutor_payout_eligibility_service";

import {
  TwentyPercentPlatformFeeCalculator,
} from "../../payout/platform_fee_calculator";

import {
  PayoutTransactionService,
} from "../../transactions/payout_transaction_service";

import {
  TransactionService,
} from "../../transactions/transaction_service";

import {
  TransactionReferenceIdentity,
} from "../../transactions/transaction_reference_identity";

import {
  MockPayoutProvider,
} from "../../provider/mock_payout_provider";

import {
  PayoutProviderIdentity,
} from "../../provider/payout_provider_identity";

import {
  PayoutService,
} from "../../payout/payout_service";

import { Payment, PaymentStatus } from "../../payment/payment_entity";

import * as payoutAdminActions from "../../payout/payout_admin_actions";
import type { CallableRequest } from "firebase-functions/v2/https";
import type { DecodedIdToken } from "firebase-admin/auth";

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
          token:
            auth.token as DecodedIdToken,
        }
      : undefined,
  } as unknown as CallableRequest<any>;
}

const testEnv = functionsTest();


async function clearCollection(
  collectionName: string,
): Promise<void> {
  const snapshot =
    await db
      .collection(collectionName)
      .get();

  if (snapshot.empty) {
    return;
  }

  const batch = db.batch();

  for (const document of snapshot.docs) {
    batch.delete(document.ref);
  }

  await batch.commit();
}


async function seedEligiblePayout(): Promise<{
  booking: {
    id: string;
    studentId: string;
    tutorId: string;
    priceCents: number;
    status: "completed";
  };
  payment: Payment;
}> {
  const booking = {
    id: "booking-admin-123",
    studentId: "student-123",
    tutorId: "tutor-123",
    priceCents: 50000,
    status: "completed" as const,
  };

  const payment: Payment = {
    id: "booking-admin-123",
    bookingId: "booking-admin-123",
    studentId: "student-123",
    tutorId: "tutor-123",

    amountCents: 50000,
    refundedAmountCents: 0,
    refundReservedAmountCents: 0,

    currency: "ZAR",

    status: PaymentStatus.paid,

    provider: "mock",
    providerPaymentId: "mock-booking-admin-123",

    createdAt: new Date(),
    updatedAt: new Date(),

    paidAt: new Date(),
    failureReason: null,
  };

  return { booking, payment };
}


describe(
  "payout admin actions",
  () => {
    let payoutService: PayoutService;

    beforeAll(() => {
      /*
       * These callables construct their own PayoutService
       * internally against `db`, so we build an identical
       * one here purely to seed/drive fixtures through the
       * same real service logic (createPayout, markProcessing,
       * markStuck) rather than hand-writing Firestore docs.
       */
      const referenceIdentity =
        new TransactionReferenceIdentity(db);

      const transactionService =
        new TransactionService(
          db,
          referenceIdentity,
        );

      const payoutTransactionService =
        new PayoutTransactionService(
          db,
          transactionService,
        );

      const feeCalculator =
        new TwentyPercentPlatformFeeCalculator();

      const eligibilityService =
        new TutorPayoutEligibilityService(
          feeCalculator,
        );

      const payoutProvider =
        new MockPayoutProvider();

      const payoutProviderIdentity =
        new PayoutProviderIdentity(
          db,
          payoutProvider,
        );

      payoutService =
        new PayoutService(
          db,
          eligibilityService,
          payoutTransactionService,
          payoutProvider,
          payoutProviderIdentity,
        );
    });

    afterAll(() => {
      testEnv.cleanup();
    });

    beforeEach(async () => {
      await clearCollection("tutorPayouts");
      await clearCollection("transactions");
      await clearCollection("transactionReferences");
      await clearCollection("payoutProviderIds");
    });


    async function createStuckPayout() {
      const { booking, payment } =
        await seedEligiblePayout();

      const { payout } =
        await payoutService.createPayout({
          booking,
          payment,
        });

      await payoutService
        .markProcessing(payout.id);

      await payoutService
        .markStuck(payout.id);

      return payout;
    }


    describe(
      "requireAdmin gate",
      () => {

        it(
          "rejects resolveStuckPayoutAsFailed when unauthenticated",
          async () => {
            const wrapped =
              testEnv.wrap(
                payoutAdminActions.resolveStuckPayoutAsFailed,
              );

            await expect(
              wrapped(
                buildCallableRequest({
                  payoutId: "payout-x",
                  resolutionNote:
                    "note",
                }),
              ),
            ).rejects.toMatchObject({
              code: "unauthenticated",
            });
          },
        );


        it(
          "rejects resolveStuckPayoutAsFailed when authenticated without the admin claim",
          async () => {
            const wrapped =
              testEnv.wrap(
                payoutAdminActions.resolveStuckPayoutAsFailed,
              );

            await expect(
              wrapped(
                buildCallableRequest(
                  {
                    payoutId: "payout-x",
                    resolutionNote:
                      "note",
                  },
                  {
                    uid: "user-1",
                    token: {},
                  },
                ),
              ),
            ).rejects.toMatchObject({
              code: "permission-denied",
            });
          },
        );


        it(
          "rejects resolveStuckPayoutAsSucceeded when unauthenticated",
          async () => {
            const wrapped =
              testEnv.wrap(
                payoutAdminActions.resolveStuckPayoutAsSucceeded,
              );

            await expect(
              wrapped(
                buildCallableRequest(
                  {
                    payoutId: "payout-x",
                    confirmedProviderPayoutId:
                        "mock-payout-x",
                  },
                ),
              ),
            ).rejects.toMatchObject({
              code: "unauthenticated",
            });
          },
        );


        it(
          "rejects resolveStuckPayoutAsSucceeded when authenticated without the admin claim",
          async () => {
            const wrapped =
              testEnv.wrap(
                payoutAdminActions.resolveStuckPayoutAsSucceeded,
              );

            await expect(
              wrapped(
                buildCallableRequest(
                  {
                    payoutId: "payout-x",
                    confirmedProviderPayoutId:
                        "mock-payout-x",
                  },
                  {
                    uid: "user-1",
                    token: {},
                  },
                ),
              ),  
            ).rejects.toMatchObject({
              code: "permission-denied",
            });
          },
        );


        it(
          "rejects listStuckPayoutCandidates when unauthenticated",
          async () => {
            const wrapped =
              testEnv.wrap(
                payoutAdminActions.listStuckPayoutCandidates,
              );

            await expect(
              wrapped(buildCallableRequest({})),
            ).rejects.toMatchObject({
              code: "unauthenticated",
            });
          },
        );
      },
    );


    describe(
      "resolveStuckPayoutAsFailed (as admin)",
      () => {

        it(
          "resolves a stuck payout and returns it",
          async () => {
            const payout =
              await createStuckPayout();

            const wrapped =
              testEnv.wrap(
                payoutAdminActions.resolveStuckPayoutAsFailed,
              );

            const result =
              await wrapped(buildCallableRequest(
                {
                  payoutId: payout.id,
                  resolutionNote:
                    "Confirmed never received by provider.",
                },
                {
                  uid: "admin-1",
                  token: { admin: true },
                },
              ),);

            expect(
              result.payout.status,
            ).toBe(
              PayoutStatus.pending,
            );
          },
        );


        it(
          "rejects a missing payoutId",
          async () => {
            const wrapped =
              testEnv.wrap(
                payoutAdminActions.resolveStuckPayoutAsFailed,
              );

            await expect(
              wrapped(
                buildCallableRequest(
                  {
                    resolutionNote:
                    "note",
                  },
                  {
                    uid: "admin-1",
                    token: { admin: true },
                  },
                ),
              ),
            ).rejects.toMatchObject({
              code: "invalid-argument",
            });
          },
        );


        it(
          "rejects an empty resolutionNote",
          async () => {
            const payout =
              await createStuckPayout();

            const wrapped =
              testEnv.wrap(
                payoutAdminActions.resolveStuckPayoutAsFailed,
              );

            await expect(
              wrapped(buildCallableRequest(
                {
                  payoutId: payout.id,
                  resolutionNote:
                    "   ",
                },
                {
                  uid: "admin-1",
                  token: { admin: true },
                },),
              ),
            ).rejects.toMatchObject({
              code: "invalid-argument",
            });
          },
        );


        it(
          "surfaces a domain error as failed-precondition when the payout is not stuck",
          async () => {
            const { booking, payment } =
              await seedEligiblePayout();

            const { payout } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            const wrapped =
              testEnv.wrap(
                payoutAdminActions.resolveStuckPayoutAsFailed,
              );

            await expect(
              wrapped(buildCallableRequest(
                {
                  payoutId: payout.id,
                  resolutionNote:
                    "note",
                },
                {
                  uid: "admin-1",
                  token: { admin: true },
                },),
              ),
            ).rejects.toMatchObject({
              code: "failed-precondition",
              message:
                "Only a stuck payout can be resolved as failed.",
            });
          },
        );
      },
    );


    describe(
      "resolveStuckPayoutAsSucceeded (as admin)",
      () => {

        it(
          "resolves a stuck payout as succeeded and returns it",
          async () => {
            const payout =
              await createStuckPayout();

            const wrapped =
              testEnv.wrap(
                payoutAdminActions.resolveStuckPayoutAsSucceeded,
              );

            const result =
              await wrapped(buildCallableRequest(
                {
                  payoutId: payout.id,
                  confirmedProviderPayoutId:
                    "mock-payout-admin-confirmed-1",
                },
                {
                  uid: "admin-1",
                  token: { admin: true },
                },
              ),);

            expect(
              result.payout.status,
            ).toBe(
              PayoutStatus.succeeded,
            );

            expect(
              result.payout.providerPayoutId,
            ).toBe(
              "mock-payout-admin-confirmed-1",
            );
          },
        );


        it(
          "rejects a missing confirmedProviderPayoutId",
          async () => {
            const payout =
              await createStuckPayout();

            const wrapped =
              testEnv.wrap(
                payoutAdminActions.resolveStuckPayoutAsSucceeded,
              );

            await expect(
              wrapped(buildCallableRequest(
                {
                  payoutId: payout.id,
                },
                {
                  uid: "admin-1",
                  token: { admin: true },
                },),
              ),
            ).rejects.toMatchObject({
              code: "invalid-argument",
            });
          },
        );
      },
    );


    describe(
      "listStuckPayoutCandidates (as admin)",
      () => {

        it(
          "returns stuck payouts within the threshold and does not mutate them",
          async () => {
            const { booking, payment } =
              await seedEligiblePayout();

            const { payout } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .markProcessing(
                payout.id,
              );

            await db
              .collection("tutorPayouts")
              .doc(payout.id)
              .update({
                updatedAt: new Date(
                  Date.now() -
                    60 * 60 * 1000,
                ),
              });

            const wrapped =
              testEnv.wrap(
                payoutAdminActions.listStuckPayoutCandidates,
              );

            const result =
              await wrapped(buildCallableRequest(
                {},
                {
                  uid: "admin-1",
                  token: { admin: true },
                },),
              );

            expect(
              result.candidates.map(
                (c: { id: string }) =>
                  c.id,
              ),
            ).toContain(payout.id);

            const snapshot =
              await db
                .collection("tutorPayouts")
                .doc(payout.id)
                .get();

            /*
             * Confirms this callable is read-only:
             * status must still be "processing", NOT
             * "stuck" — listing candidates must never
             * itself call markStuck.
             */
            expect(
              snapshot.data()?.status,
            ).toBe(
              PayoutStatus.processing,
            );
          },
        );


        it(
          "respects a custom thresholdMs",
          async () => {
            const { booking, payment } =
              await seedEligiblePayout();

            const { payout } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .markProcessing(
                payout.id,
              );

            const wrapped =
              testEnv.wrap(
                payoutAdminActions.listStuckPayoutCandidates,
              );

            const result =
              await wrapped(
                buildCallableRequest(
                  {
                    thresholdMs:
                        24 * 60 * 60 * 1000,
                  },
                  {
                    uid: "admin-1",
                    token: { admin: true },
                  },
                ),    
              );

            expect(
              result.candidates.map(
                (c: { id: string }) =>
                  c.id,
              ),
            ).not.toContain(
              payout.id,
            );
          },
        );
      },
    );
  },
);
