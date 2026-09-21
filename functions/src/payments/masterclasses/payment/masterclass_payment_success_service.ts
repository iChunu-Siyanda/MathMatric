import { FieldValue, Firestore } from "firebase-admin/firestore";
import {
  MasterclassPayment,
  MasterclassPaymentStatus,
} from "../masterclass/masterclass_payment_entity";
import { masterclassPaymentFromFirestore } from "./masterclass_payment_mapper";
import { MasterclassEnrollmentStatus } from "../enrollment/masterclass_enrollment_entity";
import {
  TransactionDirection,
  TransactionStatus,
  TransactionType,
} from "../../transactions/transaction";
import { TransactionService } from "../../transactions/transaction_service";

export class MasterclassPaymentSuccessService {
  constructor(
    private readonly firestore: Firestore,
    private readonly transactionService: TransactionService,
  ) {}

  async markPaymentPaid({
    enrollmentId,
    providerPaymentId,
    paidAt,
  }: {
    enrollmentId: string;
    providerPaymentId: string;
    paidAt: Date;
  }): Promise<MasterclassPayment> {
    const paymentRef = this.firestore
      .collection("masterclassPayments")
      .doc(enrollmentId);

    const enrollmentRef = this.firestore
      .collection("masterclassEnrollments")
      .doc(enrollmentId);

    return this.firestore.runTransaction(
      async (transaction) => {
        /*
         * ==================================================
         * READ PHASE
         * ==================================================
         */

        const paymentSnapshot =
          await transaction.get(paymentRef);

        if (!paymentSnapshot.exists) {
          throw new Error(
            "Masterclass payment does not exist.",
          );
        }

        const paymentData =
          paymentSnapshot.data();

        if (!paymentData) {
          throw new Error(
            "Masterclass payment data is missing.",
          );
        }

        const payment =
          masterclassPaymentFromFirestore(
            paymentSnapshot.id,
            paymentData,
          );

        /*
         * ==================================================
         * PAYMENT VALIDATION
         * (before the enrollment read, so a payment
         * already in a terminal/invalid status is
         * rejected without requiring the enrollment
         * doc to exist)
         * ==================================================
         */

        if (
          payment.providerPaymentId !==
          providerPaymentId
        ) {
          throw new Error(
            "Provider payment ID does not match the masterclass payment.",
          );
        }

        if (
          payment.status ===
          MasterclassPaymentStatus.paid
        ) {
          if (payment.paidAt === null) {
            throw new Error(
              "Paid masterclass payment is missing paidAt.",
            );
          }

          return payment;
        }

        if (
          payment.status !==
            MasterclassPaymentStatus.pending &&
          payment.status !==
            MasterclassPaymentStatus.processing &&
          payment.status !==
            MasterclassPaymentStatus.stuck
        ) {
          throw new Error(
            "Masterclass payment cannot be marked as paid from its current status.",
          );
        }

        const enrollmentSnapshot =
          await transaction.get(enrollmentRef);

        if (!enrollmentSnapshot.exists) {
          throw new Error(
            "Enrollment does not exist.",
          );
        }

        const enrollmentData =
          enrollmentSnapshot.data();

        if (!enrollmentData) {
          throw new Error(
            "Enrollment data is missing.",
          );
        }

        /*
         * ==================================================
         * ENROLLMENT VALIDATION
         * ==================================================
         */

        if (
          enrollmentData.status !==
          MasterclassEnrollmentStatus.pendingPayment
        ) {
          throw new Error(
            "Enrollment cannot be confirmed from its current status.",
          );
        }

        if (
          enrollmentData.studentId !==
          payment.studentId
        ) {
          throw new Error(
            "Enrollment student does not match the payment.",
          );
        }

        if (
          enrollmentData.tutorId !==
          payment.tutorId
        ) {
          throw new Error(
            "Enrollment tutor does not match the payment.",
          );
        }

        if (
          enrollmentData.priceCents !==
          payment.amountCents
        ) {
          throw new Error(
            "Enrollment price does not match the payment amount.",
          );
        }

        /*
         * ==================================================
         * TRANSACTION READ PHASE
         *
         * Distinct ID prefix from the booking payment
         * ledger ("payment-{id}") so the two can never
         * collide in the shared transactions collection.
         * ==================================================
         */

        const transactionInput = {
          transactionId:
            `masterclass-payment-${payment.id}`,

          bookingId: payment.enrollmentId,
          paymentId: payment.id,

          type: TransactionType.payment,
          direction: TransactionDirection.credit,
          status: TransactionStatus.completed,

          amountCents: payment.amountCents,
          currency: payment.currency,

          studentId: payment.studentId,
          tutorId: payment.tutorId,

          referenceId: payment.id,

          description:
            `Masterclass payment for enrollment ${payment.enrollmentId}`,

          completedAt: paidAt,
        } as const;

        const transactionReadResult =
          await this.transactionService
            .readTransactionInTransaction(
              transaction,
              transactionInput,
            );

        /*
         * ==================================================
         * WRITE PHASE
         * ==================================================
         */

        const updatedPayment: MasterclassPayment = {
          ...payment,
          status: MasterclassPaymentStatus.paid,
          paidAt,
          updatedAt: paidAt,
          failureReason: null,
        };

        transaction.update(paymentRef, {
          status: MasterclassPaymentStatus.paid,
          paidAt,
          updatedAt: FieldValue.serverTimestamp(),
          failureReason: null,
        });

        transaction.update(enrollmentRef, {
          status:
            MasterclassEnrollmentStatus.confirmed,
          updatedAt:
            FieldValue.serverTimestamp(),
        });

        this.transactionService
          .createTransactionFromReadResultInTransaction(
            transaction,
            transactionInput,
            transactionReadResult,
          );

        return updatedPayment;
      },
    );
  }
}
