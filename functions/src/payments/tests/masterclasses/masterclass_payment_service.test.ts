import { Timestamp } from "firebase-admin/firestore";
import { beforeEach, afterEach, describe, expect, it, vi } from "vitest";
import { MasterclassPaymentService } from "../../masterclasses/payment/masterclass_payment_service";
import { MasterclassPaymentStatus } from "../../masterclasses/payment/masterclass_payment_entity";
import { MasterclassEnrollmentStatus } from "../../masterclasses/enrollment/masterclass_enrollment_entity";
import { PaymentProvider } from "../../provider/payment_provider";
import { createMockFirestore } from "../../tests/mock_firestore";

describe("MasterclassPaymentService", () => {
  let firestore: ReturnType<typeof createMockFirestore>;
  let paymentProvider: PaymentProvider;
  let service: MasterclassPaymentService;

  const enrollmentId = "masterclass-1_student-1";

  beforeEach(() => {
    firestore = createMockFirestore();
    paymentProvider = {
      name: "mock",
      createPayment: vi.fn(
        async ({
          bookingId,
        }: {
          amountCents: number;
          currency: "ZAR";
          bookingId: string;
          studentId: string;
        }) => {
          return {
            providerPaymentId: `mock-${bookingId}`,
            checkoutUrl: `https://mock-payment.test/checkout/${bookingId}`,
          };
        },
      ),
      refundPayment: vi.fn(),
      verifyWebhook: vi.fn(),
    };

    service = new MasterclassPaymentService(
      firestore as any,
      paymentProvider,
    );
  });

  afterEach(() => {
    firestore.clear();
    vi.clearAllMocks();
  });

  function seedPendingEnrollment(
    overrides: Record<string, unknown> = {},
  ) {
    firestore.seed(
      `masterclassEnrollments/${enrollmentId}`,
      {
        masterclassId: "masterclass-1",
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 15000,
        currency: "ZAR",
        status: MasterclassEnrollmentStatus.pendingPayment,
        downloadedAt: null,
        enrolledAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        cancelledAt: null,
        refundedAt: null,
        ...overrides,
      },
    );
  }

  // ==================================================
  // createPayment
  // ==================================================

  describe("createPayment", () => {
    it("creates a pending payment and provider checkout", async () => {
      seedPendingEnrollment();

      const result = await service.createPayment({
        enrollmentId,
        studentId: "student-1",
      });

      expect(result.payment.id).toBe(enrollmentId);
      expect(result.payment.enrollmentId).toBe(
        enrollmentId,
      );
      expect(result.payment.masterclassId).toBe(
        "masterclass-1",
      );
      expect(result.payment.studentId).toBe("student-1");
      expect(result.payment.tutorId).toBe("tutor-1");
      expect(result.payment.amountCents).toBe(15000);
      expect(result.payment.currency).toBe("ZAR");
      expect(result.payment.status).toBe(
        MasterclassPaymentStatus.pending,
      );

      expect(result.provider).toBe("mock");
      expect(result.providerPaymentId).toBe(
        `mock-${enrollmentId}`,
      );
      expect(result.checkoutUrl).toBe(
        `https://mock-payment.test/checkout/${enrollmentId}`,
      );

      const stored = firestore.get(
        `masterclassPayments/${enrollmentId}`,
      );

      expect(stored).toEqual(
        expect.objectContaining({
          enrollmentId,
          masterclassId: "masterclass-1",
          studentId: "student-1",
          tutorId: "tutor-1",
          amountCents: 15000,
          currency: "ZAR",
          status: MasterclassPaymentStatus.pending,
          provider: "mock",
          providerPaymentId: `mock-${enrollmentId}`,
          paidAt: null,
          failureReason: null,
        }),
      );
    });

    it("sends the enrollment price to the provider", async () => {
      seedPendingEnrollment();

      await service.createPayment({
        enrollmentId,
        studentId: "student-1",
      });

      expect(
        paymentProvider.createPayment,
      ).toHaveBeenCalledWith({
        amountCents: 15000,
        currency: "ZAR",
        bookingId: enrollmentId,
        studentId: "student-1",
      });
    });

    it("returns the existing payment instead of creating another payment", async () => {
      seedPendingEnrollment();

      firestore.seed(
        `masterclassPayments/${enrollmentId}`,
        {
          enrollmentId,
          masterclassId: "masterclass-1",
          studentId: "student-1",
          tutorId: "tutor-1",
          amountCents: 15000,
          currency: "ZAR",
          status: MasterclassPaymentStatus.pending,
          provider: "mock",
          providerPaymentId: `mock-${enrollmentId}`,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
          paidAt: null,
          failureReason: null,
        },
      );

      const result = await service.createPayment({
        enrollmentId,
        studentId: "student-1",
      });

      expect(result.payment.id).toBe(enrollmentId);
      expect(result.payment.status).toBe(
        MasterclassPaymentStatus.pending,
      );

      /*
       * The provider is still called because checkout
       * information is required for the current
       * initiation operation.
       */
      expect(
        paymentProvider.createPayment,
      ).toHaveBeenCalledTimes(1);
    });

    it("rejects when the enrollment does not exist", async () => {
      await expect(
        service.createPayment({
          enrollmentId,
          studentId: "student-1",
        }),
      ).rejects.toThrow("Enrollment not found.");

      expect(
        paymentProvider.createPayment,
      ).not.toHaveBeenCalled();
    });

    it("rejects when the student does not own the enrollment", async () => {
      seedPendingEnrollment({
        studentId: "student-2",
      });

      await expect(
        service.createPayment({
          enrollmentId,
          studentId: "student-1",
        }),
      ).rejects.toThrow(
        "Student does not own this enrollment.",
      );

      expect(
        paymentProvider.createPayment,
      ).not.toHaveBeenCalled();
    });

    it("rejects when the enrollment is not awaiting payment", async () => {
      seedPendingEnrollment({
        status: MasterclassEnrollmentStatus.confirmed,
      });

      await expect(
        service.createPayment({
          enrollmentId,
          studentId: "student-1",
        }),
      ).rejects.toThrow(
        "Enrollment is not awaiting payment.",
      );

      expect(
        paymentProvider.createPayment,
      ).not.toHaveBeenCalled();
    });

    it("rejects when the enrollment price is invalid", async () => {
      seedPendingEnrollment({
        priceCents: 0,
      });

      await expect(
        service.createPayment({
          enrollmentId,
          studentId: "student-1",
        }),
      ).rejects.toThrow(
        "Enrollment has an invalid price.",
      );

      expect(
        paymentProvider.createPayment,
      ).not.toHaveBeenCalled();
    });

    it("propagates provider failure", async () => {
      seedPendingEnrollment();

      vi.mocked(
        paymentProvider.createPayment,
      ).mockRejectedValueOnce(
        new Error("Provider unavailable."),
      );

      await expect(
        service.createPayment({
          enrollmentId,
          studentId: "student-1",
        }),
      ).rejects.toThrow("Provider unavailable.");
    });
  });

  // ==================================================
  // markProcessing
  // ==================================================

  describe("markProcessing", () => {
    it("moves a pending payment to processing", async () => {
      firestore.seed(
        `masterclassPayments/${enrollmentId}`,
        {
          status: MasterclassPaymentStatus.pending,
        },
      );

      await service.markProcessing(enrollmentId);

      expect(
        firestore.get(
          `masterclassPayments/${enrollmentId}`,
        )?.status,
      ).toBe(MasterclassPaymentStatus.processing);
    });

    it("rejects when the payment does not exist", async () => {
      await expect(
        service.markProcessing(enrollmentId),
      ).rejects.toThrow(
        "Masterclass payment not found.",
      );
    });

    it("does nothing when already processing", async () => {
      firestore.seed(
        `masterclassPayments/${enrollmentId}`,
        {
          status: MasterclassPaymentStatus.processing,
        },
      );

      await service.markProcessing(enrollmentId);

      expect(
        firestore.transactionUpdate,
      ).not.toHaveBeenCalled();
    });

    it("rejects when the payment is already paid", async () => {
      firestore.seed(
        `masterclassPayments/${enrollmentId}`,
        {
          status: MasterclassPaymentStatus.paid,
        },
      );

      await expect(
        service.markProcessing(enrollmentId),
      ).rejects.toThrow(
        "Masterclass payment cannot become processing from paid.",
      );
    });
  });

  // ==================================================
  // markFailed
  // ==================================================

  describe("markFailed", () => {
    it("marks pending payment as failed", async () => {
      firestore.seed(
        `masterclassPayments/${enrollmentId}`,
        {
          status: MasterclassPaymentStatus.pending,
          failureReason: null,
        },
      );

      await service.markFailed({
        enrollmentId,
        failureReason: "Card declined.",
      });

      const stored = firestore.get(
        `masterclassPayments/${enrollmentId}`,
      );

      expect(stored?.status).toBe(
        MasterclassPaymentStatus.failed,
      );

      expect(stored?.failureReason).toBe(
        "Card declined.",
      );
    });

    it("marks processing payment as failed", async () => {
      firestore.seed(
        `masterclassPayments/${enrollmentId}`,
        {
          status: MasterclassPaymentStatus.processing,
          failureReason: null,
        },
      );

      await service.markFailed({
        enrollmentId,
        failureReason: "Payment rejected.",
      });

      expect(
        firestore.get(
          `masterclassPayments/${enrollmentId}`,
        )?.status,
      ).toBe(MasterclassPaymentStatus.failed);
    });

    it("marks a stuck payment as failed", async () => {
      firestore.seed(
        `masterclassPayments/${enrollmentId}`,
        {
          status: MasterclassPaymentStatus.stuck,
          failureReason: null,
        },
      );

      await service.markFailed({
        enrollmentId,
        failureReason:
          "Provider confirmed the charge never completed.",
      });

      expect(
        firestore.get(
          `masterclassPayments/${enrollmentId}`,
        )?.status,
      ).toBe(MasterclassPaymentStatus.failed);
    });

    it("rejects when payment does not exist", async () => {
      await expect(
        service.markFailed({
          enrollmentId,
          failureReason: "Payment rejected.",
        }),
      ).rejects.toThrow(
        "Masterclass payment not found.",
      );
    });

    it("does nothing when payment is already failed", async () => {
      firestore.seed(
        `masterclassPayments/${enrollmentId}`,
        {
          status: MasterclassPaymentStatus.failed,
          failureReason: "Card declined.",
        },
      );

      await service.markFailed({
        enrollmentId,
        failureReason: "Payment rejected.",
      });

      const stored = firestore.get(
        `masterclassPayments/${enrollmentId}`,
      );

      expect(stored?.failureReason).toBe(
        "Card declined.",
      );

      expect(
        firestore.transactionUpdate,
      ).not.toHaveBeenCalled();
    });

    it("rejects when payment is already paid", async () => {
      firestore.seed(
        `masterclassPayments/${enrollmentId}`,
        {
          status: MasterclassPaymentStatus.paid,
        },
      );

      await expect(
        service.markFailed({
          enrollmentId,
          failureReason: "Payment rejected.",
        }),
      ).rejects.toThrow(
        "Masterclass payment cannot be marked failed from paid.",
      );
    });
  });

  // ==================================================
  // findStuckPaymentCandidates / markStuck / resolvePaymentAsFailed
  // (emulator required)
  // ==================================================
});
