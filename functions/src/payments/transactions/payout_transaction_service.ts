import {
  Firestore,
  Transaction as FirestoreTransaction,
} from "firebase-admin/firestore";

import {
  Payment,
} from "../payment/payment_entity";

import {
  TransactionDirection,
  TransactionStatus,
  TransactionType,
  Transaction,
} from "./transaction";

import {
  transactionFromFirestore,
} from "../transactions/transaction_mapper";

import {
  TransactionReadResult,
  TransactionService,
} from "../transactions/transaction_service";

import {
  TutorPayout,
} from "../payout/payout_entity";

export interface PayoutTransactionResult {
  transaction: Transaction;
  created: boolean;
}

export class PayoutTransactionService {
  constructor(
    private readonly firestore: Firestore,
    private readonly transactionService: TransactionService,
  ) {}

  async createForPayout(
    payout: TutorPayout,
    booking: {
      id: string;
      studentId: string;
    },
    payment: Payment,
  ): Promise<PayoutTransactionResult> {
    this.validateInput(
      payout,
      booking,
      payment,
    );

    const transactionId =
      `payout-${payout.id}`;

    return this.firestore.runTransaction(
      async (firestoreTransaction) => {
        const readResult =
          await this.transactionService
            .readTransactionInTransaction(
              firestoreTransaction,
              {
                transactionId,
                bookingId: payout.bookingId,
                paymentId: payout.paymentId,
                type: TransactionType.payout,
                direction:
                  TransactionDirection.debit,
                status:
                  TransactionStatus.pending,
                amountCents:
                  payout.amountCents,
                currency: payout.currency,
                studentId:
                  booking.studentId,
                tutorId:
                  payout.tutorId,
                referenceId: payout.id,
                description:
                  `Tutor payout for booking ${payout.bookingId}`,
                completedAt: null,
              },
            );

        return this.transactionService
          .createTransactionFromReadResultInTransaction(
            firestoreTransaction,
            {
              transactionId,
              bookingId: payout.bookingId,
              paymentId: payout.paymentId,
              type: TransactionType.payout,
              direction:
                TransactionDirection.debit,
              status:
                TransactionStatus.pending,
              amountCents:
                payout.amountCents,
              currency: payout.currency,
              studentId:
                booking.studentId,
              tutorId:
                payout.tutorId,
              referenceId: payout.id,
              description:
                `Tutor payout for booking ${payout.bookingId}`,
              completedAt: null,
            },
            readResult,
          );
      },
    );
  }

  async markSucceeded(
    payout: TutorPayout,
  ): Promise<Transaction> {
    const transactionId =
      `payout-${payout.id}`;

    return this.firestore.runTransaction(
      async (firestoreTransaction) => {
        const transaction =
          await this.getTransaction(
            firestoreTransaction,
            transactionId,
          );

        this.validatePayoutTransaction(
          transaction,
          payout,
        );

        if (
          transaction.status ===
          TransactionStatus.completed
        ) {
          return transaction;
        }

        if (
          transaction.status !==
          TransactionStatus.pending
        ) {
          throw new Error(
            "Only a pending payout transaction can be completed.",
          );
        }

        const transactionRef =
          this.firestore
            .collection("transactions")
            .doc(transactionId);

        const completedAt =
          new Date();

        firestoreTransaction.update(
          transactionRef,
          {
            status:
              TransactionStatus.completed,
            completedAt,
          },
        );

        return {
          ...transaction,
          status:
            TransactionStatus.completed,
          completedAt,
        };
      },
    );
  }

  async markFailed(
    payout: TutorPayout,
  ): Promise<Transaction> {
    const transactionId =
      `payout-${payout.id}`;

    return this.firestore.runTransaction(
      async (firestoreTransaction) => {
        const transaction =
          await this.getTransaction(
            firestoreTransaction,
            transactionId,
          );

        this.validatePayoutTransaction(
          transaction,
          payout,
        );

        if (
          transaction.status ===
          TransactionStatus.failed
        ) {
          return transaction;
        }

        if (
          transaction.status !==
          TransactionStatus.pending
        ) {
          throw new Error(
            "Only a pending payout transaction can be failed.",
          );
        }

        const transactionRef =
          this.firestore
            .collection("transactions")
            .doc(transactionId);

        firestoreTransaction.update(
          transactionRef,
          {
            status:
              TransactionStatus.failed,
          },
        );

        return {
          ...transaction,
          status:
            TransactionStatus.failed,
        };
      },
    );
  }

