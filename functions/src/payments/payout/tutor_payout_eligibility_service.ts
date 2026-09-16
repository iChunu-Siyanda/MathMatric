import {Payment,PaymentStatus,} from "../payment/payment_entity";
import {BookingStatus,} from "../../bookings/booking_status";
import {PlatformFeeCalculator,} from "./platform_fee_calculator";

export interface TutorPayoutEligibilityResult {
  eligible: boolean;
  reason: string | null;

  grossAmountCents: number;
  platformFeeCents: number;
  payoutAmountCents: number;
}

export interface PayoutEligibilityBooking {
  id: string;
  studentId: string;
  tutorId: string;
  priceCents: number;
  status: BookingStatus;
}

export class TutorPayoutEligibilityService {
  constructor(
    private readonly feeCalculator: PlatformFeeCalculator,
  ) {}

  evaluate({
    booking,
    payment,
  }: {
    booking: PayoutEligibilityBooking;
    payment: Payment;
  }): TutorPayoutEligibilityResult {
    this.validateBooking(booking);
    this.validatePayment(payment);

    if (booking.status !== BookingStatus.completed) {
      return this.ineligible(
        "Booking is not completed.",
      );
    }

    if (payment.status !== PaymentStatus.paid) {
      return this.ineligible(
        "Payment is not paid.",
      );
    }

    if (booking.studentId !== payment.studentId) {
      return this.ineligible(
        "Booking student does not match the payment.",
      );
    }

    if (booking.tutorId !== payment.tutorId) {
      return this.ineligible(
        "Booking tutor does not match the payment.",
      );
    }

    if (booking.priceCents !== payment.amountCents) {
      return this.ineligible(
        "Booking price does not match the payment amount.",
      );
    }

    const totalRefundAmountCents =
      payment.refundedAmountCents +
      payment.refundReservedAmountCents;

    if (
      totalRefundAmountCents >
      payment.amountCents
    ) {
      throw new Error(
        "Payment refund amounts exceed the payment amount.",
      );
    }

    if (payment.refundReservedAmountCents > 0) {
      return this.ineligible(
        "Payment has a pending refund.",
      );
    }

    const grossAmountCents =
      payment.amountCents -
      payment.refundedAmountCents;

    if (grossAmountCents <= 0) {
      return this.ineligible(
        "No tutor payout amount remains.",
      );
    }

    const platformFeeCents =
      this.feeCalculator.calculateFeeCents(
        grossAmountCents,
      );

    if (
      !Number.isInteger(platformFeeCents) ||
      platformFeeCents < 0 ||
      platformFeeCents > grossAmountCents
    ) {
      throw new Error(
        "Invalid platform fee.",
      );
    }

    const payoutAmountCents =
      grossAmountCents -
      platformFeeCents;

    if (payoutAmountCents <= 0) {
      return this.ineligible(
        "No tutor payout amount remains after the platform fee.",
      );
    }

    return {
      eligible: true,
      reason: null,
      grossAmountCents,
      platformFeeCents,
      payoutAmountCents,
    };
  }

  private validateBooking(
    booking: PayoutEligibilityBooking,
  ): void {
    if (!booking.id.trim()) {
      throw new Error(
        "Booking ID cannot be empty.",
      );
    }

    if (!booking.studentId.trim()) {
      throw new Error(
        "Booking student ID cannot be empty.",
      );
    }

    if (!booking.tutorId.trim()) {
      throw new Error(
        "Booking tutor ID cannot be empty.",
      );
    }

    if (
      !Number.isInteger(booking.priceCents) ||
      booking.priceCents <= 0
    ) {
      throw new Error(
        "Booking price must be a positive integer.",
      );
    }
  }

  private validatePayment(
    payment: Payment,
  ): void {
    if (!payment.id.trim()) {
      throw new Error(
        "Payment ID cannot be empty.",
      );
    }

    if (!payment.bookingId.trim()) {
      throw new Error(
        "Payment booking ID cannot be empty.",
      );
    }

    if (!Number.isInteger(payment.amountCents) ||
        payment.amountCents <= 0) {
      throw new Error(
        "Payment amount must be a positive integer.",
      );
    }

    if (
      !Number.isInteger(
        payment.refundedAmountCents,
      ) ||
      payment.refundedAmountCents < 0
    ) {
      throw new Error(
        "Refunded amount must be a non-negative integer.",
      );
    }

    if (
      !Number.isInteger(
        payment.refundReservedAmountCents,
      ) ||
      payment.refundReservedAmountCents < 0
    ) {
      throw new Error(
        "Reserved refund amount must be a non-negative integer.",
      );
    }
  }

  private ineligible(
    reason: string,
  ): TutorPayoutEligibilityResult {
    return {
      eligible: false,
      reason,
      grossAmountCents: 0,
      platformFeeCents: 0,
      payoutAmountCents: 0,
    };
  }
}

// I have:

// gross = payment - actual refunds
// fee   = floor(gross × 20%)
// payout = gross - fee

// For a normal R500 booking:

// Payment       R500.00
// Refund        R0.00
// Gross         R500.00
// Platform 20%  R100.00
// Tutor         R400.00

// For a R100 refund:

// Payment       R500.00
// Refund        R100.00
// Gross         R400.00
// Platform 20%  R80.00
// Tutor         R320.00

// And while a refund is reserved/processing, payout is blocked.
