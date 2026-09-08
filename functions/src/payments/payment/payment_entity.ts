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

  amountCents: number;
  currency: "ZAR";

  status: PaymentStatus;

  provider: string | null;
  providerPaymentId: string | null;

  createdAt: Date;
  updatedAt: Date;

  paidAt: Date | null;
  failureReason: string | null;
}
