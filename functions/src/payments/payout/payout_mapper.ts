import {Timestamp,} from "firebase-admin/firestore";
import {PayoutStatus,TutorPayout,} from "./payout_entity";

function isPayoutStatus(
  value: unknown,
): value is PayoutStatus {
  return (
    value === PayoutStatus.pending ||
    value === PayoutStatus.processing ||
    value === PayoutStatus.succeeded ||
    value === PayoutStatus.failed ||
    value === PayoutStatus.cancelled
  );
}

function requireString(
  value: unknown,
  field: string,
): string {
  if (
    typeof value !== "string" ||
    value.trim().length === 0
  ) {
    throw new Error(
      `Invalid payout ${field}.`,
    );
  }

  return value;
}

function requireNonNegativeInteger(
  value: unknown,
  field: string,
): number {
  if (
    typeof value !== "number" ||
    !Number.isInteger(value) ||
    value < 0
  ) {
    throw new Error(
      `Invalid payout ${field}.`,
    );
  }

  return value;
}

function requireTimestamp(
  value: unknown,
  field: string,
): Date {
  if (!(value instanceof Timestamp)) {
    throw new Error(
      `Invalid payout ${field}.`,
    );
  }

  return value.toDate();
}

function requireNullableTimestamp(
  value: unknown,
  field: string,
): Date | null {
  if (value === null) {
    return null;
  }

  return requireTimestamp(value, field);
}

function requireNullableString(
  value: unknown,
  field: string,
): string | null {
  if (value === null) {
    return null;
  }

  return requireString(value, field);
}

export function payoutFromFirestore(
  id: string,
  data: FirebaseFirestore.DocumentData,
): TutorPayout {
  if (!id.trim()) {
    throw new Error(
      "Payout ID cannot be empty.",
    );
  }

  if (!isPayoutStatus(data.status)) {
    throw new Error(
      "Invalid payout status.",
    );
  }

  if (data.currency !== "ZAR") {
    throw new Error(
      "Invalid payout currency.",
    );
  }

  return {
    id,

    bookingId: requireString(
      data.bookingId,
      "bookingId",
    ),

    paymentId: requireString(
      data.paymentId,
      "paymentId",
    ),

    tutorId: requireString(
      data.tutorId,
      "tutorId",
    ),

    amountCents: requireNonNegativeInteger(
      data.amountCents,
      "amountCents",
    ),

    currency: "ZAR",

    status: data.status,

    provider: requireNullableString(
      data.provider,
      "provider",
    ),

    providerPayoutId:requireNullableString(
      data.providerPayoutId,
      "providerPayoutId",
    ),

    createdAt: requireTimestamp(
      data.createdAt,
      "createdAt",
    ),

    updatedAt: requireTimestamp(
      data.updatedAt,
      "updatedAt",
    ),

    completedAt:
      requireNullableTimestamp(
        data.completedAt,
        "completedAt",
      ),

    failureReason:
      requireNullableString(
        data.failureReason,
        "failureReason",
      ),
  };
}
