import {
  describe,
  expect,
  it,
} from "vitest";

import {
  BookingStatus,
} from "../../../bookings/booking_status";

import {
  PaymentStatus,
} from "../../payment/payment_entity";

import {
  TwentyPercentPlatformFeeCalculator,
} from "../../payout/platform_fee_calculator";

import {
  TutorPayoutEligibilityService,
} from "../../payout/tutor_payout_eligibility_service";

describe(
  "TutorPayoutEligibilityService",
  () => {
    const service =
      new TutorPayoutEligibilityService(
        new TwentyPercentPlatformFeeCalculator(),
      );

    const booking = {
      id: "booking-123",
      studentId: "student-123",
      tutorId: "tutor-123",
      priceCents: 50000,
      status: BookingStatus.completed,
    };

    const payment = {
      id: "booking-123",
      bookingId: "booking-123",
      studentId: "student-123",
      tutorId: "tutor-123",
      amountCents: 50000,
      refundedAmountCents: 0,
      refundReservedAmountCents: 0,
      currency: "ZAR" as const,
      status: PaymentStatus.paid,
      provider: "mock",
      providerPaymentId: "mock-payment-123",
      createdAt: new Date(),
      updatedAt: new Date(),
      paidAt: new Date(),
      failureReason: null,
    };

    it("makes a fully paid completed booking eligible", () => {
      const result =
        service.evaluate({
          booking,
          payment,
        });

      expect(result).toEqual({
        eligible: true,
        reason: null,
        grossAmountCents: 50000,
        platformFeeCents: 10000,
        payoutAmountCents: 40000,
      });
    });

    it("calculates payout after a partial refund", () => {
      const result =
        service.evaluate({
          booking,
          payment: {
            ...payment,
            refundedAmountCents: 10000,
          },
        });

      expect(result).toEqual({
        eligible: true,
        reason: null,
        grossAmountCents: 40000,
        platformFeeCents: 8000,
        payoutAmountCents: 32000,
      });
    });

    it("blocks an incomplete booking", () => {
      const result =
        service.evaluate({
          booking: {
            ...booking,
            status: BookingStatus.confirmed,
          },
          payment,
        });

      expect(result.eligible).toBe(false);
      expect(result.reason).toBe(
        "Booking is not completed.",
      );
    });

    it("blocks an unpaid payment", () => {
      const result =
        service.evaluate({
          booking,
          payment: {
            ...payment,
            status: PaymentStatus.processing,
          },
        });

      expect(result.eligible).toBe(false);
      expect(result.reason).toBe(
        "Payment is not paid.",
      );
    });

    it("blocks a pending refund", () => {
      const result =
        service.evaluate({
          booking,
          payment: {
            ...payment,
            refundReservedAmountCents: 10000,
          },
        });

      expect(result.eligible).toBe(false);
      expect(result.reason).toBe(
        "Payment has a pending refund.",
      );
    });

    it("blocks a fully refunded payment", () => {
      const result =
        service.evaluate({
          booking,
          payment: {
            ...payment,
            refundedAmountCents: 50000,
          },
        });

      expect(result.eligible).toBe(false);
      expect(result.reason).toBe(
        "No tutor payout amount remains.",
      );
    });

    it("rejects mismatched students", () => {
      const result =
        service.evaluate({
          booking,
          payment: {
            ...payment,
            studentId: "different-student",
          },
        });

      expect(result.eligible).toBe(false);
      expect(result.reason).toBe(
        "Booking student does not match the payment.",
      );
    });

    it("rejects mismatched tutors", () => {
      const result =
        service.evaluate({
          booking,
          payment: {
            ...payment,
            tutorId: "different-tutor",
          },
        });

      expect(result.eligible).toBe(false);
      expect(result.reason).toBe(
        "Booking tutor does not match the payment.",
      );
    });

    it("rejects mismatched amounts", () => {
      const result =
        service.evaluate({
          booking,
          payment: {
            ...payment,
            amountCents: 60000,
          },
        });

      expect(result.eligible).toBe(false);
      expect(result.reason).toBe(
        "Booking price does not match the payment amount.",
      );
    });

    it("rejects invalid refund totals", () => {
      expect(() =>
        service.evaluate({
          booking,
          payment: {
            ...payment,
            refundedAmountCents: 40000,
            refundReservedAmountCents: 20001,
          },
        }),
      ).toThrow(
        "Payment refund amounts exceed the payment amount.",
      );
    });
  },
);