  async createForPayoutInTransaction(
    firestoreTransaction: FirestoreTransaction,
    payout: TutorPayout,
    booking: {
      id: string;
      studentId: string;
    },
    payment: Payment,
  ): Promise<PayoutTransactionResult> {
    const readResult = await this.readForPayoutInTransaction(
      firestoreTransaction,
      payout,
      booking,
      payment,
    );

    return this.createFromReadResultForPayoutInTransaction(
      firestoreTransaction,
      payout,
      booking,
      payment,
      readResult,
    );
  }

  async readForMarkSucceededInTransaction(
    firestoreTransaction: FirestoreTransaction,
    payout: TutorPayout,
  ): Promise<Transaction> {
    const transactionId = `payout-${payout.id}`;

    const transaction =
      await this.getTransaction(
        firestoreTransaction,
        transactionId,
      );

    this.validatePayoutTransaction(
      transaction,
      payout,
    );

    return transaction;
  }

  markSucceededFromReadResultInTransaction(
    firestoreTransaction: FirestoreTransaction,
    payout: TutorPayout,
    transaction: Transaction,
  ): Transaction {
    /*
     * Idempotent.
     */
    if (
      transaction.status ===
      TransactionStatus.completed
    ) {
      return transaction;
    }

    if (
      transaction.status !==
      TransactionStatus.pending
    ) {
      throw new Error(
        "Only a pending payout transaction can be completed.",
      );
    }

    const transactionRef =
      this.firestore
        .collection("transactions")
        .doc(`payout-${payout.id}`);

    const completedAt = new Date();

    firestoreTransaction.update(
      transactionRef,
      {
        status:
          TransactionStatus.completed,
        completedAt,
      },
    );

    return {
      ...transaction,
      status:
        TransactionStatus.completed,
      completedAt,
    };
  }

  async markSucceededInTransaction(
    firestoreTransaction: FirestoreTransaction,
    payout: TutorPayout,
  ): Promise<Transaction> {
    const transaction =
      await this.readForMarkSucceededInTransaction(
        firestoreTransaction,
        payout,
      );

    return this.markSucceededFromReadResultInTransaction(
      firestoreTransaction,
      payout,
      transaction,
    );
  }

  async markFailedInTransaction(
    firestoreTransaction: FirestoreTransaction,
    payout: TutorPayout,
  ): Promise<Transaction> {
    const transactionId =
      `payout-${payout.id}`;

    const transaction =
      await this.getTransaction(
        firestoreTransaction,
        transactionId,
      );

    this.validatePayoutTransaction(
      transaction,
      payout,
    );

    // Idempotent.
    if (
      transaction.status ===
      TransactionStatus.failed
    ) {
      return transaction;
    }

    if (
      transaction.status !==
      TransactionStatus.pending
    ) {
      throw new Error(
        "Only a pending payout transaction can be failed.",
      );
    }

    const transactionRef =
      this.firestore
        .collection("transactions")
        .doc(transactionId);

    firestoreTransaction.update(
      transactionRef,
      {
        status:
          TransactionStatus.failed,
      },
    );

    return {
      ...transaction,
      status:
        TransactionStatus.failed,
    };
  }

  /*
  * READ-ONLY half of createForPayoutInTransaction.
  * Callers that need to perform additional writes
  * of their own (e.g. PayoutService creating the
  * payout doc itself) must call this BEFORE any
  * writes, then call
  * createFromReadResultForPayoutInTransaction after
  * all writes have started.
  */
  async readForPayoutInTransaction(
    firestoreTransaction: FirestoreTransaction,
    payout: TutorPayout,
    booking: {
      id: string;
      studentId: string;
    },
    payment: Payment,
  ): Promise<TransactionReadResult> {
    this.validateInput(payout, booking, payment);

    const input = this.buildPayoutTransactionInput(payout, booking);

    return this.transactionService.readTransactionInTransaction(
      firestoreTransaction,
      input,
    );
  }

  async markPendingForRetryInTransaction(
    firestoreTransaction: FirestoreTransaction,
    payout: TutorPayout,
  ): Promise<Transaction> {
    const transactionId = `payout-${payout.id}`;

    const transaction = await this.getTransaction(
      firestoreTransaction,
      transactionId,
    );

    this.validatePayoutTransaction(
      transaction,
      payout,
    );

    /*
    * Idempotent: already reset.
    */
    if (
      transaction.status ===
      TransactionStatus.pending
    ) {
      return transaction;
    }

    if (
      transaction.status !==
      TransactionStatus.failed
    ) {
      throw new Error(
        "Only a failed payout transaction can be reset for retry.",
      );
    }

    const transactionRef =
      this.firestore
        .collection("transactions")
        .doc(transactionId);

    firestoreTransaction.update(
      transactionRef,
      {
        status: TransactionStatus.pending,
      },
    );

    return {
      ...transaction,
      status: TransactionStatus.pending,
    };
  }

