export const MasterclassPaymentStatus = {
  pending: "pending",
  processing: "processing",
  paid: "paid",
  failed: "failed",
  stuck: "stuck",
  cancelled: "cancelled",
  refunded: "refunded",
} as const;

export type MasterclassPaymentStatus =
  typeof MasterclassPaymentStatus[keyof typeof MasterclassPaymentStatus];

export interface MasterclassPayment {
  id: string;
  enrollmentId: string;
  masterclassId: string;
  studentId: string;
  tutorId: string;

  amountCents: number;
  currency: "ZAR";

  status: MasterclassPaymentStatus;

  provider: string | null;
  providerPaymentId: string | null;

  createdAt: Date;
  updatedAt: Date;

  paidAt: Date | null;
  failureReason: string | null;
}

// Storage: masterclassPayments/{enrollmentId}