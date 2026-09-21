import { FieldValue, Firestore } from "firebase-admin/firestore";
import {
  MasterclassEnrollment,
  MasterclassEnrollmentStatus,
} from "./masterclass_enrollment_entity";
import { masterclassEnrollmentFromFirestore } from "./masterclass_enrollment_mapper";
import { masterclassFromFirestore } from "../masterclass/masterclass_mapper";
import { MasterclassStatus } from "../masterclass/masterclass_entity";

export class MasterclassEnrollmentService {
  constructor(
    private readonly firestore: Firestore,
  ) {}

  async createEnrollment({
    masterclassId,
    studentId,
  }: {
    masterclassId: string;
    studentId: string;
  }): Promise<MasterclassEnrollment> {
    const masterclassRef = this.firestore
      .collection("masterclasses")
      .doc(masterclassId);

    const enrollmentId =
      `${masterclassId}_${studentId}`;

    const enrollmentRef = this.firestore
      .collection("masterclassEnrollments")
      .doc(enrollmentId);

    return this.firestore.runTransaction(
      async (transaction) => {
        /*
         * All reads before any writes.
         */
        const masterclassSnapshot =
          await transaction.get(
            masterclassRef,
          );

        if (!masterclassSnapshot.exists) {
          throw new Error(
            "Masterclass not found.",
          );
        }

        const masterclassData =
          masterclassSnapshot.data()!;

        const masterclass =
          masterclassFromFirestore(
            masterclassSnapshot.id,
            masterclassData,
          );

        if (
          masterclass.status !==
          MasterclassStatus.published
        ) {
          throw new Error(
            "Masterclass is not published.",
          );
        }

        if (
          masterclass.streamVideoId === null
        ) {
          throw new Error(
            "Masterclass content is not ready yet.",
          );
        }

        const enrollmentSnapshot =
          await transaction.get(
            enrollmentRef,
          );

        if (enrollmentSnapshot.exists) {
          return masterclassEnrollmentFromFirestore(
            enrollmentSnapshot.id,
            enrollmentSnapshot.data()!,
          );
        }

        const now = new Date();

        const enrollment: MasterclassEnrollment = {
          id: enrollmentId,
          masterclassId,
          studentId,
          tutorId: masterclass.tutorId,

          priceCents: masterclass.priceCents,
          currency: masterclass.currency,

          status:
            MasterclassEnrollmentStatus.pendingPayment,

          downloadedAt: null,

          enrolledAt: now,
          updatedAt: now,
          cancelledAt: null,
          refundedAt: null,
        };

        transaction.create(enrollmentRef, {
          masterclassId,
          studentId,
          tutorId: masterclass.tutorId,

          priceCents: masterclass.priceCents,
          currency: masterclass.currency,

          status:
            MasterclassEnrollmentStatus.pendingPayment,

          downloadedAt: null,

          enrolledAt:
            FieldValue.serverTimestamp(),
          updatedAt:
            FieldValue.serverTimestamp(),
          cancelledAt: null,
          refundedAt: null,
        });

        return enrollment;
      },
    );
  }

  async markDownloaded(
    enrollmentId: string,
  ): Promise<void> {
    const enrollmentRef = this.firestore
      .collection("masterclassEnrollments")
      .doc(enrollmentId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const snapshot =
          await transaction.get(
            enrollmentRef,
          );

        if (!snapshot.exists) {
          throw new Error(
            "Enrollment not found.",
          );
        }

        const data = snapshot.data()!;

        if (
          data.status !==
          MasterclassEnrollmentStatus.confirmed
        ) {
          throw new Error(
            "Only a confirmed enrollment can be marked downloaded.",
          );
        }

        /*
         * Idempotent: downloadedAt is set once, on
         * first download. Repeated downloads by the
         * same student do not move the timestamp,
         * since it exists purely as the
         * refund-eligibility / payout-trigger gate,
         * not a download counter.
         */
        if (data.downloadedAt !== null) {
          return;
        }

        transaction.update(enrollmentRef, {
          downloadedAt:
            FieldValue.serverTimestamp(),
          updatedAt:
            FieldValue.serverTimestamp(),
        });
      },
    );
  }
}
