import { FieldValue, Firestore, Transaction as FirestoreTransaction } from "firebase-admin/firestore";
import { MasterclassPayout, MasterclassPayoutStatus } from "./masterclass_payout_entity";
import { masterclassPayoutFromFirestore } from "./masterclass_payout_mapper";
import { MasterclassPayoutEligibilityService } from "./masterclass_payout_eligibility_service";
import { MasterclassEnrollment } from "../enrollment/masterclass_enrollment_entity";
import { MasterclassPayment } from "../payment/masterclass_payment_entity";
import { PayoutProvider, PayoutProviderOutcomeUnknownError } from "../../provider/payout_provider";
import { PayoutProviderIdentity } from "../../provider/payout_provider_identity";
import { ProviderValidator } from "../../provider/provider_validator";
import {
  TransactionDirection,
  TransactionStatus,
  TransactionType,
  Transaction,
} from "../../transactions/transaction";
import { TransactionService, TransactionReadResult } from "../../transactions/transaction_service";
import { transactionFromFirestore } from "../../transactions/transaction_mapper";

export interface CreateMasterclassPayoutResult {
  payout: MasterclassPayout;
  created: boolean;
}

export class MasterclassPayoutInitiationInProgressError extends Error {
  constructor(
    message = "Masterclass payout initiation is already in progress for this payout. Retry shortly.",
  ) {
    super(message);
    this.name = "MasterclassPayoutInitiationInProgressError";
  }
}

export class MasterclassPayoutService {
  constructor(
    private readonly firestore: Firestore,
    private readonly eligibilityService: MasterclassPayoutEligibilityService,
    private readonly transactionService: TransactionService,
    private readonly payoutProvider: PayoutProvider,
    private readonly payoutProviderIdentity: PayoutProviderIdentity,
  ) {}

  // ==================================================
  // Ledger helpers (inline, no dedicated wrapper class)
  // ==================================================

  private ledgerTransactionId(payoutId: string): string {
    return `masterclass-payout-${payoutId}`;
  }

  private buildLedgerInput(
    payout: MasterclassPayout,
    enrollment: { id: string; studentId: string },
  ) {
    return {
      transactionId: this.ledgerTransactionId(payout.id),
      bookingId: payout.enrollmentId,
      paymentId: payout.paymentId,
      type: TransactionType.payout,
      direction: TransactionDirection.debit,
      status: TransactionStatus.pending,
      amountCents: payout.amountCents,
      currency: payout.currency,
      studentId: enrollment.studentId,
      tutorId: payout.tutorId,
      referenceId: payout.id,
      description: `Masterclass payout for enrollment ${payout.enrollmentId}`,
      completedAt: null,
    } as const;
  }

  private async readLedgerTransaction(
    firestoreTransaction: FirestoreTransaction,
    payoutId: string,
  ): Promise<Transaction> {
    const ref = this.firestore
      .collection("transactions")
      .doc(this.ledgerTransactionId(payoutId));

    const snapshot = await firestoreTransaction.get(ref);

    if (!snapshot.exists) {
      throw new Error(
        "Masterclass payout transaction does not exist.",
      );
    }

    const data = snapshot.data();

    if (!data) {
      throw new Error(
        "Masterclass payout transaction data is missing.",
      );
    }

    return transactionFromFirestore(snapshot.id, data);
  }

  private validateLedgerTransaction(
    transaction: Transaction,
    payout: MasterclassPayout,
  ): void {
    if (transaction.type !== TransactionType.payout) {
      throw new Error(
        "Transaction is not a masterclass payout transaction.",
      );
    }

    if (transaction.referenceId !== payout.id) {
      throw new Error(
        "Transaction reference does not match the masterclass payout.",
      );
    }

    if (transaction.tutorId !== payout.tutorId) {
      throw new Error(
        "Transaction tutor does not match the masterclass payout.",
      );
    }

    if (transaction.amountCents !== payout.amountCents) {
      throw new Error(
        "Transaction amount does not match the masterclass payout.",
      );
    }

    if (transaction.currency !== payout.currency) {
      throw new Error(
        "Transaction currency does not match the masterclass payout.",
      );
    }
  }

