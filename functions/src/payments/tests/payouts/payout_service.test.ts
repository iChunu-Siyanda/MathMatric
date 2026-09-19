import {
  describe,
  expect,
  it,
  beforeEach,
  vi,
} from "vitest";

import {
  PayoutStatus,
  TutorPayout,
} from "../../payout/payout_entity";

import {
  PayoutTransactionService,
} from "../../transactions/payout_transaction_service";

import {
  TransactionDirection,
  TransactionStatus,
  TransactionType,
} from "../../transactions/transaction";

import {
  TransactionReferenceIdentity,
} from "../../transactions/transaction_reference_identity";

import {
  TransactionService,
} from "../../transactions/transaction_service";

import { db } from "../../../shared/firebase";

import {
  PayoutProviderIdentity,
} from "../../provider/payout_provider_identity";

import {
  PayoutService,
} from "../../payout/payout_service";

import {
  MockPayoutProvider,
} from "../../provider/mock_payout_provider";

import {
  PayoutProvider,
  PayoutProviderOutcomeUnknownError,
} from "../../provider/payout_provider";

import {
  TutorPayoutEligibilityService,
} from "../../payout/tutor_payout_eligibility_service";

import {
  TwentyPercentPlatformFeeCalculator,
} from "../../payout/platform_fee_calculator";
import { Payment, PaymentStatus } from "../../payment/payment_entity";


class SpyPayoutProvider extends MockPayoutProvider {
  createPayout = vi.fn(
    async ({
      amountCents,
      currency,
      payoutId,
      tutorId,
    }: {
      amountCents: number;
      currency: "ZAR";
      payoutId: string;
      tutorId: string;
    }) => {
      return super.createPayout({
        amountCents,
        currency,
        payoutId,
        tutorId,
      });
    },
  );
}


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


function createPayoutService({
  eligibilityService,
  payoutTransactionService,
  payoutProvider,
}: {
  eligibilityService:
    TutorPayoutEligibilityService;

  payoutTransactionService:
    PayoutTransactionService;

  payoutProvider:
    PayoutProvider;
}): PayoutService {
  const payoutProviderIdentity =
    new PayoutProviderIdentity(
      db,
      payoutProvider,
    );

  return new PayoutService(
    db,
    eligibilityService,
    payoutTransactionService,
    payoutProvider,
    payoutProviderIdentity,
  );
}

async function setPayoutUpdatedAt(
  payoutId: string,
  date: Date,
): Promise<void> {
  await db
    .collection("tutorPayouts")
    .doc(payoutId)
    .update({
      updatedAt: date,
    });
}


/* -------------------------------------------------------------------------- */
/* PayoutTransactionService                                                    */
/* -------------------------------------------------------------------------- */

