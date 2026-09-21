export const MasterclassPayoutStatus = {
  pending: "pending",
  processing: "processing",
  succeeded: "succeeded",
  failed: "failed",
  stuck: "stuck",
  cancelled: "cancelled",
} as const;

export type MasterclassPayoutStatus =
  typeof MasterclassPayoutStatus[keyof typeof MasterclassPayoutStatus];

export interface MasterclassPayout {
  id: string;
  enrollmentId: string;
  paymentId: string;
  masterclassId: string;
  tutorId: string;

  amountCents: number;
  currency: "ZAR";

  status: MasterclassPayoutStatus;

  provider: string | null;
  providerPayoutId: string | null;

  createdAt: Date;
  updatedAt: Date;
  completedAt: Date | null;
  failureReason: string | null;
}
