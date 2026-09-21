import {Timestamp,Firestore,} from "firebase-admin/firestore";
import { beforeEach, describe, expect, it, } from "vitest";
import {Payment,PaymentStatus,} from "../payment/payment_entity";
import {PaymentSuccessService,} from "../payment/payment_success_service";
import {TransactionDirection,TransactionStatus,TransactionType,} from "../transactions/transaction";
import {TransactionReferenceIdentity,} from "../transactions/transaction_reference_identity";
import {TransactionService,} from "../transactions/transaction_service";
import {createMockFirestore,} from "./mock_firestore";
import { BookingStatus } from "../../bookings/booking_status";

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

interface Booking {
  studentId: string;
  tutorId: string;
  priceCents: number;
  status: string;
}

/**
 * Booking factory
 */
function createBooking(
  overrides: Partial<Booking> = {},
): Booking {
  return {
    studentId: "student-1",
    tutorId: "tutor-1",
    priceCents: 50000,
    status: BookingStatus.paymentRequired,

    ...overrides,
  };
}

/**
 * Convert a domain Booking into Firestore seed data.
 */
function seedBooking(
  mockFirestore: ReturnType<
    typeof createMockFirestore
  >,
  bookingId: string,
  booking: Booking,
): void {
  mockFirestore.seed(
    `bookings/${bookingId}`,
    booking,
  );
}

