export const RefundStatus = {
  pending: "pending",
  processing: "processing",
  succeeded: "succeeded",
  failed: "failed",
  cancelled: "cancelled",
} as const;

export type RefundStatus = typeof RefundStatus[keyof typeof RefundStatus];

export interface Refund {
  id: string;

  paymentId: string;
  bookingId: string;

  studentId: string;
  tutorId: string;

  amountCents: number;
  currency: "ZAR";

  status: RefundStatus;

  provider: string | null;
  providerRefundId: string | null;

  reason: string;

  createdAt: Date;
  updatedAt: Date;

  completedAt: Date | null;
  failureReason: string | null;
}

// ┌─────────────────────────────────────────┐
// │              PAYMENT                    │
// │                                         │
// │ amountCents        = 50 000             │
// │ refundedAmountCents = 20 000            │
// │                                         │
// │ remaining           = 30 000             │
// └─────────────────────────────────────────┘
//                     │
//                     ▼
//           Refund request = 20 000
//                     │
//                     ▼
//         Firestore transaction
//                     │
//           ┌─────────┴─────────┐
//           ▼                   ▼
//    create refund        update aggregate
//    pending              20 000 → 40 000
