import {FieldValue,Firestore,} from "firebase-admin/firestore";
import {Payment,PaymentStatus,} from "./payment_entity";
import {TransactionDirection,TransactionStatus,TransactionType,} from "../transactions/transaction";
import {TransactionService,} from "../transactions/transaction_service";
import { paymentFromFirestore } from "./payment_mapper";

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

    return this.firestore.runTransaction(
      async (transaction) => {
        const paymentSnapshot = await transaction.get(paymentRef);

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

        if (
          payment.providerPaymentId !==
          providerPaymentId
        ) {
          throw new Error(
            "Provider payment ID does not match the payment.",
          );
        }

        if (
          payment.status === PaymentStatus.paid
        ) {
          if (
            payment.paidAt === null
          ) {
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

        const updatedPayment: Payment = {
          ...payment,
          status: PaymentStatus.paid,
          paidAt,
          updatedAt: paidAt,
          failureReason: null,
        };

        transaction.update(
          paymentRef,
          {
            status: PaymentStatus.paid,
            paidAt,
            updatedAt:
              FieldValue.serverTimestamp(),
            failureReason: null,
          },
        );

        await this.transactionService
          .createTransactionInTransaction(
            transaction,
            {
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
            },
          );

        return updatedPayment;
      },
    );
  }
}
