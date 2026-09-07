import { Timestamp } from "firebase-admin/firestore";
import { Payment } from "./payment_entity";

export function paymentFromFirestore(
  id: string,
  data: FirebaseFirestore.DocumentData,
): Payment {
  if (!(data.createdAt instanceof Timestamp)) {
    throw new Error("Payment createdAt is invalid.");
  }

  if (!(data.updatedAt instanceof Timestamp)) {
    throw new Error("Payment updatedAt is invalid.");
  }

  return {
    id,
    bookingId: data.bookingId,
    studentId: data.studentId,
    tutorId: data.tutorId,

    amountCents: data.amountCents,
    currency: data.currency,

    status: data.status,

    provider: data.provider ?? null,
    providerPaymentId: data.providerPaymentId ?? null,

    createdAt: data.createdAt.toDate(),
    updatedAt: data.updatedAt.toDate(),

    paidAt:
      data.paidAt instanceof Timestamp
        ? data.paidAt.toDate()
        : null,

    failureReason: data.failureReason ?? null,
  };
}