  private markLedgerSucceeded(
    firestoreTransaction: FirestoreTransaction,
    payout: MasterclassPayout,
    transaction: Transaction,
  ): Transaction {
    if (transaction.status === TransactionStatus.completed) {
      return transaction;
    }

    if (transaction.status !== TransactionStatus.pending) {
      throw new Error(
        "Only a pending masterclass payout transaction can be completed.",
      );
    }

    const ref = this.firestore
      .collection("transactions")
      .doc(this.ledgerTransactionId(payout.id));

    const completedAt = new Date();

    firestoreTransaction.update(ref, {
      status: TransactionStatus.completed,
      completedAt,
    });

    return { ...transaction, status: TransactionStatus.completed, completedAt };
  }

  private markLedgerFailed(
    firestoreTransaction: FirestoreTransaction,
    payout: MasterclassPayout,
    transaction: Transaction,
  ): Transaction {
    if (transaction.status === TransactionStatus.failed) {
      return transaction;
    }

    if (transaction.status !== TransactionStatus.pending) {
      throw new Error(
        "Only a pending masterclass payout transaction can be failed.",
      );
    }

    const ref = this.firestore
      .collection("transactions")
      .doc(this.ledgerTransactionId(payout.id));

    firestoreTransaction.update(ref, {
      status: TransactionStatus.failed,
    });

    return { ...transaction, status: TransactionStatus.failed };
  }

  private markLedgerPendingForRetry(
    firestoreTransaction: FirestoreTransaction,
    payout: MasterclassPayout,
    transaction: Transaction,
  ): Transaction {
    if (transaction.status === TransactionStatus.pending) {
      return transaction;
    }

    if (transaction.status !== TransactionStatus.failed) {
      throw new Error(
        "Only a failed masterclass payout transaction can be reset for retry.",
      );
    }

    const ref = this.firestore
      .collection("transactions")
      .doc(this.ledgerTransactionId(payout.id));

    firestoreTransaction.update(ref, {
      status: TransactionStatus.pending,
    });

    return { ...transaction, status: TransactionStatus.pending };
  }

  // ==================================================
  // createPayout
  // ==================================================

