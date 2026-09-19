import {
  describe,
  expect,
  it,
  beforeEach,
} from "vitest";

import { Timestamp } from "firebase-admin/firestore";

import { db } from "../../../shared/firebase";

import {
  PaymentService,
} from "../../payment/payment_service";

import {
  PaymentStatus,
} from "../../payment/payment_entity";

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
  bookingId: string,
  overrides: Partial<{
    updatedAt: Date;
  }> = {},
): Promise<void> {
  await db
    .collection("payments")
    .doc(bookingId)
    .set({
      bookingId,
      studentId: "student-1",
      tutorId: "tutor-1",

      amountCents: 45000,
      refundedAmountCents: 0,
      refundReservedAmountCents: 0,
      currency: "ZAR",

      status: PaymentStatus.processing,

      provider: "mock",
      providerPaymentId:
        `mock-${bookingId}`,

      createdAt: Timestamp.now(),
      updatedAt:
        overrides.updatedAt
          ? Timestamp.fromDate(
              overrides.updatedAt,
            )
          : Timestamp.now(),

      paidAt: null,
      failureReason: null,
    });
}


describe(
  "PaymentService (stuck detection, emulator)",
  () => {
    let paymentService: PaymentService;

    beforeEach(async () => {
      await clearCollection("payments");

      const paymentProvider: PaymentProvider = {
        name: "mock",
        createPayment: async () => {
          throw new Error(
            "Not used in these tests.",
          );
        },
        refundPayment: async () => {
          throw new Error(
            "Not used in these tests.",
          );
        },
        verifyWebhook: () => {
          throw new Error(
            "Not used in these tests.",
          );
        },
      };

      paymentService =
        new PaymentService(
          db,
          paymentProvider,
        );
    });


    describe(
      "findStuckPaymentCandidates",
      () => {

        it(
          "finds a processing payment older than the threshold",
          async () => {
            await seedProcessingPayment(
              "booking-stuck-1",
              {
                updatedAt: new Date(
                  Date.now() -
                    60 * 60 * 1000,
                ),
              },
            );

            const candidates =
              await paymentService
                .findStuckPaymentCandidates(
                  30 * 60 * 1000,
                );

            expect(
              candidates.map(
                (c) => c.id,
              ),
            ).toContain(
              "booking-stuck-1",
            );
          },
        );


        it(
          "excludes a processing payment updated recently",
          async () => {
            await seedProcessingPayment(
              "booking-fresh-1",
            );

            const candidates =
              await paymentService
                .findStuckPaymentCandidates(
                  30 * 60 * 1000,
                );

            expect(
              candidates.map(
                (c) => c.id,
              ),
            ).not.toContain(
              "booking-fresh-1",
            );
          },
        );


        it(
          "excludes payments that are not processing",
          async () => {
            await db
              .collection("payments")
              .doc("booking-pending-1")
              .set({
                bookingId:
                  "booking-pending-1",
                studentId: "student-1",
                tutorId: "tutor-1",
                amountCents: 45000,
                refundedAmountCents: 0,
                refundReservedAmountCents: 0,
                currency: "ZAR",
                status:
                  PaymentStatus.pending,
                provider: null,
                providerPaymentId: null,
                createdAt:
                  Timestamp.now(),
                updatedAt:
                  Timestamp.fromDate(
                    new Date(
                      Date.now() -
                        60 * 60 * 1000,
                    ),
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
              candidates.map(
                (c) => c.id,
              ),
            ).not.toContain(
              "booking-pending-1",
            );
          },
        );
      },
    );


    describe(
      "markStuck",
      () => {

        it(
          "marks a processing payment as stuck",
          async () => {
            await seedProcessingPayment(
              "booking-stuck-2",
            );

            await paymentService.markStuck(
              "booking-stuck-2",
            );

            const snapshot =
              await db
                .collection("payments")
                .doc("booking-stuck-2")
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              PaymentStatus.stuck,
            );
          },
        );


        it(
          "is idempotent when already stuck",
          async () => {
            await seedProcessingPayment(
              "booking-stuck-3",
            );

            await paymentService.markStuck(
              "booking-stuck-3",
            );

            await expect(
              paymentService.markStuck(
                "booking-stuck-3",
              ),
            ).resolves.toBeUndefined();
          },
        );


        it(
          "rejects a payment that is not processing",
          async () => {
            await db
              .collection("payments")
              .doc("booking-pending-2")
              .set({
                status:
                  PaymentStatus.pending,
              });

            await expect(
              paymentService.markStuck(
                "booking-pending-2",
              ),
            ).rejects.toThrow(
              "Payment cannot become stuck from pending.",
            );
          },
        );


        it(
          "rejects a missing payment",
          async () => {
            await expect(
              paymentService.markStuck(
                "booking-does-not-exist",
              ),
            ).rejects.toThrow(
              "Payment not found.",
            );
          },
        );
      },
    );


    describe(
      "resolvePaymentAsFailed",
      () => {

        it(
          "resolves a stuck payment to failed with a note",
          async () => {
            await seedProcessingPayment(
              "booking-stuck-4",
            );

            await paymentService.markStuck(
              "booking-stuck-4",
            );

            await paymentService
              .resolvePaymentAsFailed(
                "booking-stuck-4",
                "Confirmed with provider support: charge never completed.",
              );

            const snapshot =
              await db
                .collection("payments")
                .doc("booking-stuck-4")
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              PaymentStatus.failed,
            );

            expect(
              snapshot.data()
                ?.failureReason,
            ).toContain(
              "Confirmed with provider support",
            );
          },
        );


        it(
          "rejects a payment that is not stuck",
          async () => {
            await seedProcessingPayment(
              "booking-not-stuck-1",
            );

            await expect(
              paymentService
                .resolvePaymentAsFailed(
                  "booking-not-stuck-1",
                  "Some note.",
                ),
            ).rejects.toThrow(
              "Only a stuck payment can be resolved as failed.",
            );
          },
        );


        it(
          "rejects an empty resolution note",
          async () => {
            await seedProcessingPayment(
              "booking-stuck-5",
            );

            await paymentService.markStuck(
              "booking-stuck-5",
            );

            await expect(
              paymentService
                .resolvePaymentAsFailed(
                  "booking-stuck-5",
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
              paymentService
                .resolvePaymentAsFailed(
                  "booking-does-not-exist",
                  "Some note.",
                ),
            ).rejects.toThrow(
              "Payment not found.",
            );
          },
        );
      },
    );
  },
);
