import {FieldValue,Firestore,} from "firebase-admin/firestore";
import {Payment,PaymentStatus,} from "./payment_entity";
import {TransactionDirection,TransactionStatus,TransactionType,} from "../transactions/transaction";
import {TransactionService,} from "../transactions/transaction_service";
import { paymentFromFirestore } from "./payment_mapper";
import { BookingStatus } from "../../bookings/booking_status";

export class PaymentSuccessService {
  constructor(
    private readonly firestore: Firestore,
    private readonly transactionService: TransactionService,
  ) {}

  async markPaymentPaid({
    bookingId,
    providerPaymentId,
    paidAt,
  }: {
    bookingId: string;
    providerPaymentId: string;
    paidAt: Date;
  }): Promise<Payment> {
    const paymentRef = this.firestore
      .collection("payments")
      .doc(bookingId);

    /*
     * IMPORTANT:
     *
     * The booking document has its own generated ID.
     * Therefore we locate it using the bookingId stored
     * in the payment.
     *
     * This assumes the payment's bookingId points to the
     * actual booking document ID.
     */
    const bookingRef = this.firestore
      .collection("bookings")
      .doc(bookingId);

    return this.firestore.runTransaction(
      async (transaction) => {
        /*
         * ==================================================
         * READ PHASE
         * ==================================================
         *
         * ALL reads happen before ANY writes.
         */

        const paymentSnapshot =
          await transaction.get(paymentRef);

        if (!paymentSnapshot.exists) {
          throw new Error(
            "Payment does not exist.",
          );
        }

        const paymentData =
          paymentSnapshot.data();

        if (!paymentData) {
          throw new Error(
            "Payment data is missing.",
          );
        }

        const payment =
          paymentFromFirestore(
            paymentSnapshot.id,
            paymentData,
          );

        const bookingSnapshot =
          await transaction.get(bookingRef);

        if (!bookingSnapshot.exists) {
          throw new Error(
            "Booking does not exist.",
          );
        }

        const bookingData =
          bookingSnapshot.data();

        if (!bookingData) {
          throw new Error(
            "Booking data is missing.",
          );
        }

        /*
         * ==================================================
         * PAYMENT VALIDATION
         * ==================================================
         */

        if (
          payment.providerPaymentId !==
          providerPaymentId
        ) {
          throw new Error(
            "Provider payment ID does not match the payment.",
          );
        }

        /*
         * Idempotent paid webhook.
         */
        if (
          payment.status ===
          PaymentStatus.paid
        ) {
          if (payment.paidAt === null) {
            throw new Error(
              "Paid payment is missing paidAt.",
            );
          }

          return payment;
        }

        if (
          payment.status !==
            PaymentStatus.pending &&
          payment.status !==
            PaymentStatus.processing
        ) {
          throw new Error(
            "Payment cannot be marked as paid from its current status.",
          );
        }

        /*
         * ==================================================
         * BOOKING VALIDATION
         * ==================================================
         */

        if (
          bookingData.status !==
          BookingStatus.paymentRequired
        ) {
          throw new Error(
            "Booking cannot be confirmed from its current status.",
          );
        }

        if (
          bookingData.studentId !==
          payment.studentId
        ) {
          throw new Error(
            "Booking student does not match the payment.",
          );
        }

        if (
          bookingData.tutorId !==
          payment.tutorId
        ) {
          throw new Error(
            "Booking tutor does not match the payment.",
          );
        }

        if (
          bookingData.priceCents !==
          payment.amountCents
        ) {
          throw new Error(
            "Booking price does not match the payment amount.",
          );
        }

        /*
         * ==================================================
         * TRANSACTION READ PHASE
         * ==================================================
         */

        const transactionInput = {
          transactionId:
            `payment-${payment.id}`,

          bookingId:
            payment.bookingId,

          paymentId:
            payment.id,

          type:
            TransactionType.payment,

          direction:
            TransactionDirection.credit,

          status:
            TransactionStatus.completed,

          amountCents:
            payment.amountCents,

          currency:
            payment.currency,

          studentId:
            payment.studentId,

          tutorId:
            payment.tutorId,

          referenceId:
            payment.id,

          description:
            `Payment for booking ${payment.bookingId}`,

          completedAt:
            paidAt,
        } as const;

        /*
         * This performs the transaction and transaction
         * reference reads BEFORE any writes.
         */
        const transactionReadResult =
          await this.transactionService
            .readTransactionInTransaction(
              transaction,
              transactionInput,
            );

        /*
         * ==================================================
         * TRANSACTION VALIDATION
         * ==================================================
         */

        if (
          transactionReadResult.existing !==
          null
        ) {
          const existing =
            transactionReadResult.existing;

          if (
            existing.paymentId !==
              payment.id ||
            existing.bookingId !==
              payment.bookingId ||
            existing.amountCents !==
              payment.amountCents ||
            existing.studentId !==
              payment.studentId ||
            existing.tutorId !==
              payment.tutorId ||
            existing.type !==
              TransactionType.payment ||
            existing.direction !==
              TransactionDirection.credit ||
            existing.status !==
              TransactionStatus.completed
          ) {
            throw new Error(
              "Existing payment transaction does not match the payment.",
            );
          }
        }

        /*
         * ==================================================
         * WRITE PHASE
         * ==================================================
         */

        const updatedPayment: Payment = {
          ...payment,
          status:
            PaymentStatus.paid,
          paidAt,
          updatedAt:
            paidAt,
          failureReason:
            null,
        };

        /*
         * Payment → paid
         */
        transaction.update(
          paymentRef,
          {
            status:
              PaymentStatus.paid,

            paidAt,

            updatedAt:
              FieldValue.serverTimestamp(),

            failureReason:
              null,
          },
        );

        /*
         * Booking → confirmed
         */
        transaction.update(
          bookingRef,
          {
            status:
              BookingStatus.confirmed,

            updatedAt:
              FieldValue.serverTimestamp(),
          },
        );

        /*
         * Payment transaction → completed
         *
         * This method performs writes only because all
         * required reads have already happened.
         */
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
