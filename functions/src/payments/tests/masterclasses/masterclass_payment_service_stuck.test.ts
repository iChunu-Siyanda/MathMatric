import {
  describe,
  expect,
  it,
  beforeEach,
} from "vitest";

import { Timestamp } from "firebase-admin/firestore";

import { db } from "../../../shared/firebase";

import {
  MasterclassPaymentService,
} from "../../masterclasses/payment/masterclass_payment_service";

import {
  MasterclassPaymentStatus,
} from "../../masterclasses/payment/masterclass_payment_entity";

import {
  PaymentProvider,
} from "../../provider/payment_provider";


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


async function seedProcessingPayment(
  enrollmentId: string,
  overrides: Partial<{
    updatedAt: Date;
  }> = {},
): Promise<void> {
  await db
    .collection("masterclassPayments")
    .doc(enrollmentId)
    .set({
      enrollmentId,
      masterclassId: "masterclass-1",
      studentId: "student-1",
      tutorId: "tutor-1",

      amountCents: 15000,
      currency: "ZAR",

      status: MasterclassPaymentStatus.processing,

      provider: "mock",
      providerPaymentId: `mock-${enrollmentId}`,

      createdAt: Timestamp.now(),
      updatedAt:
        overrides.updatedAt
          ? Timestamp.fromDate(overrides.updatedAt)
          : Timestamp.now(),

      paidAt: null,
      failureReason: null,
    });
}


describe(
  "MasterclassPaymentService (stuck detection, emulator)",
  () => {
    let paymentService: MasterclassPaymentService;

    beforeEach(async () => {
      await clearCollection("masterclassPayments");

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


    describe("findStuckPaymentCandidates", () => {

      it(
        "finds a processing payment older than the threshold",
        async () => {
          await seedProcessingPayment(
            "masterclass-1_student-stuck-1",
            {
              updatedAt: new Date(
                Date.now() - 60 * 60 * 1000,
              ),
            },
          );

          const candidates =
            await paymentService
              .findStuckPaymentCandidates(
                30 * 60 * 1000,
              );

          expect(
            candidates.map((c) => c.id),
          ).toContain(
            "masterclass-1_student-stuck-1",
          );
        },
      );


      it(
        "excludes a processing payment updated recently",
        async () => {
          await seedProcessingPayment(
            "masterclass-1_student-fresh-1",
          );

          const candidates =
            await paymentService
              .findStuckPaymentCandidates(
                30 * 60 * 1000,
              );

          expect(
            candidates.map((c) => c.id),
          ).not.toContain(
            "masterclass-1_student-fresh-1",
          );
        },
      );


      it(
        "excludes payments that are not processing",
        async () => {
          await db
            .collection("masterclassPayments")
            .doc("masterclass-1_student-pending-1")
            .set({
              enrollmentId:
                "masterclass-1_student-pending-1",
              masterclassId: "masterclass-1",
              studentId: "student-pending-1",
              tutorId: "tutor-1",
              amountCents: 15000,
              currency: "ZAR",
              status: MasterclassPaymentStatus.pending,
              provider: null,
              providerPaymentId: null,
              createdAt: Timestamp.now(),
              updatedAt: Timestamp.fromDate(
                new Date(Date.now() - 60 * 60 * 1000),
              ),
              paidAt: null,
              failureReason: null,
            });

          const candidates =
            await paymentService
              .findStuckPaymentCandidates(
                30 * 60 * 1000,
              );

          expect(
            candidates.map((c) => c.id),
          ).not.toContain(
            "masterclass-1_student-pending-1",
          );
        },
      );
    });


    describe("markStuck", () => {

      it(
        "marks a processing payment as stuck",
        async () => {
          await seedProcessingPayment(
            "masterclass-1_student-stuck-2",
          );

          await paymentService.markStuck(
            "masterclass-1_student-stuck-2",
          );

          const snapshot =
            await db
              .collection("masterclassPayments")
              .doc("masterclass-1_student-stuck-2")
              .get();

          expect(
            snapshot.data()?.status,
          ).toBe(MasterclassPaymentStatus.stuck);
        },
      );


      it(
        "is idempotent when already stuck",
        async () => {
          await seedProcessingPayment(
            "masterclass-1_student-stuck-3",
          );

          await paymentService.markStuck(
            "masterclass-1_student-stuck-3",
          );

          await expect(
            paymentService.markStuck(
              "masterclass-1_student-stuck-3",
            ),
          ).resolves.toBeUndefined();
        },
      );


      it(
        "rejects a payment that is not processing",
        async () => {
          await db
            .collection("masterclassPayments")
            .doc("masterclass-1_student-pending-2")
            .set({
              status: MasterclassPaymentStatus.pending,
            });

          await expect(
            paymentService.markStuck(
              "masterclass-1_student-pending-2",
            ),
          ).rejects.toThrow(
            "Masterclass payment cannot become stuck from pending.",
          );
        },
      );


      it(
        "rejects a missing payment",
        async () => {
          await expect(
            paymentService.markStuck(
              "does-not-exist",
            ),
          ).rejects.toThrow(
            "Masterclass payment not found.",
          );
        },
      );
    });


    describe("resolvePaymentAsFailed", () => {

      it(
        "resolves a stuck payment to failed with a note",
        async () => {
          await seedProcessingPayment(
            "masterclass-1_student-stuck-4",
          );

          await paymentService.markStuck(
            "masterclass-1_student-stuck-4",
          );

          await paymentService.resolvePaymentAsFailed(
            "masterclass-1_student-stuck-4",
            "Confirmed with provider support: charge never completed.",
          );

          const snapshot =
            await db
              .collection("masterclassPayments")
              .doc("masterclass-1_student-stuck-4")
              .get();

          expect(
            snapshot.data()?.status,
          ).toBe(MasterclassPaymentStatus.failed);

          expect(
            snapshot.data()?.failureReason,
          ).toContain(
            "Confirmed with provider support",
          );
        },
      );


      it(
        "rejects a payment that is not stuck",
        async () => {
          await seedProcessingPayment(
            "masterclass-1_student-not-stuck-1",
          );

          await expect(
            paymentService.resolvePaymentAsFailed(
              "masterclass-1_student-not-stuck-1",
              "Some note.",
            ),
          ).rejects.toThrow(
            "Only a stuck masterclass payment can be resolved as failed.",
          );
        },
      );


      it(
        "rejects an empty resolution note",
        async () => {
          await seedProcessingPayment(
            "masterclass-1_student-stuck-5",
          );

          await paymentService.markStuck(
            "masterclass-1_student-stuck-5",
          );

          await expect(
            paymentService.resolvePaymentAsFailed(
              "masterclass-1_student-stuck-5",
              "   ",
            ),
          ).rejects.toThrow(
            "Resolution note cannot be empty.",
          );
        },
      );


      it(
        "rejects a missing payment",
        async () => {
          await expect(
            paymentService.resolvePaymentAsFailed(
              "does-not-exist",
              "Some note.",
            ),
          ).rejects.toThrow(
            "Masterclass payment not found.",
          );
        },
      );
    });
  },
);
