import {
  describe,
  expect,
  it,
  beforeEach,
} from "vitest";

import { Timestamp } from "firebase-admin/firestore";

import { db } from "../../../shared/firebase";

import {
  MasterclassPayoutService,
} from "../../masterclasses/payout/masterclass_payout_service";

import {
  MasterclassPayoutStatus,
} from "../../masterclasses/payout/masterclass_payout_entity";

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


async function seedProcessingPayout(
  payoutId: string,
  overrides: Partial<{
    updatedAt: Date;
    providerPayoutId: string | null;
  }> = {},
): Promise<void> {
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

      provider: overrides.providerPayoutId ? "mock" : null,
      providerPayoutId:
        overrides.providerPayoutId ?? null,

      createdAt: Timestamp.now(),
      updatedAt:
        overrides.updatedAt
          ? Timestamp.fromDate(overrides.updatedAt)
          : Timestamp.now(),

      completedAt: null,
      failureReason: null,
    });
}


describe(
  "MasterclassPayoutService (stuck detection, emulator)",
  () => {
    let payoutService: MasterclassPayoutService;

    beforeEach(async () => {
      await clearCollection("masterclassPayouts");
      await clearCollection("transactions");
      await clearCollection("transactionReferences");
      await clearCollection("payoutProviderIds");

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


    describe("findStuckPayoutCandidates", () => {

      it(
        "finds a processing payout with no provider payout ID older than the threshold",
        async () => {
          await seedProcessingPayout(
            "masterclass-payout-stuck-1",
            {
              updatedAt: new Date(
                Date.now() - 60 * 60 * 1000,
              ),
            },
          );

          const candidates =
            await payoutService
              .findStuckPayoutCandidates(
                30 * 60 * 1000,
              );

          expect(
            candidates.map((c) => c.id),
          ).toContain(
            "masterclass-payout-stuck-1",
          );
        },
      );


      it(
        "excludes a processing payout updated recently",
        async () => {
          await seedProcessingPayout(
            "masterclass-payout-fresh-1",
          );

          const candidates =
            await payoutService
              .findStuckPayoutCandidates(
                30 * 60 * 1000,
              );

          expect(
            candidates.map((c) => c.id),
          ).not.toContain(
            "masterclass-payout-fresh-1",
          );
        },
      );


      it(
        "excludes a processing payout that already has a provider payout ID attached",
        async () => {
          await seedProcessingPayout(
            "masterclass-payout-in-flight-1",
            {
              updatedAt: new Date(
                Date.now() - 60 * 60 * 1000,
              ),
              providerPayoutId:
                "mock-payout-in-flight-1",
            },
          );

          const candidates =
            await payoutService
              .findStuckPayoutCandidates(
                30 * 60 * 1000,
              );

          expect(
            candidates.map((c) => c.id),
          ).not.toContain(
            "masterclass-payout-in-flight-1",
          );
        },
      );


      it(
        "excludes payouts that are not processing",
        async () => {
          await db
            .collection("masterclassPayouts")
            .doc("masterclass-payout-pending-1")
            .set({
              enrollmentId: "masterclass-1_student-1",
              paymentId: "masterclass-1_student-1",
              masterclassId: "masterclass-1",
              tutorId: "tutor-1",
              amountCents: 12000,
              currency: "ZAR",
              status: MasterclassPayoutStatus.pending,
              provider: null,
              providerPayoutId: null,
              createdAt: Timestamp.now(),
              updatedAt: Timestamp.fromDate(
                new Date(Date.now() - 60 * 60 * 1000),
              ),
              completedAt: null,
              failureReason: null,
            });

          const candidates =
            await payoutService
              .findStuckPayoutCandidates(
                30 * 60 * 1000,
              );

          expect(
            candidates.map((c) => c.id),
          ).not.toContain(
            "masterclass-payout-pending-1",
          );
        },
      );
    });


    describe("markStuck", () => {

      it(
        "marks a processing payout with no provider payout ID as stuck",
        async () => {
          await seedProcessingPayout(
            "masterclass-payout-stuck-2",
          );

          const result = await payoutService.markStuck(
            "masterclass-payout-stuck-2",
          );

          expect(result.status).toBe(
            MasterclassPayoutStatus.stuck,
          );
        },
      );


      it(
        "is idempotent when already stuck",
        async () => {
          await seedProcessingPayout(
            "masterclass-payout-stuck-3",
          );

          await payoutService.markStuck(
            "masterclass-payout-stuck-3",
          );

          const result = await payoutService.markStuck(
            "masterclass-payout-stuck-3",
          );

          expect(result.status).toBe(
            MasterclassPayoutStatus.stuck,
          );
        },
      );


      it(
        "rejects a payout that is not processing",
        async () => {
          await db
            .collection("masterclassPayouts")
            .doc("masterclass-payout-pending-2")
            .set({
              enrollmentId: "masterclass-1_student-1",
              paymentId: "masterclass-1_student-1",
              masterclassId: "masterclass-1",
              tutorId: "tutor-1",
              amountCents: 12000,
              currency: "ZAR",
              status: MasterclassPayoutStatus.pending,
              provider: null,
              providerPayoutId: null,
              createdAt: Timestamp.now(),
              updatedAt: Timestamp.now(),
              completedAt: null,
              failureReason: null,
            });

          await expect(
            payoutService.markStuck(
              "masterclass-payout-pending-2",
            ),
          ).rejects.toThrow(
            "Only a processing masterclass payout can be marked stuck.",
          );
        },
      );


      it(
        "rejects a processing payout that already has a provider payout ID attached",
        async () => {
          await seedProcessingPayout(
            "masterclass-payout-in-flight-2",
            { providerPayoutId: "mock-payout-in-flight-2" },
          );

          await expect(
            payoutService.markStuck(
              "masterclass-payout-in-flight-2",
            ),
          ).rejects.toThrow(
            "Masterclass payout has a provider payout ID attached and is not stuck; it is awaiting a provider webhook.",
          );
        },
      );


      it(
        "rejects a missing payout",
        async () => {
          await expect(
            payoutService.markStuck(
              "does-not-exist",
            ),
          ).rejects.toThrow(
            "Masterclass payout does not exist.",
          );
        },
      );
    });
  },
);
