import {Firestore,FieldValue,} from "firebase-admin/firestore";
import { PayoutProvider } from "./payout_provider";
import { ProviderValidator } from "./provider_validator";

export class PayoutProviderIdentity {
  constructor(
    private readonly firestore: Firestore,
    private readonly payoutProvider: PayoutProvider,
  ) {}

  private getReference(
    providerPayoutId: string,
  ) {
    return this.firestore
      .collection("payoutProviderIds")
      .doc(`${this.payoutProvider.name}:${providerPayoutId}`,);
  }

  async claimInTransaction(
    transaction: FirebaseFirestore.Transaction,
    {
      providerPayoutId,
      payoutId,
    }: {
      providerPayoutId: string;
      payoutId: string;
    },
  ): Promise<void> {
    ProviderValidator.validateProviderPayoutId(
      providerPayoutId,
    );

    const identityRef = this.getReference(providerPayoutId);

    const snapshot = await transaction.get(identityRef);

    if (snapshot.exists) {
      const data = snapshot.data();

      if (
        data?.payoutId === payoutId
      ) {
        return;
      }

      throw new Error(
        "Provider payout ID is already associated with another payout.",
      );
    }

    transaction.create(identityRef, {
      provider: this.payoutProvider.name,
      providerPayoutId,
      payoutId,
      createdAt: FieldValue.serverTimestamp(),
    });
  }
}