describe(
  "PayoutTransactionService",
  () => {
    let service:
      PayoutTransactionService;

    const payout: TutorPayout = {
      id: "payout-booking-123",
      bookingId: "booking-123",
      paymentId: "booking-123",
      tutorId: "tutor-123",
      amountCents: 40000,
      currency: "ZAR",
      status: PayoutStatus.pending,
      provider: null,
      providerPayoutId: null,
      createdAt: new Date(),
      updatedAt: new Date(),
      completedAt: null,
      failureReason: null,
    };

    const booking = {
      id: "booking-123",
      studentId: "student-123",
    };

    async function seedPayoutTransaction() {
      const transactionService =
        new TransactionService(
          db,
          new TransactionReferenceIdentity(
            db,
          ),
        );

      await transactionService
        .createTransaction({
          transactionId:
            `payout-${payout.id}`,

          bookingId:
            payout.bookingId,

          paymentId:
            payout.paymentId,

          type:
            TransactionType.payout,

          direction:
            TransactionDirection.debit,

          status:
            TransactionStatus.pending,

          amountCents:
            payout.amountCents,

          currency:
            payout.currency,

          studentId:
            booking.studentId,

          tutorId:
            payout.tutorId,

          referenceId:
            payout.id,

          description:
            `Tutor payout for booking ${payout.bookingId}`,

          completedAt: null,
        });
    }

    beforeEach(
      async () => {
        await clearCollection(
          "tutorPayouts",
        );

        await clearCollection(
          "transactions",
        );

        await clearCollection(
          "transactionReferences",
        );

        const referenceIdentity =
          new TransactionReferenceIdentity(
            db,
          );

        const transactionService =
          new TransactionService(
            db,
            referenceIdentity,
          );

        service =
          new PayoutTransactionService(
            db,
            transactionService,
          );
      },
    );


    describe(
      "markSucceededInTransaction",
      () => {

        it(
          "marks a pending payout transaction as completed",
          async () => {
            await seedPayoutTransaction();

            const transaction =
              await db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markSucceededInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              );

            expect(
              transaction.status,
            ).toBe(
              TransactionStatus.completed,
            );

            expect(
              transaction.completedAt,
            ).toBeInstanceOf(Date);

            const snapshot =
              await db
                .collection("transactions")
                .doc(
                  `payout-${payout.id}`,
                )
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              TransactionStatus.completed,
            );

            expect(
              snapshot.data()?.completedAt,
            ).toBeDefined();
          },
        );


        it(
          "is idempotent when the transaction is already completed",
          async () => {
            await seedPayoutTransaction();

            await db
              .collection("transactions")
              .doc(
                `payout-${payout.id}`,
              )
              .update({
                status:
                  TransactionStatus.completed,

                completedAt:
                  new Date(),
              });

            const transaction =
              await db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markSucceededInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              );

            expect(
              transaction.status,
            ).toBe(
              TransactionStatus.completed,
            );
          },
        );


        it(
          "rejects a failed transaction",
          async () => {
            await seedPayoutTransaction();

            await db
              .collection("transactions")
              .doc(
                `payout-${payout.id}`,
              )
              .update({
                status:
                  TransactionStatus.failed,
              });

            await expect(
              db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markSucceededInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              ),
            ).rejects.toThrow(
              "Only a pending payout transaction can be completed.",
            );
          },
        );


        it(
          "rejects a transaction belonging to a different payout",
          async () => {
            await seedPayoutTransaction();

            const differentPayout = {
              ...payout,
              id: "payout-other",
            };

            await expect(
              db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markSucceededInTransaction(
                      firestoreTransaction,
                      differentPayout,
                    );
                },
              ),
            ).rejects.toThrow(
              "Payout transaction does not exist.",
            );
          },
        );


        it(
          "rejects when the payout transaction does not exist",
          async () => {
            await expect(
              db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markSucceededInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              ),
            ).rejects.toThrow(
              "Payout transaction does not exist.",
            );
          },
        );
      },
    );


    describe(
      "markFailedInTransaction",
      () => {

        it(
          "marks a pending payout transaction as failed",
          async () => {
            await seedPayoutTransaction();

            const transaction =
              await db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markFailedInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              );

            expect(
              transaction.status,
            ).toBe(
              TransactionStatus.failed,
            );

            const snapshot =
              await db
                .collection("transactions")
                .doc(
                  `payout-${payout.id}`,
                )
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              TransactionStatus.failed,
            );
          },
        );


        it(
          "is idempotent when the transaction is already failed",
          async () => {
            await seedPayoutTransaction();

            await db
              .collection("transactions")
              .doc(
                `payout-${payout.id}`,
              )
              .update({
                status:
                  TransactionStatus.failed,
              });

            const transaction =
              await db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markFailedInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              );

            expect(
              transaction.status,
            ).toBe(
              TransactionStatus.failed,
            );
          },
        );


        it(
          "rejects a completed transaction",
          async () => {
            await seedPayoutTransaction();

            await db
              .collection("transactions")
              .doc(
                `payout-${payout.id}`,
              )
              .update({
                status:
                  TransactionStatus.completed,
              });

            await expect(
              db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markFailedInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              ),
            ).rejects.toThrow(
              "Only a pending payout transaction can be failed.",
            );
          },
        );


        it(
          "rejects when the payout transaction does not exist",
          async () => {
            await expect(
              db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markFailedInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              ),
            ).rejects.toThrow(
              "Payout transaction does not exist.",
            );
          },
        );


        it(
          "rejects a transaction with a mismatched amount",
          async () => {
            await seedPayoutTransaction();

            const differentPayout = {
              ...payout,
              amountCents: 35000,
            };

            await expect(
              db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markFailedInTransaction(
                      firestoreTransaction,
                      differentPayout,
                    );
                },
              ),
            ).rejects.toThrow(
              "Transaction amount does not match the payout.",
            );
          },
        );
      },
    );
  },
);


/* -------------------------------------------------------------------------- */
/* PayoutService                                                               */
/* -------------------------------------------------------------------------- */

