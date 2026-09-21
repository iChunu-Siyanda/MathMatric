import { Timestamp } from "firebase-admin/firestore";
import {
  MasterclassPayout,
  MasterclassPayoutStatus,
} from "./masterclass_payout_entity";

export function masterclassPayoutFromFirestore(
  id: string,
  data: FirebaseFirestore.DocumentData,
): MasterclassPayout {
  if (!(data.createdAt instanceof Timestamp)) {
    throw new Error(
      "Masterclass payout createdAt is invalid.",
    );
  }

  if (!(data.updatedAt instanceof Timestamp)) {
    throw new Error(
      "Masterclass payout updatedAt is invalid.",
    );
  }

  if (
    typeof data.amountCents !== "number" ||
    !Number.isInteger(data.amountCents) ||
    data.amountCents <= 0
  ) {
    throw new Error(
      "Masterclass payout amountCents is invalid.",
    );
  }

  if (
    !Object.values(MasterclassPayoutStatus).includes(
      data.status,
    )
  ) {
    throw new Error(
      "Masterclass payout status is invalid.",
    );
  }

  return {
    id,
    enrollmentId: data.enrollmentId,
    paymentId: data.paymentId,
    masterclassId: data.masterclassId,
    tutorId: data.tutorId,

    amountCents: data.amountCents,
    currency: data.currency,

    status: data.status,

    provider: data.provider ?? null,
    providerPayoutId: data.providerPayoutId ?? null,

    createdAt: data.createdAt.toDate(),
    updatedAt: data.updatedAt.toDate(),

    completedAt:
      data.completedAt instanceof Timestamp
        ? data.completedAt.toDate()
        : null,

    failureReason: data.failureReason ?? null,
  };
}