  /*
  * WRITE-ONLY half of createForPayoutInTransaction.
  * Must be called with the TransactionReadResult
  * obtained from readForPayoutInTransaction above,
  * using the SAME Firestore transaction.
  */
  createFromReadResultForPayoutInTransaction(
    firestoreTransaction: FirestoreTransaction,
    payout: TutorPayout,
    booking: {
      id: string;
      studentId: string;
    },
    payment: Payment,
    readResult: TransactionReadResult,
  ): PayoutTransactionResult {
    this.validateInput(payout, booking, payment);

    const input = this.buildPayoutTransactionInput(payout, booking);

    return this.transactionService.createTransactionFromReadResultInTransaction(
      firestoreTransaction,
      input,
      readResult,
    );
  }

  private buildPayoutTransactionInput(
    payout: TutorPayout,
    booking: {
      id: string;
      studentId: string;
    },
  ) {
    return {
      transactionId: `payout-${payout.id}`,
      bookingId: payout.bookingId,
      paymentId: payout.paymentId,
      type: TransactionType.payout,
      direction: TransactionDirection.debit,
      status: TransactionStatus.pending,
      amountCents: payout.amountCents,
      currency: payout.currency,
      studentId: booking.studentId,
      tutorId: payout.tutorId,
      referenceId: payout.id,
      description: `Tutor payout for booking ${payout.bookingId}`,
      completedAt: null,
    } as const;
  }

  private async getTransaction(
    firestoreTransaction: FirestoreTransaction,
    transactionId: string,
  ): Promise<Transaction> {
    const transactionRef =
      this.firestore
        .collection("transactions")
        .doc(transactionId);

    const snapshot =
      await firestoreTransaction.get(
        transactionRef,
      );

    if (!snapshot.exists) {
      throw new Error(
        "Payout transaction does not exist.",
      );
    }

    const data = snapshot.data();

    if (!data) {
      throw new Error(
        "Transaction data is missing.",
      );
    }

    return transactionFromFirestore(
      snapshot.id,
      data,
    );
  }

  private validatePayoutTransaction(
    transaction: Transaction,
    payout: TutorPayout,
  ): void {
    if (
      transaction.type !==
      TransactionType.payout
    ) {
      throw new Error(
        "Transaction is not a payout transaction.",
      );
    }

    if (
      transaction.referenceId !==
      payout.id
    ) {
      throw new Error(
        "Transaction reference does not match the payout.",
      );
    }

    if (
      transaction.bookingId !==
      payout.bookingId
    ) {
      throw new Error(
        "Transaction booking does not match the payout.",
      );
    }

    if (
      transaction.paymentId !==
      payout.paymentId
    ) {
      throw new Error(
        "Transaction payment does not match the payout.",
      );
    }

    if (
      transaction.tutorId !==
      payout.tutorId
    ) {
      throw new Error(
        "Transaction tutor does not match the payout.",
      );
    }

    if (
      transaction.amountCents !==
      payout.amountCents
    ) {
      throw new Error(
        "Transaction amount does not match the payout.",
      );
    }

    if (
      transaction.currency !==
      payout.currency
    ) {
      throw new Error(
        "Transaction currency does not match the payout.",
      );
    }

    if (
      transaction.direction !==
      TransactionDirection.debit
    ) {
      throw new Error(
        "Payout transaction must be a debit.",
      );
    }
  }

  private validateInput(
    payout: TutorPayout,
    booking: {
      id: string;
      studentId: string;
    },
    payment: Payment,
  ): void {
    if (
      payout.bookingId !== booking.id
    ) {
      throw new Error(
        "Payout booking does not match the booking.",
      );
    }

    if (
      payout.paymentId !== payment.id
    ) {
      throw new Error(
        "Payout payment does not match the payment.",
      );
    }

    if (
      payment.bookingId !==
      booking.id
    ) {
      throw new Error(
        "Payment does not belong to the booking.",
      );
    }

    if (
      payment.studentId !==
      booking.studentId
    ) {
      throw new Error(
        "Payment student does not match the booking.",
      );
    }

    if (
      payment.tutorId !==
      payout.tutorId
    ) {
      throw new Error(
        "Payment tutor does not match the payout.",
      );
    }

    if (
      payment.currency !==
      payout.currency
    ) {
      throw new Error(
        "Payment currency does not match the payout.",
      );
    }
  }
}
