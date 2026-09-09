import { Timestamp } from "firebase-admin/firestore";
import { Refund, RefundStatus } from "./refund";

export function refundFromFirestore(
  id: string,
  data: FirebaseFirestore.DocumentData,
): Refund {
  if (
    typeof data.paymentId !== "string" ||
    data.paymentId.length === 0
  ) {
    throw new Error(
      "Refund paymentId is invalid.",
    );
  }

  if (
    typeof data.bookingId !== "string" ||
    data.bookingId.length === 0
  ) {
    throw new Error(
      "Refund bookingId is invalid.",
    );
  }

  if (
    typeof data.studentId !== "string" ||
    data.studentId.length === 0
  ) {
    throw new Error(
      "Refund studentId is invalid.",
    );
  }

  if (
    typeof data.tutorId !== "string" ||
    data.tutorId.length === 0
  ) {
    throw new Error(
      "Refund tutorId is invalid.",
    );
  }

  if (
    typeof data.amountCents !== "number" ||
    !Number.isInteger(data.amountCents) ||
    data.amountCents <= 0
  ) {
    throw new Error(
      "Refund amountCents is invalid.",
    );
  }

  if (
  typeof data.refundedAmountCents !== "number" ||
    !Number.isInteger(data.refundedAmountCents) ||
    data.refundedAmountCents < 0
  ) {
    throw new Error(
        "Payment refundedAmountCents is invalid.",
    );
  }

  if (
    data.refundedAmountCents >
    data.amountCents
  ) {
    throw new Error(
        "Payment refundedAmountCents exceeds amountCents.",
    );
  }

  if (data.currency !== "ZAR") {
    throw new Error(
      "Refund currency is invalid.",
    );
  }

  const status = typeof data.status === "string"
      ? Object.values(RefundStatus).find(
        (allowedStatus) => allowedStatus === data.status,
      )
      : undefined;

  if (status === undefined) {
    throw new Error(
      "Refund status is invalid.",
    );
  }

  if (
    typeof data.reason !== "string" ||
    data.reason.length === 0
  ) {
    throw new Error(
      "Refund reason is invalid.",
    );
  }

  if (
    !(data.createdAt instanceof Timestamp)
  ) {
    throw new Error(
      "Refund createdAt is invalid.",
    );
  }

  if (
    !(data.updatedAt instanceof Timestamp)
  ) {
    throw new Error(
      "Refund updatedAt is invalid.",
    );
  }

  return {
    id,

    paymentId: data.paymentId,
    bookingId: data.bookingId,

    studentId: data.studentId,
    tutorId: data.tutorId,

    amountCents: data.amountCents,
    currency: data.currency,

    status,

    provider: data.provider ?? null,
    providerRefundId: data.providerRefundId ?? null,

    reason: data.reason,

    createdAt: data.createdAt.toDate(),
    updatedAt: data.updatedAt.toDate(),

    completedAt: data.completedAt instanceof Timestamp
        ? data.completedAt.toDate()
        : null,

    failureReason: data.failureReason ?? null,
  };
}
