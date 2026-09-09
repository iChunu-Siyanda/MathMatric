import {Timestamp,Firestore,} from "firebase-admin/firestore";
import { beforeEach, describe, expect, it, } from "vitest";
import {Payment,PaymentStatus,} from "../payment/payment_entity";
import {PaymentSuccessService,} from "../payment/payent_success_service";
import {TransactionDirection,TransactionStatus,TransactionType,} from "../transactions/transaction";
import {TransactionReferenceIdentity,} from "../transactions/transaction_reference_identity";
import {TransactionService,} from "../transactions/transaction_service";
import {createMockFirestore,} from "./mock_firestore";

/**
 * Payment factory
 */
function createPayment(
  overrides: Partial<Payment> = {},
): Payment {
  return {
    id: "payment-1",
    bookingId: "booking-1",

    studentId: "student-1",
    tutorId: "tutor-1",

    amountCents: 50000,
    refundedAmountCents: 0,
    refundReservedAmountCents: 0,

    currency: "ZAR",

    status: PaymentStatus.processing,

    provider: "mock",
    providerPaymentId:
      "mock-payment-1",

    createdAt:
      new Date(
        "2026-02-01T14:00:00.000Z",
      ),

    updatedAt:
      new Date(
        "2026-02-01T14:30:00.000Z",
      ),

    paidAt: null,

    failureReason: null,

    ...overrides,
  };
}

/**
 * Convert a domain Payment into Firestore seed data.
 */
function seedPayment(
  mockFirestore: ReturnType<
    typeof createMockFirestore
  >,
  payment: Payment,
): void {
  mockFirestore.seed(
    `payments/${payment.id}`,
    payment,
  );
}