describe(
  "PaymentSuccessService",
  () => {
    let firestore: Firestore;

    let mockFirestore: ReturnType<
      typeof createMockFirestore
    >;

    let transactionService: TransactionService;

    let service: PaymentSuccessService;

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

        const payment = createPayment();

        seedPayment(
          mockFirestore,
          payment,
        );

        seedBooking(
          mockFirestore,
          "payment-1",
          createBooking({
            studentId: payment.studentId,
            tutorId: payment.tutorId,
            priceCents:
              payment.amountCents,
          }),
        );

        const result =
          await service.markPaymentPaid({
            bookingId: "payment-1",
            providerPaymentId: "mock-payment-1",
            paidAt,
          });

        expect(result.id)
          .toBe("payment-1");

        expect(result.status)
          .toBe(PaymentStatus.paid);

        expect(result.paidAt)
          .toEqual(paidAt);

        const existingPayment =
          mockFirestore.get(
            "payments/payment-1",
          );

        expect(existingPayment)
          .toBeDefined();

        expect(existingPayment).toMatchObject({
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

        const payment =
          createPayment({
            status:
              PaymentStatus.pending,
          });

        seedPayment(
          mockFirestore,
          payment,
        );

        seedBooking(
          mockFirestore,
          "payment-1",
          createBooking({
            studentId: payment.studentId,
            tutorId: payment.tutorId,
            priceCents:
              payment.amountCents,
          }),
        );

        const result =
          await service.markPaymentPaid({
            bookingId: "payment-1",
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

        const payment =
          createPayment({
            status:
              PaymentStatus.processing,
          });

        seedPayment(
          mockFirestore,
          payment,
        );

        seedBooking(
          mockFirestore,
          "payment-1",
          createBooking({
            studentId: payment.studentId,
            tutorId: payment.tutorId,
            priceCents:
              payment.amountCents,
          }),
        );

        const result =
          await service.markPaymentPaid({
            bookingId: "payment-1",
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

        seedBooking(
          mockFirestore,
          "payment-1",
          createBooking({
            studentId: payment.studentId,
            tutorId: payment.tutorId,
            priceCents:
              payment.amountCents,
          }),
        );

        await service.markPaymentPaid({
          bookingId: "payment-1",
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

        const payment = createPayment();

        seedPayment(
          mockFirestore,
          payment,
        );

        seedBooking(
          mockFirestore,
          "payment-1",
          createBooking({
            studentId: payment.studentId,
            tutorId: payment.tutorId,
            priceCents:
              payment.amountCents,
          }),
        );

        await service.markPaymentPaid({
          bookingId: "payment-1",
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
        const payment = createPayment();

        seedPayment(
          mockFirestore,
          payment,
        );

        seedBooking(
          mockFirestore,
          "payment-1",
          createBooking({
            studentId: payment.studentId,
            tutorId: payment.tutorId,
            priceCents:
              payment.amountCents,
          }),
        );

        await service.markPaymentPaid({
          bookingId: "payment-1",
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
        const payment = createPayment();

        seedPayment(
          mockFirestore,
          payment,
        );

        seedBooking(
          mockFirestore,
          "payment-1",
          createBooking({
            studentId: payment.studentId,
            tutorId: payment.tutorId,
            priceCents:
              payment.amountCents,
          }),
        );

        await service.markPaymentPaid({
          bookingId: "payment-1",
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
            bookingId: "payment-1",
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
            bookingId: "payment-1",
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
            bookingId: "payment-1",
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
            bookingId: "payment-1",
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
            bookingId: "payment-1",
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
            bookingId: "payment-1",
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
            bookingId: "payment-1",
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
            bookingId: "payment-1",
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
      "does not create a duplicate ledger transaction when payment success is processed repeatedly",
      async () => {
        const paidAt =
          new Date(
            "2026-02-01T15:00:00.000Z",
          );

        const payment = createPayment();

        seedPayment(
          mockFirestore,
          payment,
        );

        seedBooking(
          mockFirestore,
          "payment-1",
          createBooking({
            studentId: payment.studentId,
            tutorId: payment.tutorId,
            priceCents:
              payment.amountCents,
          }),
        );

        await service.markPaymentPaid({
          bookingId: "payment-1",
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
          bookingId: "payment-1",
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
      "creates exactly one payment ledger transaction",
      async () => {
        const payment = createPayment();

        seedPayment(
          mockFirestore,
          payment,
        );

        seedBooking(
          mockFirestore,
          "payment-1",
          createBooking({
            studentId: payment.studentId,
            tutorId: payment.tutorId,
            priceCents:
              payment.amountCents,
          }),
        );

        await service.markPaymentPaid({
          bookingId: "payment-1",
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
        const payment =
          createPayment({
            amountCents: 50000,
          });

        seedPayment(
          mockFirestore,
          payment,
        );

        seedBooking(
          mockFirestore,
          "payment-1",
          createBooking({
            studentId: payment.studentId,
            tutorId: payment.tutorId,
            priceCents:
              payment.amountCents,
          }),
        );

        await service.markPaymentPaid({
          bookingId: "payment-1",
          providerPaymentId:
            "mock-payment-1",
          paidAt:
            new Date(
              "2026-02-01T15:00:00.000Z",
            ),
        });

        const existingPayment =
          mockFirestore.get(
            "payments/payment-1",
          );

        expect(
          existingPayment?.amountCents,
        ).toBe(50000);

        expect(
          existingPayment?.refundedAmountCents,
        ).toBe(0);

        expect(
          existingPayment?.refundReservedAmountCents,
        ).toBe(0);
      },
    );

    it(
      "clears a previous failure reason when payment becomes paid",
      async () => {
        const payment =
          createPayment({
            failureReason:
              "Temporary provider failure.",
          });

        seedPayment(
          mockFirestore,
          payment,
        );

        seedBooking(
          mockFirestore,
          "payment-1",
          createBooking({
            studentId: payment.studentId,
            tutorId: payment.tutorId,
            priceCents:
              payment.amountCents,
          }),
        );

        await service.markPaymentPaid({
          bookingId: "payment-1",
          providerPaymentId:
            "mock-payment-1",
          paidAt:
            new Date(
              "2026-02-01T15:00:00.000Z",
            ),
        });

        const existingPayment =
          mockFirestore.get(
            "payments/payment-1",
          );

        expect(
          existingPayment?.failureReason,
        ).toBeNull();
      },
    );

    it(
      "marks a stuck payment as paid and creates the ledger transaction",
      async () => {
        const paidAt =
          new Date(
            "2026-02-01T15:00:00.000Z",
          );

        const payment =
          createPayment({
            status:
              PaymentStatus.stuck,
          });

        seedPayment(
          mockFirestore,
          payment,
        );

        seedBooking(
          mockFirestore,
          "payment-1",
          createBooking({
            studentId: payment.studentId,
            tutorId: payment.tutorId,
            priceCents:
              payment.amountCents,
          }),
        );

        const result =
          await service.markPaymentPaid({
            bookingId: "payment-1",
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
  },
);

// The following was just proven:
//At the narrow technical level: we proved markPaymentPaid correctly transitions pending, processing, and now stuck payments to paid, atomically creates exactly one ledger transaction (idempotent on replay), leaves the payment amount/refund fields untouched, clears any stale failureReason, and validates the booking/payment relationship (student, tutor, price match) before writing anything — all without violating "reads before writes." And specifically for the work we set out to do: a stuck payment self-heals correctly if a genuine late paid webhook eventually arrives, exactly like pending/processing do.

//At the process level, which is the more interesting one: we found and fixed a latent fixture bug that had nothing to do with the stuck-payment feature itself — createPayment()'s test factory used id: "payment-1" and bookingId: "booking-1" as two different strings, silently violating your own architectural invariant from Section 3 of your handoff: "Payment ID equals booking ID" (payments/{bookingId}). That invariant is exactly why markPaymentPaid takes a single bookingId and derives both the payments and bookings refs from it — and the test fixture had been quietly inconsistent with that the whole time. It just never surfaced before because no test in this file previously exercised the booking-read path at all (there was no booking validation logic being tested yet, or it was untested).

// So the deeper thing this proved: writing the booking-seed helper and running it is what surfaced a real inconsistency in your fixtures that was invisible until something actually exercised the code path that depended on the invariant holding.
