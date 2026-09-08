import { Timestamp } from "firebase-admin/firestore";
import {beforeEach, afterEach, describe, expect, it,vi} from "vitest";
import { PaymentService } from "./payment_service";
import { PaymentStatus } from "./payment_entity";
import { PaymentProvider } from "./payment_provider";
import { BookingStatus } from "../bookings/booking_status";
import { createMockFirestore } from "./mock_firestore";

describe("PaymentService", () => {
  let firestore: ReturnType<typeof createMockFirestore>;
  let paymentProvider: PaymentProvider;
  let service: PaymentService;

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
    };

    service = new PaymentService(
      firestore as any,
      paymentProvider,
    );
  });

  afterEach(() => {
    firestore.clear();
    vi.clearAllMocks();
  });

  // ==================================================
  // createPayment
  // ==================================================

  describe("createPayment", () => {
    it("creates a pending payment and provider checkout", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status:
          BookingStatus.paymentRequired,
      });

      const result = await service.createPayment({
          bookingId: "booking-1",
          studentId: "student-1",
      });

      expect(result.payment.id).toBe(
        "booking-1",
      );

      expect(result.payment.bookingId).toBe(
        "booking-1",
      );

      expect(result.payment.studentId).toBe(
        "student-1",
      );

      expect(result.payment.tutorId).toBe(
        "tutor-1",
      );

      expect(
        result.payment.amountCents,
      ).toBe(45000);

      expect(result.payment.currency).toBe(
        "ZAR",
      );

      expect(result.payment.status).toBe(
        PaymentStatus.pending,
      );

      expect(result.provider).toBe("mock");

      expect(
        result.providerPaymentId,
      ).toBe("mock-booking-1");

      expect(result.checkoutUrl).toBe(
        "https://mock-payment.test/checkout/booking-1",
      );

      const payment = firestore.get("payments/booking-1");

      expect(payment).toEqual(
        expect.objectContaining({
          bookingId: "booking-1",
          studentId: "student-1",
          tutorId: "tutor-1",
          amountCents: 45000,
          currency: "ZAR",
          status: PaymentStatus.pending,
          provider: "mock",
          providerPaymentId:
            "mock-booking-1",
          paidAt: null,
          failureReason: null,
        }),
      );
    });

    it("sends the booking price to the provider", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status:
          BookingStatus.paymentRequired,
      });

      await service.createPayment({
        bookingId: "booking-1",
        studentId: "student-1",
      });

      expect(
        paymentProvider.createPayment,
      ).toHaveBeenCalledTimes(1);

      expect(
        paymentProvider.createPayment,
      ).toHaveBeenCalledWith({
        amountCents: 45000,
        currency: "ZAR",
        bookingId: "booking-1",
        studentId: "student-1",
      });
    });

    it("uses the booking price instead of a client supplied amount", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status:
          BookingStatus.paymentRequired,
      });

      await service.createPayment({
        bookingId: "booking-1",
        studentId: "student-1",
      });

      const providerCall =
        vi.mocked(
          paymentProvider.createPayment,
        ).mock.calls[0];

      expect(providerCall[0].amountCents).toBe(
        45000,
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

      expect(
        paymentProvider.createPayment,
      ).not.toHaveBeenCalled();
    });

    it("rejects when the student does not own the booking", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-2",
        tutorId: "tutor-1",
        priceCents: 45000,
        status:
          BookingStatus.paymentRequired,
      });

      await expect(
        service.createPayment({
          bookingId: "booking-1",
          studentId: "student-1",
        }),
      ).rejects.toThrow(
        "Student does not own this booking.",
      );

      expect(
        paymentProvider.createPayment,
      ).not.toHaveBeenCalled();
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

      expect(
        paymentProvider.createPayment,
      ).not.toHaveBeenCalled();
    });

    it("rejects when the booking price is zero", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 0,
        status:
          BookingStatus.paymentRequired,
      });

      await expect(
        service.createPayment({
          bookingId: "booking-1",
          studentId: "student-1",
        }),
      ).rejects.toThrow(
        "Booking has an invalid price.",
      );

      expect(
        paymentProvider.createPayment,
      ).not.toHaveBeenCalled();
    });

    it("rejects when the booking price is negative", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: -100,
        status:
          BookingStatus.paymentRequired,
      });

      await expect(
        service.createPayment({
          bookingId: "booking-1",
          studentId: "student-1",
        }),
      ).rejects.toThrow(
        "Booking has an invalid price.",
      );

      expect(
        paymentProvider.createPayment,
      ).not.toHaveBeenCalled();
    });

    it("returns the existing payment instead of creating another payment", async () => {
      const createdAt = Timestamp.now();
      const updatedAt = Timestamp.now();

      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status:
          BookingStatus.paymentRequired,
      });

      firestore.seed("payments/booking-1", {
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",
        amountCents: 45000,
        currency: "ZAR",
        status: PaymentStatus.pending,
        provider: "mock",
        providerPaymentId:
          "mock-booking-1",
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

      expect(result.payment.id).toBe(
        "booking-1",
      );

      expect(result.payment.status).toBe(
        PaymentStatus.pending,
      );

      /*
       * The provider is still called because
       * checkout information is required for
       * the current initiation operation.
       */
      expect(
        paymentProvider.createPayment,
      ).toHaveBeenCalledTimes(1);
    });

    it("stores the provider payment ID", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status:
          BookingStatus.paymentRequired,
      });

      await service.createPayment({
        bookingId: "booking-1",
        studentId: "student-1",
      });

      const payment =
        firestore.get("payments/booking-1");

      expect(
        payment?.providerPaymentId,
      ).toBe("mock-booking-1");

      expect(payment?.provider).toBe(
        "mock",
      );
    });

    it("returns the provider checkout URL", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status:
          BookingStatus.paymentRequired,
      });

      const result =
        await service.createPayment({
          bookingId: "booking-1",
          studentId: "student-1",
        });

      expect(result.checkoutUrl).toBe(
        "https://mock-payment.test/checkout/booking-1",
      );
    });

    it("propagates provider failure", async () => {
      firestore.seed("bookings/booking-1", {
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status:
          BookingStatus.paymentRequired,
      });

      vi.mocked(
        paymentProvider.createPayment,
      ).mockRejectedValueOnce(
        new Error("Provider unavailable."),
      );

      await expect(
        service.createPayment({
          bookingId: "booking-1",
          studentId: "student-1",
        }),
      ).rejects.toThrow(
        "Provider unavailable.",
      );
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
        provider: "mock",
        providerPaymentId: "mock-booking-1",
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        paidAt: null,
        failureReason: null,
      });

      await service.markProcessing(
        "booking-1",
      );

      expect(
        firestore.get("payments/booking-1")
          ?.status,
      ).toBe(PaymentStatus.processing);
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

    it("does nothing when already processing", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.processing,
      });

      await service.markProcessing(
        "booking-1",
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
        //"Payment cannot be marked as processing.",
        "Payment cannot become processing from paid.",
      );
    });

    it("rejects when the payment has failed", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.failed,
      });

      await expect(
        service.markProcessing(
          "booking-1",
        ),
      ).rejects.toThrow(
        //"Payment cannot be marked as processing.",
        "Payment cannot become processing from failed.",
      );
    });
  });

  // ==================================================
  // markPaid
  // ==================================================

  describe("markPaid", () => {
    const seedValidPaymentAndBooking =
      () => {
        firestore.seed(
          "payments/booking-1",
          {
            bookingId: "booking-1",
            studentId: "student-1",
            tutorId: "tutor-1",
            amountCents: 45000,
            currency: "ZAR",
            status: PaymentStatus.processing,
            provider: "mock",
            providerPaymentId: "mock-booking-1",
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
            paidAt: null,
            failureReason: null,
          },
        );

        firestore.seed(
          "bookings/booking-1",
          {
            studentId: "student-1",
            tutorId: "tutor-1",
            priceCents: 45000,
            status: BookingStatus.paymentRequired,
          },
        );
      };

    it("marks payment as paid and booking as confirmed", async () => {
      seedValidPaymentAndBooking();

      await service.markPaid(
        "booking-1",
        "mock",
        "mock-booking-1",
      );

      const payment =
        firestore.get("payments/booking-1");

      const booking =
        firestore.get("bookings/booking-1");

      expect(payment?.status).toBe(
        PaymentStatus.paid,
      );

      expect(payment?.provider).toBe(
        "mock",
      );

      expect(
        payment?.providerPaymentId,
      ).toBe("mock-booking-1");

      expect(payment?.paidAt).toEqual(
        expect.anything(),
      );

      expect(booking?.status).toBe(
        BookingStatus.confirmed,
      );
    });

    it("rejects when the payment does not exist", async () => {
      await expect(
        service.markPaid(
          "booking-1",
          "mock",
          "mock-booking-1",
        ),
      ).rejects.toThrow(
        "Payment not found.",
      );
    });

    it("does nothing when payment is already paid", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.paid,
      });

      await service.markPaid(
        "booking-1",
        "mock",
        "mock-booking-1",
      );

      expect(
        firestore.transactionUpdate,
      ).not.toHaveBeenCalled();
    });

    it("rejects when payment is not processing", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.pending,
      });

      await expect(
        service.markPaid(
          "booking-1",
          "mock",
          "mock-booking-1",
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
          "mock",
          "mock-booking-1",
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
          "mock",
          "mock-booking-1",
        ),
      ).rejects.toThrow(
        "Booking is not awaiting payment.",
      );
    });

    it("rejects when payment student does not match booking", async () => {
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
        status:
          BookingStatus.paymentRequired,
      });

      await expect(
        service.markPaid(
          "booking-1",
          "mock",
          "mock-booking-1",
        ),
      ).rejects.toThrow(
        //"Payment student does not match booking.",
        "Payment does not belong to the booking.",
      );
    });

    it("rejects when payment tutor does not match booking", async () => {
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
        status:
          BookingStatus.paymentRequired,
      });

      await expect(
        service.markPaid(
          "booking-1",
          "mock",
          "mock-booking-1",
        ),
      ).rejects.toThrow(
        //"Payment tutor does not match booking.",
        "Payment does not belong to the booking.",
      );
    });

    it("rejects when payment amount does not match booking price", async () => {
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
        status:
          BookingStatus.paymentRequired,
      });

      await expect(
        service.markPaid(
          "booking-1",
          "mock",
          "mock-booking-1",
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
    it("marks pending payment as failed", async () => {
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

    it("marks processing payment as failed", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.processing,
        failureReason: null,
      });

      await service.markFailed(
        "booking-1",
        "Payment rejected.",
      );

      const payment = firestore.get("payments/booking-1");

      expect(payment?.status).toBe(
        PaymentStatus.failed,
      );

      expect(payment?.failureReason).toBe(
        "Payment rejected.",
      );
    });

    it("rejects when payment does not exist", async () => {
      await expect(
        service.markFailed(
          "booking-1",
          "Card declined.",
        ),
      ).rejects.toThrow(
        "Payment not found.",
      );
    });

    it("does nothing when payment is already failed", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.failed,
        failureReason: "Card declined.",
      });

      await service.markFailed(
        "booking-1",
        "Another reason.",
      );

      const payment = firestore.get("payments/booking-1");

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

    it("rejects when payment is already paid", async () => {
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

    it("rejects when payment is cancelled", async () => {
      firestore.seed("payments/booking-1", {
        status: PaymentStatus.cancelled,
      });

      await expect(
        service.markFailed(
          "booking-1",
          "Card declined.",
        ),
      ).rejects.toThrow(
        //"Payment cannot be marked as failed.",
        "Payment cannot be marked failed from cancelled.",
      );
    });
  });
});
