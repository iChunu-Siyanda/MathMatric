export const PaymentStatus = {
  pending: "pending",
  processing: "processing",
  paid: "paid",
  failed: "failed",
  cancelled: "cancelled",
  refunded: "refunded",
  partiallyRefunded: "partially_refunded",
} as const;

export type PaymentStatus = typeof PaymentStatus[keyof typeof PaymentStatus];

export interface Payment {
  id: string;
  bookingId: string;
  studentId: string;
  tutorId: string;

  amountCents: number; //original payment, at all times: refundedAmountCents + refundReservedAmountCents <= amountCents
  refundedAmountCents: number; //money that is successfully refunded.
  refundReservedAmountCents: number; // money currently allocated to pending/processing refunds.
  currency: "ZAR";

  status: PaymentStatus;

  provider: string | null;
  providerPaymentId: string | null;

  createdAt: Date;
  updatedAt: Date;

  paidAt: Date | null;
  failureReason: string | null;
}

// For example:

// Payment: R500

// refundedAmountCents = R0
// refundReservedAmountCents = R0
// available = R500

// Student requests R500 refund:

// refunded = R0
// reserved = R500
// available = R0

// Provider succeeds:

// refunded = R500
// reserved = R0
// available = R0