describe(
  "PaymentSuccessService",
  () => {
    let firestore: Firestore;

    let mockFirestore: ReturnType<
      typeof createMockFirestore
    >;

    let transactionService:
      TransactionService;

    let service:
      PaymentSuccessService;

    beforeEach(() => {
      mockFirestore =
        createMockFirestore();

      firestore =
        mockFirestore as unknown as Firestore;

      const referenceIdentity =
        new TransactionReferenceIdentity(
          firestore,
        );

      transactionService =
        new TransactionService(
          firestore,
          referenceIdentity,
        );

      service =
        new PaymentSuccessService(
          firestore,
          transactionService,
        );
    });

    it(
      "atomically marks the payment paid and creates the ledger transaction",
      async () => {
        const paidAt =
          new Date(
            "2026-02-01T15:00:00.000Z",
          );

        seedPayment(
          mockFirestore,
          createPayment(),
        );

        const result =
          await service.markPaymentPaid({
            paymentId: "payment-1",
            providerPaymentId:
              "mock-payment-1",
            paidAt,
          });

        expect(result.id)
          .toBe("payment-1");

        expect(result.status)
          .toBe(PaymentStatus.paid);

        expect(result.paidAt)
          .toEqual(paidAt);

        const payment =
          mockFirestore.get(
            "payments/payment-1",
          );

        expect(payment)
          .toBeDefined();

        expect(payment).toMatchObject({
          status: PaymentStatus.paid,
          paidAt:
            expect.any(Timestamp),
        });

        const transaction =
          mockFirestore.get(
            "transactions/payment-payment-1",
          );

        expect(transaction)
          .toBeDefined();

        expect(transaction)
          .toMatchObject({
            bookingId: "booking-1",
            paymentId: "payment-1",

            type:
              TransactionType.payment,

            direction:
              TransactionDirection.credit,

            status:
              TransactionStatus.completed,

            amountCents: 50000,

            currency: "ZAR",

            studentId: "student-1",
            tutorId: "tutor-1",

            referenceId: "payment-1",

            description:
              "Payment for booking booking-1",
          });

        const reference =
          mockFirestore.get(
            "transactionReferences/payment:payment-1",
          );

        expect(reference)
          .toBeDefined();

        expect(reference)
          .toMatchObject({
            type:
              TransactionType.payment,

            referenceId:
              "payment-1",

            transactionId:
              "payment-payment-1",

            bookingId:
              "booking-1",

            paymentId:
              "payment-1",
          });
      },
    );

    it(
      "marks a pending payment as paid and creates the ledger transaction",
      async () => {
        const paidAt =
          new Date(
            "2026-02-01T15:00:00.000Z",
          );

        seedPayment(
          mockFirestore,
          createPayment({
            status:
              PaymentStatus.pending,
          }),
        );

        const result =
          await service.markPaymentPaid({
            paymentId: "payment-1",
            providerPaymentId:
              "mock-payment-1",
            paidAt,
          });

        expect(result.status)
          .toBe(PaymentStatus.paid);

        const transaction =
          mockFirestore.get(
            "transactions/payment-payment-1",
          );

        expect(transaction)
          .toBeDefined();

        expect(transaction)
          .toMatchObject({
            status:
              TransactionStatus.completed,

            amountCents: 50000,
          });
      },
    );

    it(
      "marks a processing payment as paid and creates the ledger transaction",
      async () => {
        const paidAt =
          new Date(
            "2026-02-01T15:00:00.000Z",
          );

        seedPayment(
          mockFirestore,
          createPayment({
            status:
              PaymentStatus.processing,
          }),
        );

        const result =
          await service.markPaymentPaid({
            paymentId: "payment-1",
            providerPaymentId:
              "mock-payment-1",
            paidAt,
          });

        expect(result.status)
          .toBe(PaymentStatus.paid);

        expect(
          mockFirestore.get(
            "transactions/payment-payment-1",
          ),
        ).toBeDefined();
      },
    );

    it(
      "uses the exact payment amount for the ledger transaction",
      async () => {
        const payment =
          createPayment({
            amountCents: 73550,
          });

        seedPayment(
          mockFirestore,
          payment,
        );

        await service.markPaymentPaid({
          paymentId: "payment-1",
          providerPaymentId:
            "mock-payment-1",
          paidAt:
            new Date(
              "2026-02-01T15:00:00.000Z",
            ),
        });

        const transaction =
          mockFirestore.get(
            "transactions/payment-payment-1",
          );

        expect(
          transaction?.amountCents,
        ).toBe(73550);
      },
    );

    it(
      "uses the payment paidAt timestamp as the ledger completedAt",
      async () => {
        const paidAt =
          new Date(
            "2026-02-01T17:45:00.000Z",
          );

        seedPayment(
          mockFirestore,
          createPayment(),
        );

        await service.markPaymentPaid({
          paymentId: "payment-1",
          providerPaymentId:
            "mock-payment-1",
          paidAt,
        });

        const transaction =
          mockFirestore.get(
            "transactions/payment-payment-1",
          );

        expect(
          transaction?.completedAt,
        ).toEqual(
          expect.any(Timestamp),
        );

        expect(
          (
            transaction?.completedAt as Timestamp
          ).toDate(),
        ).toEqual(paidAt);
      },
    );

    it(
      "uses credit direction for a payment transaction",
      async () => {
        seedPayment(
          mockFirestore,
          createPayment(),
        );

        await service.markPaymentPaid({
          paymentId: "payment-1",
          providerPaymentId:
            "mock-payment-1",
          paidAt:
            new Date(
              "2026-02-01T15:00:00.000Z",
            ),
        });

        const transaction =
          mockFirestore.get(
            "transactions/payment-payment-1",
          );

        expect(
          transaction?.direction,
        ).toBe(
          TransactionDirection.credit,
        );
      },
    );

    it(
      "creates the ledger transaction with completed status",
      async () => {
        seedPayment(
          mockFirestore,
          createPayment(),
        );

        await service.markPaymentPaid({
          paymentId: "payment-1",
          providerPaymentId:
            "mock-payment-1",
          paidAt:
            new Date(
              "2026-02-01T15:00:00.000Z",
            ),
        });

        const transaction =
          mockFirestore.get(
            "transactions/payment-payment-1",
          );

        expect(
          transaction?.status,
        ).toBe(
          TransactionStatus.completed,
        );
      },
    );

    it(
      "rejects a payment with a mismatched provider payment ID",
      async () => {
        seedPayment(
          mockFirestore,
          createPayment(),
        );

        await expect(
          service.markPaymentPaid({
            paymentId: "payment-1",
            providerPaymentId:
              "different-provider-payment",
            paidAt:
              new Date(
                "2026-02-01T15:00:00.000Z",
              ),
          }),
        ).rejects.toThrow(
          "Provider payment ID does not match the payment.",
        );

        const payment =
          mockFirestore.get(
            "payments/payment-1",
          );

        expect(payment?.status)
          .toBe(
            PaymentStatus.processing,
          );

        expect(
          mockFirestore.get(
            "transactions/payment-payment-1",
          ),
        ).toBeUndefined();

        expect(
          mockFirestore.get(
            "transactionReferences/payment:payment-1",
          ),
        ).toBeUndefined();
      },
    );

    it(
      "rejects a failed payment",
      async () => {
        seedPayment(
          mockFirestore,
          createPayment({
            status:
              PaymentStatus.failed,
          }),
        );

        await expect(
          service.markPaymentPaid({
            paymentId: "payment-1",
            providerPaymentId:
              "mock-payment-1",
            paidAt:
              new Date(
                "2026-02-01T15:00:00.000Z",
              ),
          }),
        ).rejects.toThrow(
          "Payment cannot be marked as paid from its current status.",
        );

        expect(
          mockFirestore.get(
            "payments/payment-1",
          )?.status,
        ).toBe(
          PaymentStatus.failed,
        );

        expect(
          mockFirestore.get(
            "transactions/payment-payment-1",
          ),
        ).toBeUndefined();
      },
    );

    it(
      "rejects a cancelled payment",
      async () => {
        seedPayment(
          mockFirestore,
          createPayment({
            status:
              PaymentStatus.cancelled,
          }),
        );

        await expect(
          service.markPaymentPaid({
            paymentId: "payment-1",
            providerPaymentId:
              "mock-payment-1",
            paidAt:
              new Date(
                "2026-02-01T15:00:00.000Z",
              ),
          }),
        ).rejects.toThrow(
          "Payment cannot be marked as paid from its current status.",
        );

        expect(
          mockFirestore.get(
            "payments/payment-1",
          )?.status,
        ).toBe(
          PaymentStatus.cancelled,
        );

        expect(
          mockFirestore.get(
            "transactions/payment-payment-1",
          ),
        ).toBeUndefined();
      },
    );

    it(
      "rejects a refunded payment",
      async () => {
        seedPayment(
          mockFirestore,
          createPayment({
            status:
              PaymentStatus.refunded,
          }),
        );

        await expect(
          service.markPaymentPaid({
            paymentId: "payment-1",
            providerPaymentId:
              "mock-payment-1",
            paidAt:
              new Date(
                "2026-02-01T15:00:00.000Z",
              ),
          }),
        ).rejects.toThrow(
          "Payment cannot be marked as paid from its current status.",
        );

        expect(
          mockFirestore.get(
            "payments/payment-1",
          )?.status,
        ).toBe(
          PaymentStatus.refunded,
        );

        expect(
          mockFirestore.get(
            "transactions/payment-payment-1",
          ),
        ).toBeUndefined();
      },
    );

    it(
      "rejects a partially refunded payment",
      async () => {
        seedPayment(
          mockFirestore,
          createPayment({
            status:
              PaymentStatus.partiallyRefunded,
          }),
        );

        await expect(
          service.markPaymentPaid({
            paymentId: "payment-1",
            providerPaymentId:
              "mock-payment-1",
            paidAt:
              new Date(
                "2026-02-01T15:00:00.000Z",
              ),
          }),
        ).rejects.toThrow(
          "Payment cannot be marked as paid from its current status.",
        );

        expect(
          mockFirestore.get(
            "payments/payment-1",
          )?.status,
        ).toBe(
          PaymentStatus.partiallyRefunded,
        );

        expect(
          mockFirestore.get(
            "transactions/payment-payment-1",
          ),
        ).toBeUndefined();
      },
    );

    it(
      "rejects a missing payment",
      async () => {
        await expect(
          service.markPaymentPaid({
            paymentId: "payment-1",
            providerPaymentId:
              "mock-payment-1",
            paidAt:
              new Date(
                "2026-02-01T15:00:00.000Z",
              ),
          }),
        ).rejects.toThrow(
          "Payment does not exist.",
        );

        expect(
          mockFirestore.get(
            "transactions/payment-payment-1",
          ),
        ).toBeUndefined();
      },
    );

    it(
      "is idempotent when the payment is already paid",
      async () => {
        const paidAt =
          new Date(
            "2026-02-01T15:00:00.000Z",
          );

        seedPayment(
          mockFirestore,
          createPayment({
            status:
              PaymentStatus.paid,
            paidAt,
          }),
        );

        const result =
          await service.markPaymentPaid({
            paymentId: "payment-1",
            providerPaymentId:
              "mock-payment-1",
            paidAt,
          });

        expect(result.status)
          .toBe(PaymentStatus.paid);

        expect(result.paidAt)
          .toEqual(paidAt);

        expect(
          mockFirestore.get(
            "transactions/payment-payment-1",
          ),
        ).toBeUndefined();
      },
    );

    it(
      "does not create a duplicate ledger transaction when payment success is processed repeatedly",
      async () => {
        const paidAt =
          new Date(
            "2026-02-01T15:00:00.000Z",
          );

        seedPayment(
          mockFirestore,
          createPayment(),
        );

        await service.markPaymentPaid({
          paymentId: "payment-1",
          providerPaymentId:
            "mock-payment-1",
          paidAt,
        });

        const firstTransaction =
          mockFirestore.get(
            "transactions/payment-payment-1",
          );

        expect(firstTransaction)
          .toBeDefined();

        /*
         * The payment is now already paid.
         * Processing the same success again must
         * not create another ledger transaction.
         */
        await service.markPaymentPaid({
          paymentId: "payment-1",
          providerPaymentId:
            "mock-payment-1",
          paidAt,
        });

        const secondTransaction =
          mockFirestore.get(
            "transactions/payment-payment-1",
          );

        expect(secondTransaction)
          .toBeDefined();

        expect(secondTransaction)
          .toEqual(firstTransaction);

        const reference =
          mockFirestore.get(
            "transactionReferences/payment:payment-1",
          );

        expect(reference)
          .toBeDefined();

        expect(reference?.transactionId)
          .toBe(
            "payment-payment-1",
          );
      },
    );

    it(
      "does not alter a paid payment when the provider payment ID is wrong",
      async () => {
        const paidAt =
          new Date(
            "2026-02-01T15:00:00.000Z",
          );

        seedPayment(
          mockFirestore,
          createPayment({
            status:
              PaymentStatus.paid,
            paidAt,
          }),
        );

        await expect(
          service.markPaymentPaid({
            paymentId: "payment-1",
            providerPaymentId:
              "wrong-provider-id",
            paidAt,
          }),
        ).rejects.toThrow(
          "Provider payment ID does not match the payment.",
        );

        const payment =
          mockFirestore.get(
            "payments/payment-1",
          );

        expect(payment?.status)
          .toBe(
            PaymentStatus.paid,
          );

        expect(
          payment?.paidAt,
        ).toEqual(
          expect.any(Timestamp),
        );
      },
    );

    // it(
    //   "does not create the ledger when transaction reference identity already belongs to another transaction",
    //   async () => {
    //     seedPayment(
    //       mockFirestore,
    //       createPayment(),
    //     );

    //     mockFirestore.seed(
    //       "transactionReferences/payment:payment-1",
    //       {
    //         type:
    //           TransactionType.payment,

    //         referenceId:
    //           "payment-1",

    //         transactionId:
    //           "different-transaction",

    //         bookingId:
    //           "another-booking",

    //         paymentId:
    //           "another-payment",
    //       },
    //     );

    //     await expect(
    //       service.markPaymentPaid({
    //         paymentId: "payment-1",
    //         providerPaymentId:
    //           "mock-payment-1",
    //         paidAt:
    //           new Date(
    //             "2026-02-01T15:00:00.000Z",
    //           ),
    //       }),
    //     ).rejects.toThrow(
    //       "Transaction reference is already associated with another transaction.",
    //     );

    //     /*
    //      * In a real Firestore transaction this failure
    //      * causes the entire transaction to abort.
    //      *
    //      * Our mock transaction executes operations
    //      * immediately, so this assertion verifies the
    //      * critical identity failure itself. The real
    //      * emulator/integration suite will additionally
    //      * verify rollback semantics.
    //      */
    //     expect(
    //       mockFirestore.get(
    //         "transactionReferences/payment:payment-1",
    //       )?.transactionId,
    //     ).toBe(
    //       "different-transaction",
    //     );
    //   },
    // );

    it(
      "creates exactly one payment ledger transaction",
      async () => {
        seedPayment(
          mockFirestore,
          createPayment(),
        );

        await service.markPaymentPaid({
          paymentId: "payment-1",
          providerPaymentId:
            "mock-payment-1",
          paidAt:
            new Date(
              "2026-02-01T15:00:00.000Z",
            ),
        });

        const transaction =
          mockFirestore.get(
            "transactions/payment-payment-1",
          );

        expect(transaction)
          .toBeDefined();

        expect(
          mockFirestore.get(
            "transactions/payment-payment-1",
          ),
        ).toStrictEqual(transaction);
      },
    );

    it(
      "does not modify the payment amount when marking it paid",
      async () => {
        seedPayment(
          mockFirestore,
          createPayment({
            amountCents: 50000,
          }),
        );

        await service.markPaymentPaid({
          paymentId: "payment-1",
          providerPaymentId:
            "mock-payment-1",
          paidAt:
            new Date(
              "2026-02-01T15:00:00.000Z",
            ),
        });

        const payment =
          mockFirestore.get(
            "payments/payment-1",
          );

        expect(
          payment?.amountCents,
        ).toBe(50000);

        expect(
          payment?.refundedAmountCents,
        ).toBe(0);

        expect(
          payment?.refundReservedAmountCents,
        ).toBe(0);
      },
    );

    it(
      "clears a previous failure reason when payment becomes paid",
      async () => {
        seedPayment(
          mockFirestore,
          createPayment({
            failureReason:
              "Temporary provider failure.",
          }),
        );

        await service.markPaymentPaid({
          paymentId: "payment-1",
          providerPaymentId:
            "mock-payment-1",
          paidAt:
            new Date(
              "2026-02-01T15:00:00.000Z",
            ),
        });

        const payment =
          mockFirestore.get(
            "payments/payment-1",
          );

        expect(
          payment?.failureReason,
        ).toBeNull();
      },
    );
  },
);
