import { Timestamp } from "firebase-admin/firestore";
import { PaymentService } from "./payment_service";
import { PaymentStatus } from "./payment_entity";
import { BookingStatus } from "../bookings/booking_status";
import { createMockFirestore } from "./mock_firestore";
import {describe,expect,it,beforeEach,afterEach,} from "vitest";

describe("PaymentService", () => {
  let firestore: ReturnType<
    typeof createMockFirestore
  >;

  let service: PaymentService;

  beforeEach(() => {
    firestore = createMockFirestore();

    service = new PaymentService(
      firestore as any,
    );
  });

  afterEach(() => {
    firestore.clear();
  });

  // ==================================================
  // createPayment
  // ==================================================

  describe("createPayment", () => {
    it("creates a pending payment from the booking price", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status: BookingStatus.paymentRequired,
      });

      const result =
        await service.createPayment({
          bookingId: "booking-1",
          studentId: "student-1",
        });

      expect(result.id).toBe("booking-1");
      expect(result.bookingId).toBe("booking-1");
      expect(result.studentId).toBe("student-1");
      expect(result.tutorId).toBe("tutor-1");

      expect(result.amountCents).toBe(45000);
      expect(result.currency).toBe("ZAR");

      expect(result.status).toBe(
        PaymentStatus.pending,
      );

      const payment =
        firestore.get("payments/booking-1");

      expect(payment).toEqual(
        expect.objectContaining({
          bookingId: "booking-1",
          studentId: "student-1",
          tutorId: "tutor-1",
          amountCents: 45000,
          currency: "ZAR",
          status: PaymentStatus.pending,
          provider: null,
          providerPaymentId: null,
          paidAt: null,
          failureReason: null,
        }),
      );
    });

    it("rejects when the booking does not exist", async () => {
      await expect(
        service.createPayment({
          bookingId: "booking-1",
          studentId: "student-1",
        }),
      ).rejects.toThrow(
        "Booking not found.",
      );
    });

    it("rejects when the student does not own the booking", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-2",
        tutorId: "tutor-1",
        priceCents: 45000,
        status: BookingStatus.paymentRequired,
      });

      await expect(
        service.createPayment({
          bookingId: "booking-1",
          studentId: "student-1",
        }),
      ).rejects.toThrow(
        "Student does not own this booking.",
      );
    });

    it("rejects when the booking is not awaiting payment", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status: BookingStatus.confirmed,
      });

      await expect(
        service.createPayment({
          bookingId: "booking-1",
          studentId: "student-1",
        }),
      ).rejects.toThrow(
        "Booking is not awaiting payment.",
      );
    });

    it("rejects when the booking price is invalid", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 0,
        status: BookingStatus.paymentRequired,
      });

      await expect(
        service.createPayment({
          bookingId: "booking-1",
          studentId: "student-1",
        }),
      ).rejects.toThrow(
        "Booking has an invalid price.",
      );
    });

    it("rejects when the booking price is negative", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: -100,
        status: BookingStatus.paymentRequired,
      });

      await expect(
        service.createPayment({
          bookingId: "booking-1",
          studentId: "student-1",
        }),
      ).rejects.toThrow(
        "Booking has an invalid price.",
      );
    });

    it("returns the existing payment instead of creating another one", async () => {
      const createdAt = Timestamp.now();
      const updatedAt = Timestamp.now();

      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status: BookingStatus.paymentRequired,
      });

      firestore.seed("payments/booking-1", {
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",
        amountCents: 45000,
        currency: "ZAR",
        status: PaymentStatus.pending,
        provider: null,
        providerPaymentId: null,
        createdAt,
        updatedAt,
        paidAt: null,
        failureReason: null,
      });

      const result =
        await service.createPayment({
          bookingId: "booking-1",
          studentId: "student-1",
        });

      expect(result.id).toBe("booking-1");
      expect(result.status).toBe(
        PaymentStatus.pending,
      );

      expect(
        firestore.transactionCreate,
      ).not.toHaveBeenCalled();
    });
  });

  // ==================================================
  // markProcessing
  // ==================================================

  describe("markProcessing", () => {
    it("moves a pending payment to processing", async () => {
      firestore.seed("payments/booking-1", {
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",
        amountCents: 45000,
        currency: "ZAR",
        status: PaymentStatus.pending,
        provider: null,
        providerPaymentId: null,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        paidAt: null,
        failureReason: null,
      });

      await service.markProcessing(
        "booking-1",
      );

      const payment =
        firestore.get("payments/booking-1");

      expect(payment?.status).toBe(
        PaymentStatus.processing,
      );
    });

    it("rejects when the payment does not exist", async () => {
      await expect(
        service.markProcessing(
          "booking-1",
        ),
      ).rejects.toThrow(
        "Payment not found.",
      );
    });

    it("does nothing when the payment is already processing", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.processing,
      });

      await service.markProcessing(
        "booking-1",
      );

      const payment =
        firestore.get("payments/booking-1");

      expect(payment?.status).toBe(
        PaymentStatus.processing,
      );

      expect(
        firestore.transactionUpdate,
      ).not.toHaveBeenCalled();
    });

    it("rejects when the payment is already paid", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.paid,
      });

      await expect(
        service.markProcessing(
          "booking-1",
        ),
      ).rejects.toThrow(
        "Payment cannot become processing from paid",
      );
    });
  });

  // ==================================================
  // markPaid
  // ==================================================

  describe("markPaid", () => {
    const seedValidPaymentAndBooking = () => {
      firestore.seed("payments/booking-1", {
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",
        amountCents: 45000,
        currency: "ZAR",
        status: PaymentStatus.processing,
        provider: null,
        providerPaymentId: null,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        paidAt: null,
        failureReason: null,
      });

      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status: BookingStatus.paymentRequired,
      });
    };

    it("marks the payment as paid and booking as confirmed", async () => {
      seedValidPaymentAndBooking();

      await service.markPaid(
        "booking-1",
        "test-provider",
        "provider-123",
      );

      const payment =
        firestore.get("payments/booking-1");

      const booking =
        firestore.get("bookings/booking-1");

      expect(payment?.status).toBe(
        PaymentStatus.paid,
      );

      expect(payment?.provider).toBe(
        "test-provider",
      );

      expect(
        payment?.providerPaymentId,
      ).toBe("provider-123");

      expect(payment?.paidAt).toEqual(
        expect.anything(),
      );

      expect(booking?.status).toBe(
        BookingStatus.confirmed,
      );
    });

    it("rejects when the payment does not exist", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status: BookingStatus.paymentRequired,
      });

      await expect(
        service.markPaid(
          "booking-1",
          "test-provider",
          "provider-123",
        ),
      ).rejects.toThrow(
        "Payment not found.",
      );
    });

    it("does nothing when the payment is already paid", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.paid,
      });

      await service.markPaid(
        "booking-1",
        "test-provider",
        "provider-123",
      );

      expect(
        firestore.transactionUpdate,
      ).not.toHaveBeenCalled();
    });

    it("rejects when the payment is not processing", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.pending,
      });

      await expect(
        service.markPaid(
          "booking-1",
          "test-provider",
          "provider-123",
        ),
      ).rejects.toThrow(
        "Payment cannot become paid from pending.",
        //"Payment must be processing before it can be marked as paid.",
      );
    });

    it("rejects when the booking does not exist", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.processing,
        studentId: "student-1",
        tutorId: "tutor-1",
        amountCents: 45000,
      });

      await expect(
        service.markPaid(
          "booking-1",
          "test-provider",
          "provider-123",
        ),
      ).rejects.toThrow(
        "Booking not found.",
      );
    });

    it("rejects when the booking is not awaiting payment", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.processing,
        studentId: "student-1",
        tutorId: "tutor-1",
        amountCents: 45000,
      });

      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status: BookingStatus.confirmed,
      });

      await expect(
        service.markPaid(
          "booking-1",
          "test-provider",
          "provider-123",
        ),
      ).rejects.toThrow(
        "Booking is not awaiting payment.",
      );
    });

    it("rejects when the payment student does not match the booking", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.processing,
        studentId: "student-2",
        tutorId: "tutor-1",
        amountCents: 45000,
      });

      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status: BookingStatus.paymentRequired,
      });

      await expect(
        service.markPaid(
          "booking-1",
          "test-provider",
          "provider-123",
        ),
      ).rejects.toThrow(
        "Payment does not belong to the booking.",
        //"Payment student does not match booking.",
      );
    });

    it("rejects when the payment tutor does not match the booking", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.processing,
        studentId: "student-1",
        tutorId: "tutor-2",
        amountCents: 45000,
      });

      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status: BookingStatus.paymentRequired,
      });

      await expect(
        service.markPaid(
          "booking-1",
          "test-provider",
          "provider-123",
        ),
      ).rejects.toThrow(
        //"Payment tutor does not match booking.",
        "Payment does not belong to the booking.",
      );
    });

    it("rejects when the payment amount does not match the booking price", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.processing,
        studentId: "student-1",
        tutorId: "tutor-1",
        amountCents: 50000,
      });

      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status: BookingStatus.paymentRequired,
      });

      await expect(
        service.markPaid(
          "booking-1",
          "test-provider",
          "provider-123",
        ),
      ).rejects.toThrow(
        "Payment amount does not match booking price.",
      );
    });
  });

  // ==================================================
  // markFailed
  // ==================================================

  describe("markFailed", () => {
    it("marks a pending payment as failed", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.pending,
        failureReason: null,
      });

      await service.markFailed(
        "booking-1",
        "Card declined.",
      );

      const payment =
        firestore.get("payments/booking-1");

      expect(payment?.status).toBe(
        PaymentStatus.failed,
      );

      expect(payment?.failureReason).toBe(
        "Card declined.",
      );
    });

    it("marks a processing payment as failed", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.processing,
        failureReason: null,
      });

      await service.markFailed(
        "booking-1",
        "Payment rejected.",
      );

      const payment =
        firestore.get("payments/booking-1");

      expect(payment?.status).toBe(
        PaymentStatus.failed,
      );

      expect(payment?.failureReason).toBe(
        "Payment rejected.",
      );
    });

    it("rejects when the payment does not exist", async () => {
      await expect(
        service.markFailed(
          "booking-1",
          "Card declined.",
        ),
      ).rejects.toThrow(
        "Payment not found.",
      );
    });

    it("does nothing when the payment is already failed", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.failed,
        failureReason: "Card declined.",
      });

      await service.markFailed(
        "booking-1",
        "Another reason.",
      );

      const payment =
        firestore.get("payments/booking-1");

      expect(payment?.status).toBe(
        PaymentStatus.failed,
      );

      expect(payment?.failureReason).toBe(
        "Card declined.",
      );

      expect(
        firestore.transactionUpdate,
      ).not.toHaveBeenCalled();
    });

    it("rejects when the payment is already paid", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.paid,
      });

      await expect(
        service.markFailed(
          "booking-1",
          "Card declined.",
        ),
      ).rejects.toThrow(
        //"Payment cannot be marked as failed.",
        "Payment cannot be marked failed from paid.",
      );
    });
  });
});
