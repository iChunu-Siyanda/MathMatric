import {FieldValue,Firestore,Transaction,} from "firebase-admin/firestore";
import {TransactionType,} from "./transaction";

export class TransactionReferenceIdentity {
  constructor(
    private readonly firestore: Firestore,
  ) {}

  getReference(
    type: TransactionType,
    referenceId: string,
  ) {
    return this.firestore
      .collection("transactionReferences")
      .doc(`${type}:${referenceId}`);
  }

  async claimInTransaction(
    transaction: Transaction,
    {
      type,
      referenceId,
      transactionId,
      bookingId,
      paymentId,
    }: {
      type: TransactionType;
      referenceId: string;
      transactionId: string;
      bookingId: string;
      paymentId: string;
    },
  ): Promise<void> {
    const identityRef = this.getReference(
      type,
      referenceId,
    );

    const snapshot = await transaction.get(identityRef);

    if (snapshot.exists) {
      const data = snapshot.data();

      if (
        data?.transactionId === transactionId
      ) {
        return;
      }

      throw new Error(
        "Transaction reference is already associated with another transaction.",
      );
    }

    transaction.create(
      identityRef,
      {
        type,
        referenceId,
        transactionId,
        bookingId,
        paymentId,
        createdAt: FieldValue.serverTimestamp(),
      },
    );
  }
}
