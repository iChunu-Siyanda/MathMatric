import { Timestamp } from "firebase-admin/firestore";
import {
  MasterclassPayment,
  MasterclassPaymentStatus,
} from "../masterclass/masterclass_payment_entity";

export function masterclassPaymentFromFirestore(
  id: string,
  data: FirebaseFirestore.DocumentData,
): MasterclassPayment {
  if (!(data.createdAt instanceof Timestamp)) {
    throw new Error(
      "Masterclass payment createdAt is invalid.",
    );
  }

  if (!(data.updatedAt instanceof Timestamp)) {
    throw new Error(
      "Masterclass payment updatedAt is invalid.",
    );
  }

  if (
    typeof data.amountCents !== "number" ||
    !Number.isInteger(data.amountCents) ||
    data.amountCents <= 0
  ) {
    throw new Error(
      "Masterclass payment amountCents is invalid.",
    );
  }

  if (
    !Object.values(MasterclassPaymentStatus).includes(
      data.status,
    )
  ) {
    throw new Error(
      "Masterclass payment status is invalid.",
    );
  }

  return {
    id,
    enrollmentId: data.enrollmentId,
    masterclassId: data.masterclassId,
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
