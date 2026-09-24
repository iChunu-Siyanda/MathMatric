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
  MasterclassPayoutStatus,
} from "../../masterclasses/payout/masterclass_payout_entity";

import {
  MasterclassPayoutService,
} from "../../masterclasses/payout/masterclass_payout_service";

import {
  MasterclassPayoutEligibilityService,
} from "../../masterclasses/payout/masterclass_payout_eligibility_service";

import {
  TwentyPercentPlatformFeeCalculator,
} from "../../payout/platform_fee_calculator";

import {
  TransactionReferenceIdentity,
} from "../../transactions/transaction_reference_identity";

import {
  TransactionService,
} from "../../transactions/transaction_service";

import {
  MockPayoutProvider,
} from "../../provider/mock_payout_provider";

import {
  PayoutProviderIdentity,
} from "../../provider/payout_provider_identity";

import * as masterclassPayoutAdminActions from "../../masterclasses/payout/masterclass_payout_admin_actions";

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
      ? { uid: auth.uid, token: auth.token as DecodedIdToken }
      : undefined,
  } as unknown as CallableRequest<any>;
}


async function clearCollection(
  collectionName: string,
): Promise<void> {
  const snapshot = await db.collection(collectionName).get();

  if (snapshot.empty) return;

  const batch = db.batch();

  for (const document of snapshot.docs) {
    batch.delete(document.ref);
  }

  await batch.commit();
}


