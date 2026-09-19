import { describe, expect, it, beforeEach } from "vitest";

import {
  Payment,
  PaymentStatus,
} from "../payment/payment_entity";

import {
  TransactionDirection,
  TransactionStatus,
  TransactionType,
} from "../transactions/transaction";

import {
  PaymentTransactionService,
} from "../transactions/payment_transaction_service";

import {
  TransactionService,
} from "../transactions/transaction_service";

import {
  TransactionReferenceIdentity,
} from "../transactions/transaction_reference_identity";

import {
  createMockFirestore,
} from "./mock_firestore";
import { Firestore } from "firebase-admin/firestore";

describe(
  "PaymentTransactionService",
  () => {
    let firestore: Firestore;
    let mockFirestore: ReturnType<typeof createMockFirestore>;
    let service: PaymentTransactionService;
    let transactionService:TransactionService;
    
    beforeEach(() => {
      mockFirestore = createMockFirestore();
      firestore = mockFirestore as unknown as Firestore;

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
        new PaymentTransactionService(
          transactionService,
        );
    });

    it(
      "creates a completed payment transaction",
      async () => {
        const payment =
          createPaidPayment();

        const result =
          await service.createForPaidPayment(
            payment,
          );

        expect(result.created)
          .toBe(true);

        expect(
          result.transaction.id,
        ).toBe(
          "payment-payment-1",
        );

        expect(
          result.transaction.bookingId,
        ).toBe("booking-1");

        expect(
          result.transaction.paymentId,
        ).toBe("payment-1");

        expect(
          result.transaction.type,
        ).toBe(
          TransactionType.payment,
        );

        expect(
          result.transaction.direction,
        ).toBe(
          TransactionDirection.credit,
        );

        expect(
          result.transaction.status,
        ).toBe(
          TransactionStatus.completed,
        );

        expect(
          result.transaction.amountCents,
        ).toBe(50000);

        expect(
          result.transaction.currency,
        ).toBe("ZAR");

        expect(
          result.transaction.studentId,
        ).toBe("student-1");

        expect(
          result.transaction.tutorId,
        ).toBe("tutor-1");

        expect(
          result.transaction.referenceId,
        ).toBe("payment-1");

        expect(
          result.transaction.description,
        ).toBe(
          "Payment for booking booking-1",
        );

        expect(
          result.transaction.completedAt,
        ).toEqual(
          payment.paidAt,
        );
      },
    );

    it(
      "creates the transaction reference identity",
      async () => {
        const payment =
          createPaidPayment();

        await service.createForPaidPayment(
          payment,
        );

        const reference =  mockFirestore.get(
            "transactionReferences/payment:payment-1",
        );

        expect(reference).toBeDefined();

        expect(reference).toMatchObject({
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
      "is idempotent for the same paid payment",
      async () => {
        const payment =
          createPaidPayment();

        const first =
          await service.createForPaidPayment(
            payment,
          );

        const second =
          await service.createForPaidPayment(
            payment,
          );

        expect(first.created)
          .toBe(true);

        expect(second.created)
          .toBe(false);

        expect(
          second.transaction.id,
        ).toBe(
          first.transaction.id,
        );

        expect(
          second.transaction.amountCents,
        ).toBe(50000);
      },
    );

    it(
      "does not create duplicate transactions for repeated payment processing",
      async () => {
        const payment =
          createPaidPayment();

        await service.createForPaidPayment(
          payment,
        );

        await service.createForPaidPayment(
          payment,
        );

        await service.createForPaidPayment(
          payment,
        );

        const transaction = mockFirestore.get(
            "transactions/payment-payment-1",
        );

        expect(transaction).toBeDefined();

        const reference =
        mockFirestore.get(
            "transactionReferences/payment:payment-1",
        );

        expect(reference).toBeDefined();
      },
    );

    it(
      "rejects a pending payment",
      async () => {
        const payment =
          createPaidPayment({
            status:
              PaymentStatus.pending,

            paidAt: null,
          });

        await expect(
          service.createForPaidPayment(
            payment,
          ),
        ).rejects.toThrow(
          "A payment transaction can only be created for a paid payment.",
        );
      },
    );

    it(
      "rejects a processing payment",
      async () => {
        const payment =
          createPaidPayment({
            status:
              PaymentStatus.processing,

            paidAt: null,
          });

        await expect(
          service.createForPaidPayment(
            payment,
          ),
        ).rejects.toThrow(
          "A payment transaction can only be created for a paid payment.",
        );
      },
    );

    it(
      "rejects a failed payment",
      async () => {
        const payment =
          createPaidPayment({
            status:
              PaymentStatus.failed,

            paidAt: null,
          });

        await expect(
          service.createForPaidPayment(
            payment,
          ),
        ).rejects.toThrow(
          "A payment transaction can only be created for a paid payment.",
        );
      },
    );

    it(
      "rejects a cancelled payment",
      async () => {
        const payment =
          createPaidPayment({
            status:
              PaymentStatus.cancelled,

            paidAt: null,
          });

        await expect(
          service.createForPaidPayment(
            payment,
          ),
        ).rejects.toThrow(
          "A payment transaction can only be created for a paid payment.",
        );
      },
    );

    it(
      "rejects a refunded payment",
      async () => {
        const payment =
          createPaidPayment({
            status:
              PaymentStatus.refunded,
          });

        await expect(
          service.createForPaidPayment(
            payment,
          ),
        ).rejects.toThrow(
          "A payment transaction can only be created for a paid payment.",
        );
      },
    );

    it(
      "rejects a partially refunded payment",
      async () => {
        const payment =
          createPaidPayment({
            status:
              PaymentStatus.partiallyRefunded,
          });

        await expect(
          service.createForPaidPayment(
            payment,
          ),
        ).rejects.toThrow(
          "A payment transaction can only be created for a paid payment.",
        );
      },
    );

    it(
      "rejects a paid payment without paidAt",
      async () => {
        const payment =
          createPaidPayment({
            status:
              PaymentStatus.paid,

            paidAt: null,
          });

        await expect(
          service.createForPaidPayment(
            payment,
          ),
        ).rejects.toThrow(
          "A paid payment must have a paidAt timestamp.",
        );
      },
    );

    it(
      "uses the payment amount as the transaction amount",
      async () => {
        const payment =
          createPaidPayment({
            amountCents: 75000,
          });

        const result =
          await service.createForPaidPayment(
            payment,
          );

        expect(
          result.transaction.amountCents,
        ).toBe(75000);
      },
    );

    it(
      "uses the payment paidAt as transaction completedAt",
      async () => {
        const paidAt =
          new Date(
            "2026-02-01T15:30:00.000Z",
          );

        const payment =
          createPaidPayment({
            paidAt,
          });

        const result =
          await service.createForPaidPayment(
            payment,
          );

        expect(
          result.transaction.completedAt,
        ).toEqual(paidAt);
      },
    );
  },
);

function createPaidPayment(
  overrides: Partial<Payment> = {},
): Payment {
  const paidAt =
    new Date(
      "2026-02-01T15:00:00.000Z",
    );

  return {
    id: "payment-1",

    bookingId: "booking-1",

    studentId: "student-1",

    tutorId: "tutor-1",

    amountCents: 50000,

    refundedAmountCents: 0,

    refundReservedAmountCents: 0,

    currency: "ZAR",

    status: PaymentStatus.paid,

    provider: "mock",

    providerPaymentId:
      "mock-payment-1",

    createdAt:
      new Date(
        "2026-02-01T14:00:00.000Z",
      ),

    updatedAt:
      new Date(
        "2026-02-01T15:00:00.000Z",
      ),

    paidAt,

    failureReason: null,

    ...overrides,
  };
}
