import { Timestamp } from "firebase-admin/firestore";
import { PaymentStatus } from "./payment_entity";

export interface PaymentDocument {
  bookingId: string;
  studentId: string;
  tutorId: string;

  amountCents: number;
  refundedAmountCents: number;
  currency: "ZAR";

  status: PaymentStatus;

  provider: string | null;
  providerPaymentId: string | null;

  createdAt: Timestamp;
  updatedAt: Timestamp;

  paidAt: Timestamp | null;
  failureReason: string | null;
}