describe(
  "masterclass payout admin actions",
  () => {
    let payoutService: MasterclassPayoutService;

    beforeAll(() => {
      const referenceIdentity =
        new TransactionReferenceIdentity(db);

      const transactionService =
        new TransactionService(db, referenceIdentity);

      const eligibilityService =
        new MasterclassPayoutEligibilityService(
          new TwentyPercentPlatformFeeCalculator(),
        );

      const payoutProvider = new MockPayoutProvider();

      const payoutProviderIdentity =
        new PayoutProviderIdentity(db, payoutProvider);

      payoutService = new MasterclassPayoutService(
        db,
        eligibilityService,
        transactionService,
        payoutProvider,
        payoutProviderIdentity,
      );
    });

    afterAll(() => {
      testEnv.cleanup();
    });

    beforeEach(async () => {
      await clearCollection("masterclassPayouts");
      await clearCollection("transactions");
      await clearCollection("transactionReferences");
      await clearCollection("payoutProviderIds");
    });


    async function seedStuckPayout(payoutId: string) {
      await db
        .collection("masterclassPayouts")
        .doc(payoutId)
        .set({
          enrollmentId: "masterclass-1_student-1",
          paymentId: "masterclass-1_student-1",
          masterclassId: "masterclass-1",
          tutorId: "tutor-1",
          amountCents: 12000,
          currency: "ZAR",
          status: MasterclassPayoutStatus.processing,
          provider: null,
          providerPayoutId: null,
          createdAt: new Date(),
          updatedAt: new Date(),
          completedAt: null,
          failureReason: null,
        });

        await db
        .collection("transactions")
        .doc(`masterclass-payout-${payoutId}`)
        .set({
          bookingId: "masterclass-1_student-1",
          paymentId: "masterclass-1_student-1",
          type: "payout",
          direction: "debit",
          status: "pending",
          amountCents: 12000,
          currency: "ZAR",
          studentId: "student-1",
          tutorId: "tutor-1",
          referenceId: payoutId,
          description: `Masterclass payout for enrollment masterclass-1_student-1`,
          createdAt: new Date(),
          completedAt: null,
        });

      await payoutService.markStuck(payoutId);
    }

    describe("requireAdmin gate", () => {

      it(
        "rejects resolveMasterclassStuckPayoutAsFailed when unauthenticated",
        async () => {
          const wrapped = testEnv.wrap(
            masterclassPayoutAdminActions.resolveMasterclassStuckPayoutAsFailed,
          );

          await expect(
            wrapped(
              buildCallableRequest({
                payoutId: "payout-x",
                resolutionNote: "note",
              }),
            ),
          ).rejects.toMatchObject({ code: "unauthenticated" });
        },
      );


      it(
        "rejects resolveMasterclassStuckPayoutAsSucceeded when authenticated without the admin claim",
        async () => {
          const wrapped = testEnv.wrap(
            masterclassPayoutAdminActions.resolveMasterclassStuckPayoutAsSucceeded,
          );

          await expect(
            wrapped(
              buildCallableRequest(
                {
                  payoutId: "payout-x",
                  confirmedProviderPayoutId: "mock-x",
                },
                { uid: "user-1", token: {} },
              ),
            ),
          ).rejects.toMatchObject({ code: "permission-denied" });
        },
      );


      it(
        "rejects listStuckMasterclassPayoutCandidates when unauthenticated",
        async () => {
          const wrapped = testEnv.wrap(
            masterclassPayoutAdminActions.listStuckMasterclassPayoutCandidates,
          );

          await expect(
            wrapped(buildCallableRequest({})),
          ).rejects.toMatchObject({ code: "unauthenticated" });
        },
      );
    });


    describe(
      "resolveMasterclassStuckPayoutAsFailed (as admin)",
      () => {

        it("resolves a stuck payout", async () => {
          await seedStuckPayout("payout-stuck-1");

          const wrapped = testEnv.wrap(
            masterclassPayoutAdminActions.resolveMasterclassStuckPayoutAsFailed,
          );

          const result = await wrapped(
            buildCallableRequest(
              {
                payoutId: "payout-stuck-1",
                resolutionNote: "Confirmed never received.",
              },
              { uid: "admin-1", token: { admin: true } },
            ),
          );

          expect(result.payout.status).toBe(
            MasterclassPayoutStatus.pending,
          );
        });


        it("rejects a missing payoutId", async () => {
          const wrapped = testEnv.wrap(
            masterclassPayoutAdminActions.resolveMasterclassStuckPayoutAsFailed,
          );

          await expect(
            wrapped(
              buildCallableRequest(
                { resolutionNote: "note" },
                { uid: "admin-1", token: { admin: true } },
              ),
            ),
          ).rejects.toMatchObject({ code: "invalid-argument" });
        });
      },
    );


    describe(
      "resolveMasterclassStuckPayoutAsSucceeded (as admin)",
      () => {

        it("resolves a stuck payout as succeeded", async () => {
          await seedStuckPayout("payout-stuck-2");

          const wrapped = testEnv.wrap(
            masterclassPayoutAdminActions.resolveMasterclassStuckPayoutAsSucceeded,
          );

          const result = await wrapped(
            buildCallableRequest(
              {
                payoutId: "payout-stuck-2",
                confirmedProviderPayoutId:
                  "mock-confirmed-1",
              },
              { uid: "admin-1", token: { admin: true } },
            ),
          );

          expect(result.payout.status).toBe(
            MasterclassPayoutStatus.succeeded,
          );
        });
      },
    );


    describe(
      "listStuckMasterclassPayoutCandidates (as admin)",
      () => {

        it("returns candidates without mutating them", async () => {
          await db
            .collection("masterclassPayouts")
            .doc("payout-candidate-1")
            .set({
              enrollmentId: "masterclass-1_student-1",
              paymentId: "masterclass-1_student-1",
              masterclassId: "masterclass-1",
              tutorId: "tutor-1",
              amountCents: 12000,
              currency: "ZAR",
              status: MasterclassPayoutStatus.processing,
              provider: null,
              providerPayoutId: null,
              createdAt: new Date(),
              updatedAt: new Date(Date.now() - 60 * 60 * 1000),
              completedAt: null,
              failureReason: null,
            });

          const wrapped = testEnv.wrap(
            masterclassPayoutAdminActions.listStuckMasterclassPayoutCandidates,
          );

          const result = await wrapped(
            buildCallableRequest(
              {},
              { uid: "admin-1", token: { admin: true } },
            ),
          );

          expect(
            result.candidates.map((c: { id: string }) => c.id),
          ).toContain("payout-candidate-1");
        });
      },
    );
  },
);
