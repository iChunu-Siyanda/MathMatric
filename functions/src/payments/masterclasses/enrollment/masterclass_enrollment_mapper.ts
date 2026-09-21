import { Timestamp } from "firebase-admin/firestore";
import {
  MasterclassEnrollment,
  MasterclassEnrollmentStatus,
} from "../enrollment/masterclass_enrollment_entity";

export function masterclassEnrollmentFromFirestore(
  id: string,
  data: FirebaseFirestore.DocumentData,
): MasterclassEnrollment {
  if (!(data.enrolledAt instanceof Timestamp)) {
    throw new Error("Enrollment enrolledAt is invalid.");
  }

  if (!(data.updatedAt instanceof Timestamp)) {
    throw new Error("Enrollment updatedAt is invalid.");
  }

  if (
    typeof data.priceCents !== "number" ||
    !Number.isInteger(data.priceCents) ||
    data.priceCents <= 0
  ) {
    throw new Error("Enrollment priceCents is invalid.");
  }

  if (
    !Object.values(MasterclassEnrollmentStatus).includes(
      data.status,
    )
  ) {
    throw new Error("Enrollment status is invalid.");
  }

  return {
    id,
    masterclassId: data.masterclassId,
    studentId: data.studentId,
    tutorId: data.tutorId,

    priceCents: data.priceCents,
    currency: data.currency,

    status: data.status,

    downloadedAt:
      data.downloadedAt instanceof Timestamp
        ? data.downloadedAt.toDate()
        : null,

    enrolledAt: data.enrolledAt.toDate(),
    updatedAt: data.updatedAt.toDate(),

    cancelledAt:
      data.cancelledAt instanceof Timestamp
        ? data.cancelledAt.toDate()
        : null,

    refundedAt:
      data.refundedAt instanceof Timestamp
        ? data.refundedAt.toDate()
        : null,
  };
}
