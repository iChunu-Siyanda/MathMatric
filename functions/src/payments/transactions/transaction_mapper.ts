import {Timestamp,} from "firebase-admin/firestore";
import {isTransactionDirection, isTransactionStatus, isTransactionType, Transaction,} from "./transaction";

export function transactionFromFirestore(
  id: string,
  data: FirebaseFirestore.DocumentData,
): Transaction {
  if (
    typeof data.bookingId !== "string" ||
    data.bookingId.trim().length === 0
  ) {
    throw new Error(
      "Transaction bookingId is invalid.",
    );
  }

  if (
    typeof data.paymentId !== "string" ||
    data.paymentId.trim().length === 0
  ) {
    throw new Error(
      "Transaction paymentId is invalid.",
    );
  }

  if (
    typeof data.type !== "string" ||
    data.type.trim().length === 0
  ) {
    throw new Error(
      "Transaction type is invalid.",
    );
  }

  if (
    typeof data.direction !== "string" ||
    data.direction.trim().length === 0
  ) {
    throw new Error(
      "Transaction direction is invalid.",
    );
  }

  if (
    typeof data.status !== "string" ||
    data.status.trim().length === 0
  ) {
    throw new Error(
      "Transaction status is invalid.",
    );
  }

  if (
    typeof data.amountCents !== "number" ||
    !Number.isInteger(data.amountCents) ||
    data.amountCents <= 0
  ) {
    throw new Error(
      "Transaction amountCents is invalid.",
    );
  }

  if (data.currency !== "ZAR") {
    throw new Error(
      "Transaction currency is invalid.",
    );
  }

  if (
    typeof data.studentId !== "string" ||
    data.studentId.trim().length === 0
  ) {
    throw new Error(
      "Transaction studentId is invalid.",
    );
  }

  if (
    typeof data.tutorId !== "string" ||
    data.tutorId.trim().length === 0
  ) {
    throw new Error(
      "Transaction tutorId is invalid.",
    );
  }

  if (
    typeof data.referenceId !== "string" ||
    data.referenceId.trim().length === 0
  ) {
    throw new Error(
      "Transaction referenceId is invalid.",
    );
  }

  if (
    typeof data.description !== "string" ||
    data.description.trim().length === 0
  ) {
    throw new Error(
      "Transaction description is invalid.",
    );
  }

  if (
    !(data.createdAt instanceof Timestamp)
  ) {
    throw new Error(
      "Transaction createdAt is invalid.",
    );
  }

  if (
    data.completedAt !== null &&
    !(data.completedAt instanceof Timestamp)
  ) {
    throw new Error(
      "Transaction completedAt is invalid.",
    );
  }

  if (!isTransactionType(data.type)) {
    throw new Error(
        "Transaction type is invalid.",
    );
  }

  if (!isTransactionDirection(data.direction)) {
    throw new Error(
        "Transaction direction is invalid.",
    );
  }

  if (!isTransactionStatus(data.status)) {
    throw new Error(
        "Transaction status is invalid.",
    );
  }

  return {
    id,

    bookingId: data.bookingId,
    paymentId: data.paymentId,

    type: data.type,
    direction: data.direction,
    status: data.status,

    amountCents: data.amountCents,

    currency: data.currency,

    studentId: data.studentId,
    tutorId: data.tutorId,

    referenceId: data.referenceId,

    description: data.description,

    createdAt:
      data.createdAt.toDate(),

    completedAt:
      data.completedAt instanceof Timestamp
        ? data.completedAt.toDate()
        : null,
  };
}