  async createPayout({
    enrollment,
    payment,
  }: {
    enrollment: MasterclassEnrollment;
    payment: MasterclassPayment;
  }): Promise<CreateMasterclassPayoutResult> {
    const eligibility = this.eligibilityService.evaluate({
      enrollment,
      payment,
    });

    if (!eligibility.eligible) {
      throw new Error(
        eligibility.reason ?? "Enrollment is not eligible for payout.",
      );
    }

    const payoutId = `masterclass-payout-${enrollment.id}`;

    return this.firestore.runTransaction(async (firestoreTransaction) => {
      const payoutRef = this.firestore
        .collection("masterclassPayouts")
        .doc(payoutId);

      const payoutSnapshot = await firestoreTransaction.get(payoutRef);

      if (payoutSnapshot.exists) {
        const data = payoutSnapshot.data();

        if (!data) {
          throw new Error("Masterclass payout data is missing.");
        }

        const existingPayout = masterclassPayoutFromFirestore(
          payoutSnapshot.id,
          data,
        );

        if (existingPayout.enrollmentId !== enrollment.id) {
          throw new Error(
            "Existing masterclass payout belongs to a different enrollment.",
          );
        }

        if (existingPayout.paymentId !== payment.id) {
          throw new Error(
            "Existing masterclass payout belongs to a different payment.",
          );
        }

        if (existingPayout.amountCents !== eligibility.payoutAmountCents) {
          throw new Error(
            "Existing masterclass payout amount does not match the eligible payout amount.",
          );
        }

        return { payout: existingPayout, created: false };
      }

      const now = new Date();

      const payout: MasterclassPayout = {
        id: payoutId,
        enrollmentId: enrollment.id,
        paymentId: payment.id,
        masterclassId: enrollment.masterclassId,
        tutorId: enrollment.tutorId,

        amountCents: eligibility.payoutAmountCents,
        currency: "ZAR",
        status: MasterclassPayoutStatus.pending,

        provider: null,
        providerPayoutId: null,

        createdAt: now,
        updatedAt: now,
        completedAt: null,

        failureReason: null,
      };

      /*
       * READ: ledger transaction + reference, before any writes.
       */
      const ledgerInput = this.buildLedgerInput(payout, enrollment);

      const ledgerReadResult: TransactionReadResult =
        await this.transactionService.readTransactionInTransaction(
          firestoreTransaction,
          ledgerInput,
        );

      /*
       * WRITE from here on.
       */
      firestoreTransaction.create(payoutRef, {
        enrollmentId: payout.enrollmentId,
        paymentId: payout.paymentId,
        masterclassId: payout.masterclassId,
        tutorId: payout.tutorId,
        amountCents: payout.amountCents,
        currency: payout.currency,
        status: payout.status,
        provider: payout.provider,
        providerPayoutId: payout.providerPayoutId,
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
        completedAt: null,
        failureReason: null,
      });

      this.transactionService.createTransactionFromReadResultInTransaction(
        firestoreTransaction,
        ledgerInput,
        ledgerReadResult,
      );

      return { payout, created: true };
    });
  }

  // ==================================================
  // markProcessing / markSucceeded / markFailed
  // ==================================================

  async markProcessing(
    payoutId: string,
    expectedProviderPayoutId?: string,
  ): Promise<MasterclassPayout> {
    const payoutRef = this.firestore
      .collection("masterclassPayouts")
      .doc(payoutId);

    return this.firestore.runTransaction(async (firestoreTransaction) => {
      const snapshot = await firestoreTransaction.get(payoutRef);

      if (!snapshot.exists) {
        throw new Error("Masterclass payout does not exist.");
      }

      const data = snapshot.data();

      if (!data) {
        throw new Error("Masterclass payout data is missing.");
      }

      const payout = masterclassPayoutFromFirestore(snapshot.id, data);

      this.validateExpectedProviderPayoutId(payout, expectedProviderPayoutId);

      if (payout.status === MasterclassPayoutStatus.processing) {
        return payout;
      }

      if (payout.status !== MasterclassPayoutStatus.pending) {
        throw new Error(
          "Only a pending masterclass payout can be moved to processing.",
        );
      }

      firestoreTransaction.update(payoutRef, {
        status: MasterclassPayoutStatus.processing,
        updatedAt: FieldValue.serverTimestamp(),
      });

      return { ...payout, status: MasterclassPayoutStatus.processing };
    });
  }

  async markSucceeded(
    payoutId: string,
    expectedProviderPayoutId?: string,
  ): Promise<MasterclassPayout> {
    const payoutRef = this.firestore
      .collection("masterclassPayouts")
      .doc(payoutId);

    return this.firestore.runTransaction(async (firestoreTransaction) => {
      const snapshot = await firestoreTransaction.get(payoutRef);

      if (!snapshot.exists) {
        throw new Error("Masterclass payout does not exist.");
      }

      const data = snapshot.data();

      if (!data) {
        throw new Error("Masterclass payout data is missing.");
      }

      const payout = masterclassPayoutFromFirestore(snapshot.id, data);

      this.validateExpectedProviderPayoutId(payout, expectedProviderPayoutId);

      if (payout.status === MasterclassPayoutStatus.succeeded) {
        return payout;
      }

      if (payout.status !== MasterclassPayoutStatus.processing) {
        throw new Error(
          "Only a processing masterclass payout can succeed.",
        );
      }

      const ledgerTransaction = await this.readLedgerTransaction(
        firestoreTransaction,
        payout.id,
      );

      this.validateLedgerTransaction(ledgerTransaction, payout);

      this.markLedgerSucceeded(firestoreTransaction, payout, ledgerTransaction);

      const completedAt = new Date();

      firestoreTransaction.update(payoutRef, {
        status: MasterclassPayoutStatus.succeeded,
        completedAt,
        updatedAt: FieldValue.serverTimestamp(),
        failureReason: null,
      });

      return {
        ...payout,
        status: MasterclassPayoutStatus.succeeded,
        completedAt,
        failureReason: null,
      };
    });
  }

