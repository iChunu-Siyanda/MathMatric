import { Timestamp, Firestore } from "firebase-admin/firestore";
import { beforeEach, describe, expect, it } from "vitest";
import {
  TransactionDirection,
  TransactionStatus,
  TransactionType,
} from "../../transactions/transaction";
import { TransactionReferenceIdentity } from "../../transactions/transaction_reference_identity";
import { TransactionService } from "../../transactions/transaction_service";
import { createMockFirestore } from "../../tests/mock_firestore";
import { MasterclassPayment, MasterclassPaymentStatus } from "../../masterclasses/payment/masterclass_payment_entity";
import { MasterclassEnrollmentStatus } from "../../masterclasses/enrollment/masterclass_enrollment_entity";
import { MasterclassPaymentSuccessService } from "../../masterclasses/payment/masterclass_payment_success_service";

/**
 * MasterclassPayment factory
 */
function createMasterclassPayment(
  overrides: Partial<MasterclassPayment> = {},
): MasterclassPayment {
  return {
    id: "masterclass-1_student-1",
    enrollmentId: "masterclass-1_student-1",
    masterclassId: "masterclass-1",

    studentId: "student-1",
    tutorId: "tutor-1",

    amountCents: 15000,
    currency: "ZAR",

    status: MasterclassPaymentStatus.processing,

    provider: "mock",
    providerPaymentId: "mock-masterclass-1_student-1",

    createdAt: new Date("2026-02-01T14:00:00.000Z"),
    updatedAt: new Date("2026-02-01T14:30:00.000Z"),

    paidAt: null,

    failureReason: null,

    ...overrides,
  };
}

interface MasterclassEnrollmentSeed {
  masterclassId: string;
  studentId: string;
  tutorId: string;
  priceCents: number;
  status: string;
}

function createMasterclassEnrollment(
  overrides: Partial<MasterclassEnrollmentSeed> = {},
): MasterclassEnrollmentSeed {
  return {
    masterclassId: "masterclass-1",
    studentId: "student-1",
    tutorId: "tutor-1",
    priceCents: 15000,
    status: MasterclassEnrollmentStatus.pendingPayment,

    ...overrides,
  };
}

function seedMasterclassPayment(
  mockFirestore: ReturnType<typeof createMockFirestore>,
  payment: MasterclassPayment,
): void {
  mockFirestore.seed(
    `masterclassPayments/${payment.id}`,
    payment,
  );
}

function seedMasterclassEnrollment(
  mockFirestore: ReturnType<typeof createMockFirestore>,
  enrollmentId: string,
  enrollment: MasterclassEnrollmentSeed,
): void {
  mockFirestore.seed(
    `masterclassEnrollments/${enrollmentId}`,
    enrollment,
  );
}

