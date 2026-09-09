import {
  FieldValue,
  Firestore,
  Transaction,
} from "firebase-admin/firestore";

export class PaymentProviderRefundIdentity {
  constructor(
    private readonly firestore: Firestore,
  ) {}

  getReference(
    provider: string,
    providerRefundId: string,
  ) {
    return this.firestore
      .collection("paymentProviderRefundIds")
      .doc(`${provider}:${providerRefundId}`);
  }

  async claimInTransaction(
    transaction: Transaction,
    {
      provider,
      providerRefundId,
      bookingId,
      paymentId,
      refundId,
    }: {
      provider: string;
      providerRefundId: string;
      bookingId: string;
      paymentId: string;
      refundId: string;
    },
  ): Promise<void> {
    const identityRef = this.getReference(
      provider,
      providerRefundId,
    );

    const snapshot = await transaction.get(identityRef);

    const refundPath = `payments/${paymentId}/refunds/${refundId}`;

    if (snapshot.exists) {
      const data = snapshot.data();

      if (
        data?.refundPath === refundPath
      ) {
        return;
      }

      throw new Error(
        "Provider refund ID is already associated with another refund.",
      );
    }

    transaction.create(
      identityRef,
      {
        provider,
        providerRefundId,
        bookingId,
        paymentId,
        refundId,
        refundPath,
        createdAt: FieldValue.serverTimestamp(),
      },
    );
  }
}