  async markFailed(
    payoutId: string,
    failureReason: string,
    expectedProviderPayoutId?: string,
  ): Promise<MasterclassPayout> {
    if (!failureReason.trim()) {
      throw new Error("Failure reason cannot be empty.");
    }

    const payoutRef = this.firestore
      .collection("masterclassPayouts")
      .doc(payoutId);

    return this.firestore.runTransaction(async (firestoreTransaction) => {
      const snapshot = await firestoreTransaction.get(payoutRef);

      if (!snapshot.exists) {
        throw new Error("Masterclass payout does not exist.");
      }

      const data = snapshot.data();

      if (!data) {
        throw new Error("Masterclass payout data is missing.");
      }

      const payout = masterclassPayoutFromFirestore(snapshot.id, data);

      this.validateExpectedProviderPayoutId(payout, expectedProviderPayoutId);

      if (payout.status === MasterclassPayoutStatus.failed) {
        return payout;
      }

      if (
        payout.status !== MasterclassPayoutStatus.pending &&
        payout.status !== MasterclassPayoutStatus.processing
      ) {
        throw new Error(
          "Only a pending or processing masterclass payout can fail.",
        );
      }

      const ledgerTransaction = await this.readLedgerTransaction(
        firestoreTransaction,
        payout.id,
      );

      this.validateLedgerTransaction(ledgerTransaction, payout);

      this.markLedgerFailed(firestoreTransaction, payout, ledgerTransaction);

      const reason = failureReason.trim();

      firestoreTransaction.update(payoutRef, {
        status: MasterclassPayoutStatus.failed,
        failureReason: reason,
        updatedAt: FieldValue.serverTimestamp(),
      });

      return { ...payout, status: MasterclassPayoutStatus.failed, failureReason: reason };
    });
  }

  // ==================================================
  // attachProviderPayoutId
  // ==================================================

