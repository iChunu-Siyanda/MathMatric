export const PayoutStatus = {
  pending: "pending",
  processing: "processing",
  succeeded: "succeeded",
  failed: "failed",
  cancelled: "cancelled",
} as const;

export type PayoutStatus = typeof PayoutStatus[keyof typeof PayoutStatus];

export interface TutorPayout {
  id: string;

  bookingId: string;
  paymentId: string;

  tutorId: string;

  amountCents: number;
  currency: "ZAR";

  status: PayoutStatus;

  provider: string | null;
  providerPayoutId: string | null;

  createdAt: Date;
  updatedAt: Date;

  completedAt: Date | null;

  failureReason: string | null;
}


// Business rules

// A payout is eligible only when:

// Booking exists.
// Booking is completed.
// Payment exists.
// Payment is paid.
// Payment has no outstanding/reserved refund.
// Payment has refundable amount already accounted for.
// Tutor payout amount is greater than 0.
// A successful payout doesn't already exist.
