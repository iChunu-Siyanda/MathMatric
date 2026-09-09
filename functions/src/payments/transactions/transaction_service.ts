import {FieldValue,Firestore, Transaction as FirestoreTransaction,} from "firebase-admin/firestore";
import {Transaction,TransactionDirection,TransactionStatus,TransactionType,} from "./transaction";
import {TransactionReferenceIdentity,} from "./transaction_reference_identity";
import { transactionFromFirestore } from "./transaction_mapper";

export interface CreateTransactionInput {
  transactionId: string;
  bookingId: string;
  paymentId: string;

  type: TransactionType;
  direction: TransactionDirection;
  status: TransactionStatus;

  amountCents: number;
  currency: "ZAR";

  studentId: string;
  tutorId: string;

  referenceId: string;
  description: string;

  completedAt?: Date | null;
}

export interface CreateTransactionResult {
  transaction: Transaction;
  created: boolean;
}

export class TransactionService {
  constructor(
    private readonly firestore: Firestore,
    private readonly referenceIdentity: TransactionReferenceIdentity,
  ) {}

  async createTransaction(
    input: CreateTransactionInput,
  ): Promise<CreateTransactionResult> {
    this.validateInput(input);

    return this.firestore.runTransaction(
      async (firestoreTransaction) => {
        return this.createTransactionInTransaction(
          firestoreTransaction,
          input,
        );
      },
    );
  }

  async createTransactionInTransaction(
    firestoreTransaction: FirestoreTransaction,
    input: CreateTransactionInput,
  ): Promise<CreateTransactionResult> {
    this.validateInput(input);

    const {
      transactionId,
      bookingId,
      paymentId,
      type,
      direction,
      status,
      amountCents,
      currency,
      studentId,
      tutorId,
      referenceId,
      description,
      completedAt = null,
    } = input;

    const transactionRef = this.firestore
      .collection("transactions")
      .doc(transactionId);

    const existingSnapshot =
      await firestoreTransaction.get(transactionRef);

    if (existingSnapshot.exists) {
      const existingData =
        existingSnapshot.data();

      if (!existingData) {
        throw new Error(
          "Transaction data is missing.",
        );
      }

      const existing =
        transactionFromFirestore(
          existingSnapshot.id,
          existingData,
        );

      if (
        existing.referenceId !== referenceId ||
        existing.type !== type
      ) {
        throw new Error(
          "Transaction ID is already associated with different financial data.",
        );
      }

      return {
        transaction: existing,
        created: false,
      };
    }

    const transactionEntity: Transaction = {
      id: transactionId,
      bookingId,
      paymentId,
      type,
      direction,
      status,
      amountCents,
      currency,
      studentId,
      tutorId,
      referenceId,
      description,
      createdAt: new Date(),
      completedAt,
    };

    await this.referenceIdentity.claimInTransaction(
      firestoreTransaction,
      {
        type,
        referenceId,
        transactionId,
        bookingId,
        paymentId,
      },
    );

    firestoreTransaction.create(
      transactionRef,
      {
        bookingId,
        paymentId,
        type,
        direction,
        status,
        amountCents,
        currency,
        studentId,
        tutorId,
        referenceId,
        description,
        createdAt:
          FieldValue.serverTimestamp(),
        completedAt:
          completedAt === null
            ? null
            : completedAt,
      },
    );

    return {
      transaction: transactionEntity,
      created: true,
    };
  }

  private validateInput(
    input: CreateTransactionInput,
  ): void {
    if (
      typeof input.transactionId !== "string" ||
      input.transactionId.trim().length === 0
    ) {
      throw new Error(
        "transactionId is required.",
      );
    }

    if (
      typeof input.bookingId !== "string" ||
      input.bookingId.trim().length === 0
    ) {
      throw new Error(
        "bookingId is required.",
      );
    }

    if (
      typeof input.paymentId !== "string" ||
      input.paymentId.trim().length === 0
    ) {
      throw new Error(
        "paymentId is required.",
      );
    }

    if (
      !Object.values(
        TransactionType,
      ).includes(input.type)
    ) {
      throw new Error(
        "Transaction type is invalid.",
      );
    }

    if (
      !Object.values(
        TransactionDirection,
      ).includes(input.direction)
    ) {
      throw new Error(
        "Transaction direction is invalid.",
      );
    }

    if (
      !Object.values(
        TransactionStatus,
      ).includes(input.status)
    ) {
      throw new Error(
        "Transaction status is invalid.",
      );
    }

    if (
      typeof input.amountCents !== "number" ||
      !Number.isInteger(input.amountCents) ||
      input.amountCents <= 0
    ) {
      throw new Error(
        "Amount must be a positive integer.",
      );
    }

    if (
      input.currency !== "ZAR"
    ) {
      throw new Error(
        "Unsupported currency.",
      );
    }

    if (
      typeof input.studentId !== "string" ||
      input.studentId.trim().length === 0
    ) {
      throw new Error(
        "studentId is required.",
      );
    }

    if (
      typeof input.tutorId !== "string" ||
      input.tutorId.trim().length === 0
    ) {
      throw new Error(
        "tutorId is required.",
      );
    }

    if (
      typeof input.referenceId !== "string" ||
      input.referenceId.trim().length === 0
    ) {
      throw new Error(
        "referenceId is required.",
      );
    }

    if (
      typeof input.description !== "string" ||
      input.description.trim().length === 0
    ) {
      throw new Error(
        "description is required.",
      );
    }

    if (
      input.completedAt !== null &&
      input.completedAt !== undefined &&
      Number.isNaN(
        input.completedAt.getTime(),
      )
    ) {
      throw new Error(
        "completedAt is invalid.",
      );
    }
  }
}