  async attachProviderPayoutId(
    payoutId: string,
    providerPayoutId: string,
  ): Promise<void> {
    ProviderValidator.validateProviderPayoutId(providerPayoutId);

    const payoutRef = this.firestore
      .collection("masterclassPayouts")
      .doc(payoutId);

    await this.firestore.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(payoutRef);

      if (!snapshot.exists) {
        throw new Error("Masterclass payout does not exist.");
      }

      const data = snapshot.data();

      if (!data) {
        throw new Error("Masterclass payout data is missing.");
      }

      const existingProvider = data.provider ?? null;
      const existingProviderPayoutId = data.providerPayoutId ?? null;

      if (existingProviderPayoutId !== null) {
        if (existingProviderPayoutId === providerPayoutId) {
          return;
        }

        throw new Error(
          "Masterclass payout is already associated with a different provider payout ID.",
        );
      }

      if (
        existingProvider !== null &&
        existingProvider !== this.payoutProvider.name
      ) {
        throw new Error(
          "Masterclass payout is already associated with a different provider.",
        );
      }

      await this.payoutProviderIdentity.claimInTransaction(transaction, {
        providerPayoutId,
        payoutId,
      });

      transaction.update(payoutRef, {
        provider: this.payoutProvider.name,
        providerPayoutId,
        updatedAt: FieldValue.serverTimestamp(),
      });
    });
  }

  // ==================================================
  // initiatePayout (concurrency-safe claim, same fix as PayoutService)
  // ==================================================

  private async claimForInitiation(
    payoutId: string,
  ): Promise<{ payout: MasterclassPayout; claimed: boolean }> {
    const payoutRef = this.firestore
      .collection("masterclassPayouts")
      .doc(payoutId);

    return this.firestore.runTransaction(async (firestoreTransaction) => {
      const snapshot = await firestoreTransaction.get(payoutRef);

      if (!snapshot.exists) {
        throw new Error("Masterclass payout does not exist.");
      }

      const data = snapshot.data();

      if (!data) {
        throw new Error("Masterclass payout data is missing.");
      }

      const payout = masterclassPayoutFromFirestore(snapshot.id, data);

      if (
        payout.providerPayoutId !== null ||
        payout.status === MasterclassPayoutStatus.succeeded
      ) {
        return { payout, claimed: false };
      }

      if (payout.status === MasterclassPayoutStatus.processing) {
        return { payout, claimed: false };
      }

      if (payout.status !== MasterclassPayoutStatus.pending) {
        throw new Error(
          "Only pending masterclass payouts can be initiated.",
        );
      }

      firestoreTransaction.update(payoutRef, {
        status: MasterclassPayoutStatus.processing,
        updatedAt: FieldValue.serverTimestamp(),
      });

      return {
        payout: { ...payout, status: MasterclassPayoutStatus.processing },
        claimed: true,
      };
    });
  }

  async initiatePayout(payoutId: string): Promise<MasterclassPayout> {
    const { payout, claimed } = await this.claimForInitiation(payoutId);

    if (payout.providerPayoutId !== null) {
      return payout;
    }

    if (payout.status === MasterclassPayoutStatus.succeeded) {
      return payout;
    }

    if (!claimed) {
      throw new MasterclassPayoutInitiationInProgressError();
    }

    try {
      const result = await this.payoutProvider.createPayout({
        amountCents: payout.amountCents,
        currency: payout.currency,
        payoutId: payout.id,
        tutorId: payout.tutorId,
      });

      ProviderValidator.validateProviderPayoutId(result.providerPayoutId);

      await this.attachProviderPayoutId(payout.id, result.providerPayoutId);

      const payoutRef = this.firestore
        .collection("masterclassPayouts")
        .doc(payoutId);

      const updatedSnapshot = await payoutRef.get();

      if (!updatedSnapshot.exists) {
        throw new Error(
          "Masterclass payout disappeared after provider initiation.",
        );
      }

      const updatedData = updatedSnapshot.data();

      if (!updatedData) {
        throw new Error(
          "Masterclass payout data is missing after provider initiation.",
        );
      }

      return masterclassPayoutFromFirestore(updatedSnapshot.id, updatedData);
    } catch (error) {
      if (error instanceof PayoutProviderOutcomeUnknownError) {
        throw error;
      }

      await this.markFailed(
        payout.id,
        error instanceof Error
          ? error.message
          : "Masterclass payout provider initiation failed.",
      );

      throw error;
    }
  }

  // ==================================================
  // retryPayout
  // ==================================================

  async retryPayout(payoutId: string): Promise<MasterclassPayout> {
    const payoutRef = this.firestore
      .collection("masterclassPayouts")
      .doc(payoutId);

    return this.firestore.runTransaction(async (firestoreTransaction) => {
      const snapshot = await firestoreTransaction.get(payoutRef);

      if (!snapshot.exists) {
        throw new Error("Masterclass payout does not exist.");
      }

      const data = snapshot.data();

      if (!data) {
        throw new Error("Masterclass payout data is missing.");
      }

      const payout = masterclassPayoutFromFirestore(snapshot.id, data);

      if (payout.status === MasterclassPayoutStatus.pending) {
        return payout;
      }

      if (payout.status === MasterclassPayoutStatus.succeeded) {
        return payout;
      }

      if (payout.status === MasterclassPayoutStatus.processing) {
        throw new Error(
          "Cannot retry a masterclass payout that is currently processing.",
        );
      }

      if (payout.status === MasterclassPayoutStatus.cancelled) {
        throw new Error(
          "Cancelled masterclass payouts cannot be retried.",
        );
      }

      if (payout.providerPayoutId !== null) {
        throw new Error(
          "Masterclass payout already has a provider payout ID attached and cannot be retried automatically. Resolve via reconciliation.",
        );
      }

      const ledgerTransaction = await this.readLedgerTransaction(
        firestoreTransaction,
        payout.id,
      );

      this.validateLedgerTransaction(ledgerTransaction, payout);

      this.markLedgerPendingForRetry(firestoreTransaction, payout, ledgerTransaction);

      firestoreTransaction.update(payoutRef, {
        status: MasterclassPayoutStatus.pending,
        failureReason: null,
        updatedAt: FieldValue.serverTimestamp(),
      });

      return { ...payout, status: MasterclassPayoutStatus.pending, failureReason: null };
    });
  }

  // ==================================================
  // Stuck detection
  // ==================================================

  async findStuckPayoutCandidates(
    stuckThresholdMs: number,
  ): Promise<MasterclassPayout[]> {
    const cutoff = new Date(Date.now() - stuckThresholdMs);

    const snapshot = await this.firestore
      .collection("masterclassPayouts")
      .where("status", "==", MasterclassPayoutStatus.processing)
      .where("providerPayoutId", "==", null)
      .where("updatedAt", "<=", cutoff)
      .get();

    return snapshot.docs.map((doc) =>
      masterclassPayoutFromFirestore(doc.id, doc.data()),
    );
  }

  async markStuck(payoutId: string): Promise<MasterclassPayout> {
    const payoutRef = this.firestore
      .collection("masterclassPayouts")
      .doc(payoutId);

    return this.firestore.runTransaction(async (firestoreTransaction) => {
      const snapshot = await firestoreTransaction.get(payoutRef);

      if (!snapshot.exists) {
        throw new Error("Masterclass payout does not exist.");
      }

      const data = snapshot.data();

      if (!data) {
        throw new Error("Masterclass payout data is missing.");
      }

      const payout = masterclassPayoutFromFirestore(snapshot.id, data);

      if (payout.status === MasterclassPayoutStatus.stuck) {
        return payout;
      }

      if (payout.status !== MasterclassPayoutStatus.processing) {
        throw new Error(
          "Only a processing masterclass payout can be marked stuck.",
        );
      }

      if (payout.providerPayoutId !== null) {
        throw new Error(
          "Masterclass payout has a provider payout ID attached and is not stuck; it is awaiting a provider webhook.",
        );
      }

      firestoreTransaction.update(payoutRef, {
        status: MasterclassPayoutStatus.stuck,
        updatedAt: FieldValue.serverTimestamp(),
      });

      return { ...payout, status: MasterclassPayoutStatus.stuck };
    });
  }

  private validateExpectedProviderPayoutId(
    payout: MasterclassPayout,
    expectedProviderPayoutId: string | undefined,
  ): void {
    if (expectedProviderPayoutId === undefined) {
      return;
    }

    if (payout.providerPayoutId === null) {
      throw new Error(
        "Masterclass payout has no provider payout ID attached yet.",
      );
    }

    if (payout.providerPayoutId !== expectedProviderPayoutId) {
      throw new Error(
        "Provider payout ID does not match the masterclass payout.",
      );
    }
  }

  // ===================================================
  // Resolve Methods
  // ===================================================
  async resolveStuckPayoutAsFailed(
    payoutId: string,
    resolutionNote: string,
  ): Promise<MasterclassPayout> {
    if (!resolutionNote.trim()) {
      throw new Error(
        "Resolution note cannot be empty.",
      );
    }

    const payoutRef = this.firestore
      .collection("masterclassPayouts")
      .doc(payoutId);

    return this.firestore.runTransaction(async (firestoreTransaction) => {
      const snapshot = await firestoreTransaction.get(payoutRef);

      if (!snapshot.exists) {
        throw new Error("Masterclass payout does not exist.");
      }

      const data = snapshot.data();

      if (!data) {
        throw new Error("Masterclass payout data is missing.");
      }

      const payout = masterclassPayoutFromFirestore(snapshot.id, data);

      if (payout.status !== MasterclassPayoutStatus.stuck) {
        throw new Error(
          "Only a stuck masterclass payout can be resolved as failed.",
        );
      }

      const ledgerTransaction = await this.readLedgerTransaction(
        firestoreTransaction,
        payout.id,
      );

      this.validateLedgerTransaction(ledgerTransaction, payout);

      this.markLedgerPendingForRetry(
        firestoreTransaction,
        payout,
        ledgerTransaction,
      );

      const note = resolutionNote.trim();

      firestoreTransaction.update(payoutRef, {
        status: MasterclassPayoutStatus.pending,
        failureReason: `Resolved from stuck: ${note}`,
        updatedAt: FieldValue.serverTimestamp(),
      });

      return {
        ...payout,
        status: MasterclassPayoutStatus.pending,
        failureReason: `Resolved from stuck: ${note}`,
      };
    });
  }

  async resolveStuckPayoutAsSucceeded(
    payoutId: string,
    confirmedProviderPayoutId: string,
  ): Promise<MasterclassPayout> {
    ProviderValidator.validateProviderPayoutId(
      confirmedProviderPayoutId,
    );

    const payoutRef = this.firestore
      .collection("masterclassPayouts")
      .doc(payoutId);

    return this.firestore.runTransaction(async (firestoreTransaction) => {
      const snapshot = await firestoreTransaction.get(payoutRef);

      if (!snapshot.exists) {
        throw new Error("Masterclass payout does not exist.");
      }

      const data = snapshot.data();

      if (!data) {
        throw new Error("Masterclass payout data is missing.");
      }

      const payout = masterclassPayoutFromFirestore(snapshot.id, data);

      if (payout.status !== MasterclassPayoutStatus.stuck) {
        throw new Error(
          "Only a stuck masterclass payout can be resolved as succeeded.",
        );
      }

      if (payout.providerPayoutId !== null) {
        throw new Error(
          "Stuck masterclass payout unexpectedly already has a provider payout ID attached.",
        );
      }

      const identityReadResult =
        await this.payoutProviderIdentity.readClaimInTransaction(
          firestoreTransaction,
          confirmedProviderPayoutId,
        );

      const ledgerTransaction = await this.readLedgerTransaction(
        firestoreTransaction,
        payout.id,
      );

      this.validateLedgerTransaction(ledgerTransaction, payout);

      this.payoutProviderIdentity.commitClaimFromReadResultInTransaction(
        firestoreTransaction,
        { providerPayoutId: confirmedProviderPayoutId, payoutId },
        identityReadResult,
      );

      this.markLedgerSucceeded(
        firestoreTransaction,
        payout,
        ledgerTransaction,
      );

      const completedAt = new Date();

      firestoreTransaction.update(payoutRef, {
        status: MasterclassPayoutStatus.succeeded,
        provider: this.payoutProvider.name,
        providerPayoutId: confirmedProviderPayoutId,
        completedAt,
        updatedAt: FieldValue.serverTimestamp(),
        failureReason: null,
      });

      return {
        ...payout,
        status: MasterclassPayoutStatus.succeeded,
        provider: this.payoutProvider.name,
        providerPayoutId: confirmedProviderPayoutId,
        completedAt,
        failureReason: null,
      };
    });
  }
}
