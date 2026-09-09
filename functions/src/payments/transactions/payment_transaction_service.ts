import {Payment,PaymentStatus,} from "../payment/payment_entity";
import {Transaction,TransactionDirection,TransactionStatus,TransactionType,} from "./transaction";
import {TransactionService,} from "./transaction_service";

export interface CreatePaymentTransactionResult {
  transaction: Transaction;
  created: boolean;
}

export class PaymentTransactionService {
  constructor(
    private readonly transactionService: TransactionService,
  ) {}

  async createForPaidPayment(
    payment: Payment,
  ): Promise<CreatePaymentTransactionResult> {
    this.validatePayment(payment);

    return this.transactionService.createTransaction({
      transactionId: `payment-${payment.id}`,

      bookingId: payment.bookingId,
      paymentId: payment.id,

      type: TransactionType.payment,
      direction: TransactionDirection.credit,
      status: TransactionStatus.completed,

      amountCents: payment.amountCents,
      currency: payment.currency,

      studentId: payment.studentId,
      tutorId: payment.tutorId,

      referenceId: payment.id,

      description: `Payment for booking ${payment.bookingId}`,
      completedAt: payment.paidAt,
    });
  }

  private validatePayment(
    payment: Payment,
  ): void {
    if (
      payment.status !== PaymentStatus.paid
    ) {
      throw new Error(
        "A payment transaction can only be created for a paid payment.",
      );
    }

    if (payment.paidAt === null) {
      throw new Error(
        "A paid payment must have a paidAt timestamp.",
      );
    }
  }
}