describe(
  "PayoutService",
  () => {
    let eligibilityService:
      TutorPayoutEligibilityService;

    let payoutTransactionService:
      PayoutTransactionService;

    let transactionService:
      TransactionService;

    let referenceIdentity:
      TransactionReferenceIdentity;

    let payoutProvider:
      MockPayoutProvider;

    let payoutProviderIdentity:
      PayoutProviderIdentity;

    let payoutService:
      PayoutService;


    beforeEach(async () => {
      await clearCollection(
        "tutorPayouts",
      );

      await clearCollection(
        "transactions",
      );

      await clearCollection(
        "transactionReferences",
      );

      await clearCollection(
        "payoutProviderIds",
      );


      referenceIdentity =
        new TransactionReferenceIdentity(
          db,
        );


      transactionService =
        new TransactionService(
          db,
          referenceIdentity,
        );


      payoutTransactionService =
        new PayoutTransactionService(
          db,
          transactionService,
        );


      const feeCalculator =
        new TwentyPercentPlatformFeeCalculator();


      eligibilityService =
        new TutorPayoutEligibilityService(
          feeCalculator,
        );


      payoutProvider =
        new MockPayoutProvider();


      payoutProviderIdentity =
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


    async function seedEligiblePayout(): Promise<{
      booking: {
        id: string;
        studentId: string;
        tutorId: string;
        priceCents: number;
        status: "completed";
      };

      payment: Payment;

      // payment: {
      //   id: string;
      //   bookingId: string;
      //   studentId: string;
      //   tutorId: string;
      //   amountCents: number;
      //   refundedAmountCents: number;
      //   refundReservedAmountCents: number;
      //   currency: "ZAR";
      //   status: "paid";
      //   paidAt: Date;
      // };
    }> {
      const booking = {
        id: "booking-123",
        studentId: "student-123",
        tutorId: "tutor-123",
        priceCents: 50000,
        status: "completed" as const,
      };

      const payment: Payment = {
        id: "booking-123",
        bookingId: "booking-123",
        studentId: "student-123",
        tutorId: "tutor-123",

        amountCents: 50000,
        refundedAmountCents: 0,
        refundReservedAmountCents: 0,

        currency: "ZAR",

        status: PaymentStatus.paid,

        provider: "mock",
        providerPaymentId: "mock-booking-123",

        createdAt: new Date(),
        updatedAt: new Date(),

        paidAt: new Date(),
        failureReason: null,
      };

      return {
        booking,
        payment,
      };
    }


    describe(
      "createPayout",
      () => {

        it(
          "creates a pending payout and payout transaction",
          async () => {
            const {booking,payment,} =
              await seedEligiblePayout();

            const result =
              await payoutService.createPayout({
                booking: booking,
                payment: payment,
              });

            expect(
              result.created,
            ).toBe(true);

            expect(
              result.payout.id,
            ).toBe(
              `payout-${booking.id}`,
            );

            expect(
              result.payout.bookingId,
            ).toBe(
              booking.id,
            );

            expect(
              result.payout.paymentId,
            ).toBe(
              payment.id,
            );

            expect(
              result.payout.tutorId,
            ).toBe(
              booking.tutorId,
            );

            expect(
              result.payout.amountCents,
            ).toBe(40000);

            expect(
              result.payout.status,
            ).toBe(
              PayoutStatus.pending,
            );

            const payoutSnapshot =
              await db
                .collection("tutorPayouts")
                .doc(
                  `payout-${booking.id}`,
                )
                .get();

            expect(
              payoutSnapshot.exists,
            ).toBe(true);


            const transactionSnapshot =
              await db
                .collection("transactions")
                .doc(
                  `payout-payout-${booking.id}`,
                )
                .get();

            expect(
              transactionSnapshot.exists,
            ).toBe(true);


            expect(
              transactionSnapshot.data()?.status,
            ).toBe(
              TransactionStatus.pending,
            );
          },
        );


        it(
          "is idempotent when the payout already exists",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const first =
              await payoutService.createPayout({
                booking,
                payment,
              });

            const second =
              await payoutService.createPayout({
                booking,
                payment,
              });

            expect(
              first.created,
            ).toBe(true);

            expect(
              second.created,
            ).toBe(false);

            expect(
              second.payout.id,
            ).toBe(
              first.payout.id,
            );

            expect(
              second.payout.amountCents,
            ).toBe(
              first.payout.amountCents,
            );
          },
        );
      },
    );


    describe(
      "attachProviderPayoutId",
      () => {

        it(
          "attaches the provider payout ID",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .attachProviderPayoutId(
                payout.id,
                "mock-provider-payout-123",
              );

            const snapshot =
              await db
                .collection("tutorPayouts")
                .doc(payout.id)
                .get();

            expect(
              snapshot.data()?.provider,
            ).toBe("mock");

            expect(
              snapshot.data()?.providerPayoutId,
            ).toBe(
              "mock-provider-payout-123",
            );
          },
        );


        it(
          "is idempotent when the same provider payout ID is attached",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .attachProviderPayoutId(
                payout.id,
                "mock-provider-payout-123",
              );

            await expect(
              payoutService
                .attachProviderPayoutId(
                  payout.id,
                  "mock-provider-payout-123",
                ),
            ).resolves.toBeUndefined();
          },
        );


        it(
          "rejects a different provider payout ID",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .attachProviderPayoutId(
                payout.id,
                "mock-provider-payout-123",
              );

            await expect(
              payoutService
                .attachProviderPayoutId(
                  payout.id,
                  "mock-provider-payout-456",
                ),
            ).rejects.toThrow(
              "Payout is already associated with a different provider payout ID.",
            );
          },
        );


        it(
          "rejects a provider payout ID already associated with another payout",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const first =
              await payoutService.createPayout({
                booking,
                payment,
            });

            const secondBooking = {
              ...booking,
              id: "booking-456",
            };

            const secondPayment = {
              ...payment,
              id: "booking-456",
              bookingId: "booking-456",
            };

            const second =
              await payoutService.createPayout({
                booking: secondBooking,
                payment: secondPayment,
              });

            await payoutService
              .attachProviderPayoutId(
                first.payout.id,
                "mock-provider-payout-collision",
              );

            await expect(
              payoutService
                .attachProviderPayoutId(
                  second.payout.id,
                  "mock-provider-payout-collision",
                ),
            ).rejects.toThrow(
              "Provider payout ID is already associated with another payout.",
            );
          },
        );
      },
    );


    describe(
      "initiatePayout",
      () => {

        it(
          "initiates a payout with the provider and attaches the provider payout ID",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const spyProvider =
              new SpyPayoutProvider();

            payoutService =
              createPayoutService({
                eligibilityService,
                payoutTransactionService,
                payoutProvider:
                  spyProvider,
              });

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });


            const result =
              await payoutService
                .initiatePayout(
                  payout.id,
                );


            expect(
              spyProvider.createPayout,
            ).toHaveBeenCalledTimes(1);


            expect(
              spyProvider.createPayout,
            ).toHaveBeenCalledWith({
              amountCents: 40000,
              currency: "ZAR",
              payoutId: payout.id,
              tutorId: "tutor-123",
            });


            expect(
              result.status,
            ).toBe(
              PayoutStatus.processing,
            );


            expect(
              result.provider,
            ).toBe("mock");


            expect(
              result.providerPayoutId,
            ).toBe(
              `mock-payout-${payout.id}`,
            );


            const snapshot =
              await db
                .collection("tutorPayouts")
                .doc(payout.id)
                .get();


            expect(
              snapshot.data()?.status,
            ).toBe(
              PayoutStatus.processing,
            );


            expect(
              snapshot.data()?.provider,
            ).toBe("mock");


            expect(
              snapshot.data()?.providerPayoutId,
            ).toBe(
              `mock-payout-${payout.id}`,
            );
          },
        );


        it(
          "is idempotent when the provider payout ID already exists",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const spyProvider =
              new SpyPayoutProvider();

            payoutService =
              createPayoutService({
                eligibilityService,
                payoutTransactionService,
                payoutProvider:
                  spyProvider,
              });

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });


            await payoutService
              .attachProviderPayoutId(
                payout.id,
                "mock-payout-existing",
              );


            const result =
              await payoutService
                .initiatePayout(
                  payout.id,
                );


            expect(
              spyProvider.createPayout,
            ).not.toHaveBeenCalled();


            expect(
              result.providerPayoutId,
            ).toBe(
              "mock-payout-existing",
            );
          },
        );


        it(
          "rejects a missing payout",
          async () => {
            await expect(
              payoutService
                .initiatePayout(
                  "payout-does-not-exist",
                ),
            ).rejects.toThrow(
              "Payout does not exist.",
            );
          },
        );


        it(
          "marks the payout failed when provider initiation fails",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const failingProvider:
              PayoutProvider = {
                name: "mock",

                createPayout:
                  vi.fn(
                    async () => {
                      throw new Error(
                        "Provider payout failed.",
                      );
                    },
                  ),

                verifyWebhook:
                  vi.fn(
                    () => {
                      throw new Error(
                        "Not used in this test.",
                      );
                    },
                  ),
              };


            payoutService =
              createPayoutService({
                eligibilityService,
                payoutTransactionService,
                payoutProvider:
                  failingProvider,
              });


            const {
              payout,
            } =
              await payoutService.createPayout({
                booking: booking,
                payment: payment,
              });


            await expect(
              payoutService
                .initiatePayout(
                  payout.id,
                ),
            ).rejects.toThrow(
              "Provider payout failed.",
            );


            const snapshot =
              await db
                .collection("tutorPayouts")
                .doc(payout.id)
                .get();


            expect(
              snapshot.data()?.status,
            ).toBe(
              PayoutStatus.failed,
            );


            expect(
              snapshot.data()?.failureReason,
            ).toBe(
              "Provider payout failed.",
            );
          },
        );


        it(
          "rejects a payout that is already processing",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const spyProvider =
              new SpyPayoutProvider();

            payoutService =
              createPayoutService({
                eligibilityService,
                payoutTransactionService,
                payoutProvider:
                  spyProvider,
              });


            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });


            await payoutService
              .markProcessing(
                payout.id,
              );


            await expect(
              payoutService
                .initiatePayout(
                  payout.id,
                ),
            ).rejects.toThrow(
              "Payout initiation is already in progress for this payout. Retry shortly.",
            );


            expect(
              spyProvider.createPayout,
            ).not.toHaveBeenCalled();
          },
        );

        it(
          "leaves the payout processing and does not mark it failed when the provider outcome is unknown",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const timeoutProvider:
              PayoutProvider = {
                name: "mock",

                createPayout:
                  vi.fn(
                    async () => {
                      throw new PayoutProviderOutcomeUnknownError(
                        "Provider request timed out.",
                      );
                    },
                  ),

                verifyWebhook:
                  vi.fn(
                    () => {
                      throw new Error(
                        "Not used in this test.",
                      );
                    },
                  ),
              };

            payoutService =
              createPayoutService({
                eligibilityService,
                payoutTransactionService,
                payoutProvider:
                  timeoutProvider,
              });

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await expect(
              payoutService
                .initiatePayout(
                  payout.id,
                ),
            ).rejects.toThrow(
              "Provider request timed out.",
            );

            const snapshot =
              await db
                .collection("tutorPayouts")
                .doc(payout.id)
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              PayoutStatus.processing,
            );

            expect(
              snapshot.data()?.providerPayoutId,
            ).toBeNull();

            expect(
              snapshot.data()?.failureReason,
            ).toBeNull();
          },
        );

        it(
          "calls the provider only once when initiatePayout is invoked concurrently for the same payout",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const spyProvider =
              new SpyPayoutProvider();

            payoutService =
              createPayoutService({
                eligibilityService,
                payoutTransactionService,
                payoutProvider:
                  spyProvider,
              });

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            const results =
              await Promise.allSettled([
                payoutService
                  .initiatePayout(
                    payout.id,
                  ),
                payoutService
                  .initiatePayout(
                    payout.id,
                  ),
              ]);

            expect(
              spyProvider.createPayout,
            ).toHaveBeenCalledTimes(1);

            const fulfilled =
              results.filter(
                (r) =>
                  r.status ===
                  "fulfilled",
              );

            const rejected =
              results.filter(
                (r) =>
                  r.status ===
                  "rejected",
              );

            /*
             * Exactly one call wins and resolves;
             * the other either loses the claim
             * (PayoutInitiationInProgressError) or,
             * if it happened to run after the
             * winner fully completed, also resolves
             * idempotently. Either way the provider
             * is contacted exactly once.
             */
            expect(
              fulfilled.length,
            ).toBeGreaterThanOrEqual(1);

            for (const result of fulfilled) {
              if (
                result.status ===
                "fulfilled"
              ) {
                expect(
                  result.value
                    .providerPayoutId,
                ).toBe(
                  `mock-payout-${payout.id}`,
                );
              }
            }

            for (const result of rejected) {
              if (
                result.status ===
                "rejected"
              ) {
                expect(
                  result.reason
                    .message,
                ).toBe(
                  "Payout initiation is already in progress for this payout. Retry shortly.",
                );
              }
            }

            const snapshot =
              await db
                .collection("tutorPayouts")
                .doc(payout.id)
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              PayoutStatus.processing,
            );
          },
        );
      },
    );

    describe(
      "retryPayout",
      () => {

        it(
          "rejects a missing payout",
          async () => {
            await expect(
              payoutService
                .retryPayout(
                  "payout-does-not-exist",
                ),
            ).rejects.toThrow(
              "Payout does not exist.",
            );
          },
        );


        it(
          "resets a failed payout with no provider payout ID back to pending",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const failingProvider:
              PayoutProvider = {
                name: "mock",

                createPayout:
                  vi.fn(
                    async () => {
                      throw new Error(
                        "Provider payout failed.",
                      );
                    },
                  ),

                verifyWebhook:
                  vi.fn(
                    () => {
                      throw new Error(
                        "Not used in this test.",
                      );
                    },
                  ),
              };

            payoutService =
              createPayoutService({
                eligibilityService,
                payoutTransactionService,
                payoutProvider:
                  failingProvider,
              });

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await expect(
              payoutService
                .initiatePayout(
                  payout.id,
                ),
            ).rejects.toThrow(
              "Provider payout failed.",
            );

            const result =
              await payoutService
                .retryPayout(
                  payout.id,
                );

            expect(
              result.status,
            ).toBe(
              PayoutStatus.pending,
            );

            expect(
              result.failureReason,
            ).toBeNull();

            const payoutSnapshot =
              await db
                .collection("tutorPayouts")
                .doc(payout.id)
                .get();

            expect(
              payoutSnapshot.data()?.status,
            ).toBe(
              PayoutStatus.pending,
            );

            expect(
              payoutSnapshot.data()?.failureReason,
            ).toBeNull();

            const transactionSnapshot =
              await db
                .collection("transactions")
                .doc(
                  `payout-${payout.id}`,
                )
                .get();

            expect(
              transactionSnapshot.data()?.status,
            ).toBe(
              TransactionStatus.pending,
            );
          },
        );


        it(
          "is idempotent when called on an already-pending payout",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            const first =
              await payoutService
                .retryPayout(
                  payout.id,
                );

            const second =
              await payoutService
                .retryPayout(
                  payout.id,
                );

            expect(
              first.status,
            ).toBe(
              PayoutStatus.pending,
            );

            expect(
              second.status,
            ).toBe(
              PayoutStatus.pending,
            );
          },
        );


        it(
          "is idempotent when called on a succeeded payout",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const spyProvider =
              new SpyPayoutProvider();

            payoutService =
              createPayoutService({
                eligibilityService,
                payoutTransactionService,
                payoutProvider:
                  spyProvider,
              });

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .initiatePayout(
                payout.id,
              );

            await payoutService
              .markSucceeded(
                payout.id,
              );

            const result =
              await payoutService
                .retryPayout(
                  payout.id,
                );

            expect(
              result.status,
            ).toBe(
              PayoutStatus.succeeded,
            );
          },
        );


        it(
          "rejects retry on a processing payout",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .markProcessing(
                payout.id,
              );

            await expect(
              payoutService
                .retryPayout(
                  payout.id,
                ),
            ).rejects.toThrow(
              "Cannot retry a payout that is currently processing.",
            );
          },
        );


        it(
          "rejects retry on a cancelled payout",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await db
              .collection("tutorPayouts")
              .doc(payout.id)
              .update({
                status:
                  PayoutStatus.cancelled,
              });

            await expect(
              payoutService
                .retryPayout(
                  payout.id,
                ),
            ).rejects.toThrow(
              "Cancelled payouts cannot be retried.",
            );
          },
        );


        it(
          "rejects retry on a failed payout that already has a provider payout ID attached",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .attachProviderPayoutId(
                payout.id,
                "mock-provider-payout-orphan",
              );

            await payoutService
              .markFailed(
                payout.id,
                "Simulated post-attach failure.",
              );

            await expect(
              payoutService
                .retryPayout(
                  payout.id,
                ),
            ).rejects.toThrow(
              "Payout already has a provider payout ID attached and cannot be retried automatically. Resolve via reconciliation.",
            );

            const snapshot =
              await db
                .collection("tutorPayouts")
                .doc(payout.id)
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              PayoutStatus.failed,
            );

            expect(
              snapshot.data()?.providerPayoutId,
            ).toBe(
              "mock-provider-payout-orphan",
            );
          },
        );


        it(
          "allows initiatePayout to succeed again after a successful retry",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const flakyProvider =
              new SpyPayoutProvider();

            flakyProvider.createPayout
              .mockImplementationOnce(
                async () => {
                  throw new Error(
                    "Provider payout failed.",
                  );
                },
              );

            payoutService =
              createPayoutService({
                eligibilityService,
                payoutTransactionService,
                payoutProvider:
                  flakyProvider,
              });

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await expect(
              payoutService
                .initiatePayout(
                  payout.id,
                ),
            ).rejects.toThrow(
              "Provider payout failed.",
            );

            await payoutService
              .retryPayout(
                payout.id,
              );

            const result =
              await payoutService
                .initiatePayout(
                  payout.id,
                );

            expect(
              flakyProvider.createPayout,
            ).toHaveBeenCalledTimes(2);

            expect(
              result.status,
            ).toBe(
              PayoutStatus.processing,
            );

            expect(
              result.providerPayoutId,
            ).toBe(
              `mock-payout-${payout.id}`,
            );

            const transactionsSnapshot =
              await db
                .collection("transactions")
                .get();

            expect(
              transactionsSnapshot.size,
            ).toBe(1);

            const transactionSnapshot =
              await db
                .collection("transactions")
                .doc(
                  `payout-${payout.id}`,
                )
                .get();

            expect(
              transactionSnapshot.data()?.status,
            ).toBe(
              TransactionStatus.pending,
            );
          },
        );
      },
    );

    describe(
      "findStuckPayoutCandidates",
      () => {

        it(
          "finds a processing payout with no provider payout ID older than the threshold",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .markProcessing(
                payout.id,
              );

            await setPayoutUpdatedAt(
              payout.id,
              new Date(
                Date.now() -
                  60 * 60 * 1000,
              ),
            );

            const candidates =
              await payoutService
                .findStuckPayoutCandidates(
                  30 * 60 * 1000,
                );

            expect(
              candidates.map(
                (c) => c.id,
              ),
            ).toContain(
              payout.id,
            );
          },
        );


        it(
          "excludes a processing payout that was updated recently",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .markProcessing(
                payout.id,
              );

            const candidates =
              await payoutService
                .findStuckPayoutCandidates(
                  30 * 60 * 1000,
                );

            expect(
              candidates.map(
                (c) => c.id,
              ),
            ).not.toContain(
              payout.id,
            );
          },
        );


        it(
          "excludes a processing payout that already has a provider payout ID attached",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .attachProviderPayoutId(
                payout.id,
                "mock-payout-in-flight",
              );

            await payoutService
              .markProcessing(
                payout.id,
                "mock-payout-in-flight",
              );

            await setPayoutUpdatedAt(
              payout.id,
              new Date(
                Date.now() -
                  60 * 60 * 1000,
              ),
            );

            const candidates =
              await payoutService
                .findStuckPayoutCandidates(
                  30 * 60 * 1000,
                );

            expect(
              candidates.map(
                (c) => c.id,
              ),
            ).not.toContain(
              payout.id,
            );
          },
        );


        it(
          "excludes payouts that are not processing",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await setPayoutUpdatedAt(
              payout.id,
              new Date(
                Date.now() -
                  60 * 60 * 1000,
              ),
            );

            const candidates =
              await payoutService
                .findStuckPayoutCandidates(
                  30 * 60 * 1000,
                );

            expect(
              candidates.map(
                (c) => c.id,
              ),
            ).not.toContain(
              payout.id,
            );
          },
        );
      },
    );

    describe(
      "markProcessing (provider ID validation)",
      () => {

        it(
          "succeeds when expectedProviderPayoutId matches the attached ID",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .attachProviderPayoutId(
                payout.id,
                "mock-payout-match",
              );

            const result =
              await payoutService
                .markProcessing(
                  payout.id,
                  "mock-payout-match",
                );

            expect(
              result.status,
            ).toBe(
              PayoutStatus.processing,
            );
          },
        );


        it(
          "rejects when expectedProviderPayoutId does not match the attached ID",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .attachProviderPayoutId(
                payout.id,
                "mock-payout-actual",
              );

            await expect(
              payoutService
                .markProcessing(
                  payout.id,
                  "mock-payout-wrong",
                ),
            ).rejects.toThrow(
              "Provider payout ID does not match the payout.",
            );
          },
        );


        it(
          "rejects when expectedProviderPayoutId is given but no provider payout ID is attached yet",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await expect(
              payoutService
                .markProcessing(
                  payout.id,
                  "mock-payout-not-yet-attached",
                ),
            ).rejects.toThrow(
              "Payout has no provider payout ID attached yet.",
            );
          },
        );


        it(
          "still succeeds with no expectedProviderPayoutId argument (internal caller path)",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            const result =
              await payoutService
                .markProcessing(
                  payout.id,
                );

            expect(
              result.status,
            ).toBe(
              PayoutStatus.processing,
            );
          },
        );
      },
    );

    describe(
      "markStuck",
      () => {

        it(
          "marks a processing payout with no provider payout ID as stuck",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .markProcessing(
                payout.id,
              );

            const result =
              await payoutService
                .markStuck(
                  payout.id,
                );

            expect(
              result.status,
            ).toBe(
              PayoutStatus.stuck,
            );

            const snapshot =
              await db
                .collection("tutorPayouts")
                .doc(payout.id)
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              PayoutStatus.stuck,
            );
          },
        );


        it(
          "is idempotent when already stuck",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .markProcessing(
                payout.id,
              );

            await payoutService
              .markStuck(
                payout.id,
              );

            const result =
              await payoutService
                .markStuck(
                  payout.id,
                );

            expect(
              result.status,
            ).toBe(
              PayoutStatus.stuck,
            );
          },
        );


        it(
          "rejects a payout that is not processing",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await expect(
              payoutService
                .markStuck(
                  payout.id,
                ),
            ).rejects.toThrow(
              "Only a processing payout can be marked stuck.",
            );
          },
        );


        it(
          "rejects a processing payout that already has a provider payout ID attached",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .attachProviderPayoutId(
                payout.id,
                "mock-payout-in-flight-2",
              );

            await payoutService
              .markProcessing(
                payout.id,
                "mock-payout-in-flight-2",
              );

            await expect(
              payoutService
                .markStuck(
                  payout.id,
                ),
            ).rejects.toThrow(
              "Payout has a provider payout ID attached and is not stuck; it is awaiting a provider webhook.",
            );
          },
        );


        it(
          "rejects a missing payout",
          async () => {
            await expect(
              payoutService
                .markStuck(
                  "payout-does-not-exist",
                ),
            ).rejects.toThrow(
              "Payout does not exist.",
            );
          },
        );
      },
    );

    describe(
      "resolveStuckPayoutAsFailed",
      () => {

        it(
          "resets a stuck payout to pending with a failure note and resets the ledger",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .markProcessing(
                payout.id,
              );

            await payoutService
              .markStuck(
                payout.id,
              );

            const result =
              await payoutService
                .resolveStuckPayoutAsFailed(
                  payout.id,
                  "Confirmed with provider support: request was never received.",
                );

            expect(
              result.status,
            ).toBe(
              PayoutStatus.pending,
            );

            expect(
              result.failureReason,
            ).toContain(
              "Confirmed with provider support",
            );

            const snapshot =
              await db
                .collection("tutorPayouts")
                .doc(payout.id)
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              PayoutStatus.pending,
            );

            const transactionSnapshot =
              await db
                .collection("transactions")
                .doc(
                  `payout-${payout.id}`,
                )
                .get();

            expect(
              transactionSnapshot.data()?.status,
            ).toBe(
              TransactionStatus.pending,
            );
          },
        );


        it(
          "rejects a payout that is not stuck",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await expect(
              payoutService
                .resolveStuckPayoutAsFailed(
                  payout.id,
                  "Some note.",
                ),
            ).rejects.toThrow(
              "Only a stuck payout can be resolved as failed.",
            );
          },
        );


        it(
          "rejects an empty resolution note",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .markProcessing(
                payout.id,
              );

            await payoutService
              .markStuck(
                payout.id,
              );

            await expect(
              payoutService
                .resolveStuckPayoutAsFailed(
                  payout.id,
                  "   ",
                ),
            ).rejects.toThrow(
              "Resolution note cannot be empty.",
            );
          },
        );


        it(
          "rejects a missing payout",
          async () => {
            await expect(
              payoutService
                .resolveStuckPayoutAsFailed(
                  "payout-does-not-exist",
                  "Some note.",
                ),
            ).rejects.toThrow(
              "Payout does not exist.",
            );
          },
        );


        it(
          "allows initiatePayout to run again after resolution",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const spyProvider =
              new SpyPayoutProvider();

            payoutService =
              createPayoutService({
                eligibilityService,
                payoutTransactionService,
                payoutProvider:
                  spyProvider,
              });

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .markProcessing(
                payout.id,
              );

            await payoutService
              .markStuck(
                payout.id,
              );

            await payoutService
              .resolveStuckPayoutAsFailed(
                payout.id,
                "Never received by provider.",
              );

            const result =
              await payoutService
                .initiatePayout(
                  payout.id,
                );

            expect(
              result.status,
            ).toBe(
              PayoutStatus.processing,
            );

            expect(
              result.providerPayoutId,
            ).toBe(
              `mock-payout-${payout.id}`,
            );
          },
        );
      },
    );
    
    describe(
      "resolveStuckPayoutAsSucceeded",
      () => {

        it(
          "resolves a stuck payout as succeeded and attaches the confirmed provider payout ID",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .markProcessing(
                payout.id,
              );

            await payoutService
              .markStuck(
                payout.id,
              );

            const result =
              await payoutService
                .resolveStuckPayoutAsSucceeded(
                  payout.id,
                  "mock-payout-confirmed-1",
                );

            expect(
              result.status,
            ).toBe(
              PayoutStatus.succeeded,
            );

            expect(
              result.providerPayoutId,
            ).toBe(
              "mock-payout-confirmed-1",
            );

            const snapshot =
              await db
                .collection("tutorPayouts")
                .doc(payout.id)
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              PayoutStatus.succeeded,
            );

            expect(
              snapshot.data()?.provider,
            ).toBe("mock");

            expect(
              snapshot.data()?.providerPayoutId,
            ).toBe(
              "mock-payout-confirmed-1",
            );

            const transactionSnapshot =
              await db
                .collection("transactions")
                .doc(
                  `payout-${payout.id}`,
                )
                .get();

            expect(
              transactionSnapshot.data()?.status,
            ).toBe(
              TransactionStatus.completed,
            );

            const identitySnapshot =
              await db
                .collection("payoutProviderIds")
                .doc(
                  "mock:mock-payout-confirmed-1",
                )
                .get();

            expect(
              identitySnapshot.exists,
            ).toBe(true);
          },
        );


        it(
          "rejects a payout that is not stuck",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await expect(
              payoutService
                .resolveStuckPayoutAsSucceeded(
                  payout.id,
                  "mock-payout-confirmed-2",
                ),
            ).rejects.toThrow(
              "Only a stuck payout can be resolved as succeeded.",
            );
          },
        );


        it(
          "rejects an invalid confirmed provider payout ID",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .markProcessing(
                payout.id,
              );

            await payoutService
              .markStuck(
                payout.id,
              );

            await expect(
              payoutService
                .resolveStuckPayoutAsSucceeded(
                  payout.id,
                  "",
                ),
            ).rejects.toThrow();
          },
        );


        it(
          "rejects a missing payout",
          async () => {
            await expect(
              payoutService
                .resolveStuckPayoutAsSucceeded(
                  "payout-does-not-exist",
                  "mock-payout-confirmed-3",
                ),
            ).rejects.toThrow(
              "Payout does not exist.",
            );
          },
        );


        it(
          "rejects a provider payout ID already claimed by another payout",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const first =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .attachProviderPayoutId(
                first.payout.id,
                "mock-payout-collision-stuck",
              );

            const secondBooking = {
              ...booking,
              id: "booking-789",
            };

            const secondPayment = {
              ...payment,
              id: "booking-789",
              bookingId: "booking-789",
            };

            const second =
              await payoutService.createPayout({
                booking: secondBooking,
                payment: secondPayment,
              });

            await payoutService
              .markProcessing(
                second.payout.id,
              );

            await payoutService
              .markStuck(
                second.payout.id,
              );

            await expect(
              payoutService
                .resolveStuckPayoutAsSucceeded(
                  second.payout.id,
                  "mock-payout-collision-stuck",
                ),
            ).rejects.toThrow(
              "Provider payout ID is already associated with another payout.",
            );
          },
        );
      },
    );

    describe(
      "markSucceeded (provider ID validation)",
      () => {

        it(
          "succeeds when expectedProviderPayoutId matches the attached ID",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .attachProviderPayoutId(
                payout.id,
                "mock-payout-match",
              );

            await payoutService
              .markProcessing(
                payout.id,
              );

            const result =
              await payoutService
                .markSucceeded(
                  payout.id,
                  "mock-payout-match",
                );

            expect(
              result.status,
            ).toBe(
              PayoutStatus.succeeded,
            );
          },
        );


        it(
          "rejects when expectedProviderPayoutId does not match the attached ID",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .attachProviderPayoutId(
                payout.id,
                "mock-payout-actual",
              );

            await payoutService
              .markProcessing(
                payout.id,
              );

            await expect(
              payoutService
                .markSucceeded(
                  payout.id,
                  "mock-payout-wrong",
                ),
            ).rejects.toThrow(
              "Provider payout ID does not match the payout.",
            );

            const snapshot =
              await db
                .collection("tutorPayouts")
                .doc(payout.id)
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              PayoutStatus.processing,
            );
          },
        );


        it(
          "rejects when expectedProviderPayoutId is given but no provider payout ID is attached yet",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await expect(
              payoutService
                .markSucceeded(
                  payout.id,
                  "mock-payout-not-yet-attached",
                ),
            ).rejects.toThrow(
              "Payout has no provider payout ID attached yet.",
            );
          },
        );
      },
    );

    describe(
      "markFailed (provider ID validation)",
      () => {

        it(
          "succeeds when expectedProviderPayoutId matches the attached ID",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .attachProviderPayoutId(
                payout.id,
                "mock-payout-match",
              );

            await payoutService
              .markProcessing(
                payout.id,
              );

            const result =
              await payoutService
                .markFailed(
                  payout.id,
                  "Provider declined.",
                  "mock-payout-match",
                );

            expect(
              result.status,
            ).toBe(
              PayoutStatus.failed,
            );

            expect(
              result.failureReason,
            ).toBe(
              "Provider declined.",
            );
          },
        );


        it(
          "rejects when expectedProviderPayoutId does not match the attached ID",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await payoutService
              .attachProviderPayoutId(
                payout.id,
                "mock-payout-actual",
              );

            await payoutService
              .markProcessing(
                payout.id,
              );

            await expect(
              payoutService
                .markFailed(
                  payout.id,
                  "Provider declined.",
                  "mock-payout-wrong",
                ),
            ).rejects.toThrow(
              "Provider payout ID does not match the payout.",
            );

            const snapshot =
              await db
                .collection("tutorPayouts")
                .doc(payout.id)
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              PayoutStatus.processing,
            );
          },
        );


        it(
          "rejects when expectedProviderPayoutId is given but no provider payout ID is attached yet",
          async () => {
            const {
              booking,
              payment,
            } =
              await seedEligiblePayout();

            const {
              payout,
            } =
              await payoutService.createPayout({
                booking,
                payment,
              });

            await expect(
              payoutService
                .markFailed(
                  payout.id,
                  "Provider declined.",
                  "mock-payout-not-yet-attached",
                ),
            ).rejects.toThrow(
              "Payout has no provider payout ID attached yet.",
            );
          },
        );
      },
    );
  },
);




// Eligibility
//     ↓
// PayoutService
//     ↓
// TutorPayout
//     ↕ atomic
// PayoutTransactionService
//     ↓
// Transaction

// $env:FIRESTORE_EMULATOR_HOST="127.0.0.1:8080"
// $env:GCLOUD_PROJECT="mathmatric-c4bcc"
// $env:FIREBASE_CONFIG='{"projectId":"mathmatric-c4bcc"}'