describe("MasterclassPaymentSuccessService", () => {
  let firestore: Firestore;
  let mockFirestore: ReturnType<typeof createMockFirestore>;
  let transactionService: TransactionService;
  let service: MasterclassPaymentSuccessService;

  beforeEach(() => {
    mockFirestore = createMockFirestore();
    firestore = mockFirestore as unknown as Firestore;

    const referenceIdentity =
      new TransactionReferenceIdentity(firestore);

    transactionService = new TransactionService(
      firestore,
      referenceIdentity,
    );

    service = new MasterclassPaymentSuccessService(
      firestore,
      transactionService,
    );
  });

  it("atomically marks the payment paid, confirms the enrollment, and creates the ledger transaction", async () => {
    const paidAt = new Date("2026-02-01T15:00:00.000Z");

    const payment = createMasterclassPayment();

    seedMasterclassPayment(mockFirestore, payment);

    seedMasterclassEnrollment(
      mockFirestore,
      payment.enrollmentId,
      createMasterclassEnrollment({
        studentId: payment.studentId,
        tutorId: payment.tutorId,
        priceCents: payment.amountCents,
      }),
    );

    const result = await service.markPaymentPaid({
      enrollmentId: "masterclass-1_student-1",
      providerPaymentId: "mock-masterclass-1_student-1",
      paidAt,
    });

    expect(result.id).toBe("masterclass-1_student-1");
    expect(result.status).toBe(MasterclassPaymentStatus.paid);
    expect(result.paidAt).toEqual(paidAt);

    const storedPayment = mockFirestore.get(
      "masterclassPayments/masterclass-1_student-1",
    );

    expect(storedPayment).toMatchObject({
      status: MasterclassPaymentStatus.paid,
      paidAt: expect.any(Timestamp),
    });

    const storedEnrollment = mockFirestore.get(
      "masterclassEnrollments/masterclass-1_student-1",
    );

    expect(storedEnrollment?.status).toBe(
      MasterclassEnrollmentStatus.confirmed,
    );

    const transaction = mockFirestore.get(
      "transactions/masterclass-payment-masterclass-1_student-1",
    );

    expect(transaction).toBeDefined();

    expect(transaction).toMatchObject({
      bookingId: "masterclass-1_student-1",
      paymentId: "masterclass-1_student-1",

      type: TransactionType.payment,
      direction: TransactionDirection.credit,
      status: TransactionStatus.completed,

      amountCents: 15000,
      currency: "ZAR",

      studentId: "student-1",
      tutorId: "tutor-1",

      referenceId: "masterclass-1_student-1",

      description:
        "Masterclass payment for enrollment masterclass-1_student-1",
    });

    const reference = mockFirestore.get(
      "transactionReferences/payment:masterclass-1_student-1",
    );

    expect(reference).toBeDefined();

    expect(reference).toMatchObject({
      transactionId:
        "masterclass-payment-masterclass-1_student-1",
    });
  });

  it("marks a pending payment as paid", async () => {
    const paidAt = new Date("2026-02-01T15:00:00.000Z");

    const payment = createMasterclassPayment({
      status: MasterclassPaymentStatus.pending,
    });

    seedMasterclassPayment(mockFirestore, payment);

    seedMasterclassEnrollment(
      mockFirestore,
      payment.enrollmentId,
      createMasterclassEnrollment({
        studentId: payment.studentId,
        tutorId: payment.tutorId,
        priceCents: payment.amountCents,
      }),
    );

    const result = await service.markPaymentPaid({
      enrollmentId: "masterclass-1_student-1",
      providerPaymentId: "mock-masterclass-1_student-1",
      paidAt,
    });

    expect(result.status).toBe(MasterclassPaymentStatus.paid);
  });

  it("marks a stuck payment as paid, closing the self-healing loop", async () => {
    const paidAt = new Date("2026-02-01T15:00:00.000Z");

    const payment = createMasterclassPayment({
      status: MasterclassPaymentStatus.stuck,
    });

    seedMasterclassPayment(mockFirestore, payment);

    seedMasterclassEnrollment(
      mockFirestore,
      payment.enrollmentId,
      createMasterclassEnrollment({
        studentId: payment.studentId,
        tutorId: payment.tutorId,
        priceCents: payment.amountCents,
      }),
    );

    const result = await service.markPaymentPaid({
      enrollmentId: "masterclass-1_student-1",
      providerPaymentId: "mock-masterclass-1_student-1",
      paidAt,
    });

    expect(result.status).toBe(MasterclassPaymentStatus.paid);

    expect(
      mockFirestore.get(
        "transactions/masterclass-payment-masterclass-1_student-1",
      ),
    ).toBeDefined();
  });

  it("rejects a payment with a mismatched provider payment ID", async () => {
    const payment = createMasterclassPayment();

    seedMasterclassPayment(mockFirestore, payment);

    /*
     * Deliberately NOT seeding the enrollment: this
     * rejection must happen before the enrollment read,
     * so a missing enrollment doc must not be why this
     * test fails.
     */

    await expect(
      service.markPaymentPaid({
        enrollmentId: "masterclass-1_student-1",
        providerPaymentId: "different-provider-payment",
        paidAt: new Date("2026-02-01T15:00:00.000Z"),
      }),
    ).rejects.toThrow(
      "Provider payment ID does not match the masterclass payment.",
    );

    const stored = mockFirestore.get(
      "masterclassPayments/masterclass-1_student-1",
    );

    expect(stored?.status).toBe(
      MasterclassPaymentStatus.processing,
    );

    expect(
      mockFirestore.get(
        "transactions/masterclass-payment-masterclass-1_student-1",
      ),
    ).toBeUndefined();
  });

  it("rejects a failed payment without requiring an enrollment to exist", async () => {
    const payment = createMasterclassPayment({
      status: MasterclassPaymentStatus.failed,
    });

    seedMasterclassPayment(mockFirestore, payment);

    await expect(
      service.markPaymentPaid({
        enrollmentId: "masterclass-1_student-1",
        providerPaymentId: "mock-masterclass-1_student-1",
        paidAt: new Date("2026-02-01T15:00:00.000Z"),
      }),
    ).rejects.toThrow(
      "Masterclass payment cannot be marked as paid from its current status.",
    );

    expect(
      mockFirestore.get(
        "masterclassPayments/masterclass-1_student-1",
      )?.status,
    ).toBe(MasterclassPaymentStatus.failed);
  });

  it("rejects a cancelled payment", async () => {
    const payment = createMasterclassPayment({
      status: MasterclassPaymentStatus.cancelled,
    });

    seedMasterclassPayment(mockFirestore, payment);

    await expect(
      service.markPaymentPaid({
        enrollmentId: "masterclass-1_student-1",
        providerPaymentId: "mock-masterclass-1_student-1",
        paidAt: new Date("2026-02-01T15:00:00.000Z"),
      }),
    ).rejects.toThrow(
      "Masterclass payment cannot be marked as paid from its current status.",
    );
  });

  it("rejects a refunded payment", async () => {
    const payment = createMasterclassPayment({
      status: MasterclassPaymentStatus.refunded,
    });

    seedMasterclassPayment(mockFirestore, payment);

    await expect(
      service.markPaymentPaid({
        enrollmentId: "masterclass-1_student-1",
        providerPaymentId: "mock-masterclass-1_student-1",
        paidAt: new Date("2026-02-01T15:00:00.000Z"),
      }),
    ).rejects.toThrow(
      "Masterclass payment cannot be marked as paid from its current status.",
    );
  });

  it("rejects when the enrollment does not exist", async () => {
    const payment = createMasterclassPayment();

    seedMasterclassPayment(mockFirestore, payment);

    /*
     * No enrollment seeded — payment validation passes
     * (status is processing, provider ID matches), so
     * this must fail specifically on the enrollment read.
     */

    await expect(
      service.markPaymentPaid({
        enrollmentId: "masterclass-1_student-1",
        providerPaymentId: "mock-masterclass-1_student-1",
        paidAt: new Date("2026-02-01T15:00:00.000Z"),
      }),
    ).rejects.toThrow("Enrollment does not exist.");
  });

  it("rejects when the enrollment is not pending payment", async () => {
    const payment = createMasterclassPayment();

    seedMasterclassPayment(mockFirestore, payment);

    seedMasterclassEnrollment(
      mockFirestore,
      payment.enrollmentId,
      createMasterclassEnrollment({
        studentId: payment.studentId,
        tutorId: payment.tutorId,
        priceCents: payment.amountCents,
        status: MasterclassEnrollmentStatus.confirmed,
      }),
    );

    await expect(
      service.markPaymentPaid({
        enrollmentId: "masterclass-1_student-1",
        providerPaymentId: "mock-masterclass-1_student-1",
        paidAt: new Date("2026-02-01T15:00:00.000Z"),
      }),
    ).rejects.toThrow(
      "Enrollment cannot be confirmed from its current status.",
    );
  });

  it("rejects when enrollment student does not match the payment", async () => {
    const payment = createMasterclassPayment();

    seedMasterclassPayment(mockFirestore, payment);

    seedMasterclassEnrollment(
      mockFirestore,
      payment.enrollmentId,
      createMasterclassEnrollment({
        studentId: "different-student",
        tutorId: payment.tutorId,
        priceCents: payment.amountCents,
      }),
    );

    await expect(
      service.markPaymentPaid({
        enrollmentId: "masterclass-1_student-1",
        providerPaymentId: "mock-masterclass-1_student-1",
        paidAt: new Date("2026-02-01T15:00:00.000Z"),
      }),
    ).rejects.toThrow(
      "Enrollment student does not match the payment.",
    );
  });

  it("rejects when enrollment tutor does not match the payment", async () => {
    const payment = createMasterclassPayment();

    seedMasterclassPayment(mockFirestore, payment);

    seedMasterclassEnrollment(
      mockFirestore,
      payment.enrollmentId,
      createMasterclassEnrollment({
        studentId: payment.studentId,
        tutorId: "different-tutor",
        priceCents: payment.amountCents,
      }),
    );

    await expect(
      service.markPaymentPaid({
        enrollmentId: "masterclass-1_student-1",
        providerPaymentId: "mock-masterclass-1_student-1",
        paidAt: new Date("2026-02-01T15:00:00.000Z"),
      }),
    ).rejects.toThrow(
      "Enrollment tutor does not match the payment.",
    );
  });

  it("rejects when enrollment price does not match the payment amount", async () => {
    const payment = createMasterclassPayment({
      amountCents: 15000,
    });

    seedMasterclassPayment(mockFirestore, payment);

    seedMasterclassEnrollment(
      mockFirestore,
      payment.enrollmentId,
      createMasterclassEnrollment({
        studentId: payment.studentId,
        tutorId: payment.tutorId,
        priceCents: 20000,
      }),
    );

    await expect(
      service.markPaymentPaid({
        enrollmentId: "masterclass-1_student-1",
        providerPaymentId: "mock-masterclass-1_student-1",
        paidAt: new Date("2026-02-01T15:00:00.000Z"),
      }),
    ).rejects.toThrow(
      "Enrollment price does not match the payment amount.",
    );
  });

  it("rejects a missing payment", async () => {
    await expect(
      service.markPaymentPaid({
        enrollmentId: "masterclass-1_student-1",
        providerPaymentId: "mock-masterclass-1_student-1",
        paidAt: new Date("2026-02-01T15:00:00.000Z"),
      }),
    ).rejects.toThrow(
      "Masterclass payment does not exist.",
    );
  });

  it("is idempotent when the payment is already paid", async () => {
    const paidAt = new Date("2026-02-01T15:00:00.000Z");

    const payment = createMasterclassPayment({
      status: MasterclassPaymentStatus.paid,
      paidAt,
    });

    seedMasterclassPayment(mockFirestore, payment);

    /*
     * No enrollment seeded — the idempotent-paid path
     * returns before the enrollment is ever read.
     */

    const result = await service.markPaymentPaid({
      enrollmentId: "masterclass-1_student-1",
      providerPaymentId: "mock-masterclass-1_student-1",
      paidAt,
    });

    expect(result.status).toBe(MasterclassPaymentStatus.paid);
    expect(result.paidAt).toEqual(paidAt);

    expect(
      mockFirestore.get(
        "transactions/masterclass-payment-masterclass-1_student-1",
      ),
    ).toBeUndefined();
  });

  it("does not create a duplicate ledger transaction when processed repeatedly", async () => {
    const paidAt = new Date("2026-02-01T15:00:00.000Z");

    const payment = createMasterclassPayment();

    seedMasterclassPayment(mockFirestore, payment);

    seedMasterclassEnrollment(
      mockFirestore,
      payment.enrollmentId,
      createMasterclassEnrollment({
        studentId: payment.studentId,
        tutorId: payment.tutorId,
        priceCents: payment.amountCents,
      }),
    );

    await service.markPaymentPaid({
      enrollmentId: "masterclass-1_student-1",
      providerPaymentId: "mock-masterclass-1_student-1",
      paidAt,
    });

    const firstTransaction = mockFirestore.get(
      "transactions/masterclass-payment-masterclass-1_student-1",
    );

    expect(firstTransaction).toBeDefined();

    await service.markPaymentPaid({
      enrollmentId: "masterclass-1_student-1",
      providerPaymentId: "mock-masterclass-1_student-1",
      paidAt,
    });

    const secondTransaction = mockFirestore.get(
      "transactions/masterclass-payment-masterclass-1_student-1",
    );

    expect(secondTransaction).toEqual(firstTransaction);
  });

  it("clears a previous failure reason when payment becomes paid", async () => {
    const payment = createMasterclassPayment({
      failureReason: "Temporary provider failure.",
    });

    seedMasterclassPayment(mockFirestore, payment);

    seedMasterclassEnrollment(
      mockFirestore,
      payment.enrollmentId,
      createMasterclassEnrollment({
        studentId: payment.studentId,
        tutorId: payment.tutorId,
        priceCents: payment.amountCents,
      }),
    );

    await service.markPaymentPaid({
      enrollmentId: "masterclass-1_student-1",
      providerPaymentId: "mock-masterclass-1_student-1",
      paidAt: new Date("2026-02-01T15:00:00.000Z"),
    });

    const stored = mockFirestore.get(
      "masterclassPayments/masterclass-1_student-1",
    );

    expect(stored?.failureReason).toBeNull();
  });
});
