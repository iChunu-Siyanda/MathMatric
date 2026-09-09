import {
  beforeEach,
  describe,
  expect,
  it,
} from "vitest";
import {Timestamp,} from "firebase-admin/firestore";
import {TransactionDirection,TransactionStatus,TransactionType,} from "../transactions/transaction";
import {TransactionReferenceIdentity,} from "../transactions/transaction_reference_identity";
import {TransactionService,} from "../transactions/transaction_service";
import {createMockFirestore,} from "./mock_firestore";


describe("TransactionService", () => {
  const firestore =
    createMockFirestore();

  const referenceIdentity =
    new TransactionReferenceIdentity(
      firestore as any,
    );

  const service =
    new TransactionService(
      firestore as any,
      referenceIdentity,
    );

  const baseInput = {
    transactionId:
      "transaction-1",

    bookingId:
      "booking-1",

    paymentId:
      "booking-1",

    type:
      TransactionType.payment,

    direction:
      TransactionDirection.credit,

    status:
      TransactionStatus.completed,

    amountCents:
      50000,

    currency:
      "ZAR" as const,

    studentId:
      "student-1",

    tutorId:
      "tutor-1",

    referenceId:
      "payment:booking-1",

    description:
      "Tutor lesson payment",

    completedAt:
      new Date(
        "2026-09-09T10:00:00.000Z",
      ),
  };


  beforeEach(() => {
    firestore.clear();
  });


  it("creates a transaction", async () => {
    const result =
      await service.createTransaction(
        baseInput,
      );

    expect(
      result.created,
    ).toBe(true);

    expect(
      result.transaction,
    ).toMatchObject({
      id:
        "transaction-1",

      bookingId:
        "booking-1",

      paymentId:
        "booking-1",

      type:
        TransactionType.payment,

      direction:
        TransactionDirection.credit,

      status:
        TransactionStatus.completed,

      amountCents:
        50000,

      currency:
        "ZAR",

      studentId:
        "student-1",

      tutorId:
        "tutor-1",

      referenceId:
        "payment:booking-1",

      description:
        "Tutor lesson payment",
    });

    const stored =
      firestore.get(
        "transactions/transaction-1",
      );

    expect(
      stored,
    ).toBeDefined();

    expect(
      stored?.amountCents,
    ).toBe(50000);

    expect(
      stored?.status,
    ).toBe(
      TransactionStatus.completed,
    );

    expect(
      stored?.createdAt,
    ).toBeInstanceOf(
      Timestamp,
    );
  });


  it("creates the transaction reference identity", async () => {
    await service.createTransaction(
      baseInput,
    );

    const identity =
      firestore.get(
        "transactionReferences/payment:payment:booking-1",
      );

    expect(
      identity,
    ).toBeDefined();

    expect(
      identity?.transactionId,
    ).toBe(
      "transaction-1",
    );

    expect(
      identity?.referenceId,
    ).toBe(
      "payment:booking-1",
    );

    expect(
      identity?.type,
    ).toBe(
      TransactionType.payment,
    );
  });


  it("is idempotent when the same transaction ID is submitted again", async () => {
    const first =
      await service.createTransaction(
        baseInput,
      );

    const second =
      await service.createTransaction(
        baseInput,
      );

    expect(
      first.created,
    ).toBe(true);

    expect(
      second.created,
    ).toBe(false);

    expect(
      second.transaction.id,
    ).toBe(
      first.transaction.id,
    );

    expect(
      second.transaction.amountCents,
    ).toBe(50000);
  });


  it("rejects the same transaction ID for different financial data", async () => {
    await service.createTransaction(
      baseInput,
    );

    await expect(
      service.createTransaction({
        ...baseInput,

        referenceId:
          "payment:booking-2",
      }),
    ).rejects.toThrow(
      "Transaction ID is already associated with different financial data.",
    );
  });


  it("rejects the same reference for a different transaction", async () => {
    await service.createTransaction(
      baseInput,
    );

    await expect(
      service.createTransaction({
        ...baseInput,

        transactionId:
          "transaction-2",
      }),
    ).rejects.toThrow(
      "Transaction reference is already associated with another transaction.",
    );
  });


  it("allows different references for different transactions", async () => {
    await service.createTransaction(
      baseInput,
    );

    const result =
      await service.createTransaction({
        ...baseInput,

        transactionId:
          "transaction-2",

        referenceId:
          "refund:refund-1",

        type:
          TransactionType.refund,

        direction:
          TransactionDirection.debit,

        description:
          "Customer refund",
      });

    expect(
      result.created,
    ).toBe(true);

    expect(
      result.transaction.type,
    ).toBe(
      TransactionType.refund,
    );

    expect(
      result.transaction.direction,
    ).toBe(
      TransactionDirection.debit,
    );
  });


  it("allows a refund transaction to have the same booking and payment", async () => {
    const result =
      await service.createTransaction({
        ...baseInput,

        transactionId:
          "refund-transaction-1",

        type:
          TransactionType.refund,

        direction:
          TransactionDirection.debit,

        referenceId:
          "refund:refund-1",

        description:
          "Refund for cancelled lesson",
      });

    expect(
      result.transaction.bookingId,
    ).toBe(
      "booking-1",
    );

    expect(
      result.transaction.paymentId,
    ).toBe(
      "booking-1",
    );

    expect(
      result.transaction.amountCents,
    ).toBe(
      50000,
    );
  });


  it("rejects a zero amount", async () => {
    await expect(
      service.createTransaction({
        ...baseInput,
        amountCents: 0,
      }),
    ).rejects.toThrow(
      "Amount must be a positive integer.",
    );
  });


  it("rejects a negative amount", async () => {
    await expect(
      service.createTransaction({
        ...baseInput,
        amountCents: -100,
      }),
    ).rejects.toThrow(
      "Amount must be a positive integer.",
    );
  });


  it("rejects a fractional amount", async () => {
    await expect(
      service.createTransaction({
        ...baseInput,
        amountCents: 100.5,
      }),
    ).rejects.toThrow(
      "Amount must be a positive integer.",
    );
  });


  it("rejects an unsupported currency", async () => {
    await expect(
      service.createTransaction({
        ...baseInput,
        currency:
          "USD" as "ZAR",
      }),
    ).rejects.toThrow(
      "Unsupported currency.",
    );
  });


  it("rejects an empty transaction ID", async () => {
    await expect(
      service.createTransaction({
        ...baseInput,
        transactionId: "   ",
      }),
    ).rejects.toThrow(
      "transactionId is required.",
    );
  });


  it("rejects an empty reference ID", async () => {
    await expect(
      service.createTransaction({
        ...baseInput,
        referenceId: "   ",
      }),
    ).rejects.toThrow(
      "referenceId is required.",
    );
  });


  it("rejects an empty description", async () => {
    await expect(
      service.createTransaction({
        ...baseInput,
        description: "   ",
      }),
    ).rejects.toThrow(
      "description is required.",
    );
  });


  it("creates a failed transaction without a completion timestamp", async () => {
    const result =
      await service.createTransaction({
        ...baseInput,

        transactionId:
          "transaction-failed",

        referenceId:
          "payment-failed:booking-1",

        status:
          TransactionStatus.failed,

        completedAt:
          null,

        description:
          "Failed tutor lesson payment",
      });

    expect(
      result.created,
    ).toBe(true);

    expect(
      result.transaction.status,
    ).toBe(
      TransactionStatus.failed,
    );

    expect(
      result.transaction.completedAt,
    ).toBeNull();
  });


  it("creates a payout transaction", async () => {
    const result =
      await service.createTransaction({
        ...baseInput,

        transactionId:
          "payout-transaction-1",

        type:
          TransactionType.payout,

        direction:
          TransactionDirection.debit,

        referenceId:
          "payout:payout-1",

        amountCents:
          40000,

        description:
          "Tutor payout",
      });

    expect(
      result.created,
    ).toBe(true);

    expect(
      result.transaction.type,
    ).toBe(
      TransactionType.payout,
    );

    expect(
      result.transaction.direction,
    ).toBe(
      TransactionDirection.debit,
    );

    expect(
      result.transaction.amountCents,
    ).toBe(40000);
  });


  it("creates a platform fee transaction", async () => {
    const result =
      await service.createTransaction({
        ...baseInput,

        transactionId:
          "fee-transaction-1",

        type:
          TransactionType.platformFee,

        direction:
          TransactionDirection.credit,

        referenceId:
          "fee:booking-1",

        amountCents:
          10000,

        description:
          "MathMatric platform fee",
      });

    expect(
      result.created,
    ).toBe(true);

    expect(
      result.transaction.type,
    ).toBe(
      TransactionType.platformFee,
    );

    expect(
      result.transaction.amountCents,
    ).toBe(10000);
  });


  it("creates an adjustment transaction", async () => {
    const result =
      await service.createTransaction({
        ...baseInput,

        transactionId:
          "adjustment-transaction-1",

        type:
          TransactionType.adjustment,

        direction:
          TransactionDirection.credit,

        referenceId:
          "adjustment:adjustment-1",

        description:
          "Financial adjustment",
      });

    expect(
      result.created,
    ).toBe(true);

    expect(
      result.transaction.type,
    ).toBe(
      TransactionType.adjustment,
    );
  });
});
