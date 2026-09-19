import {Firestore,FieldValue,} from "firebase-admin/firestore";
import { PayoutProvider } from "./payout_provider";
import { ProviderValidator } from "./provider_validator";

export interface PayoutProviderIdentityReadResult {
  exists: boolean;
  claimedByPayoutId: string | null;
}

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

  async readClaimInTransaction(
    transaction: FirebaseFirestore.Transaction,
    providerPayoutId: string,
  ): Promise<PayoutProviderIdentityReadResult> {
    ProviderValidator.validateProviderPayoutId(
      providerPayoutId,
    );

    const identityRef =
      this.getReference(providerPayoutId);

    const snapshot =
      await transaction.get(identityRef);

    if (!snapshot.exists) {
      return {
        exists: false,
        claimedByPayoutId: null,
      };
    }

    const data = snapshot.data();

    return {
      exists: true,
      claimedByPayoutId: data?.payoutId ?? null,
    };
  }

  commitClaimFromReadResultInTransaction(
    transaction: FirebaseFirestore.Transaction,
    {
      providerPayoutId,
      payoutId,
    }: {
      providerPayoutId: string;
      payoutId: string;
    },
    readResult: PayoutProviderIdentityReadResult,
  ): void {
    if (readResult.exists) {
      if (
        readResult.claimedByPayoutId ===
        payoutId
      ) {
        return;
      }

      throw new Error(
        "Provider payout ID is already associated with another payout.",
      );
    }

    const identityRef =
      this.getReference(providerPayoutId);

    transaction.create(identityRef, {
      provider: this.payoutProvider.name,
      providerPayoutId,
      payoutId,
      createdAt: FieldValue.serverTimestamp(),
    });
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
    const readResult =
      await this.readClaimInTransaction(
        transaction,
        providerPayoutId,
      );

    this.commitClaimFromReadResultInTransaction(
      transaction,
      { providerPayoutId, payoutId },
      readResult,
    );
  }
}
