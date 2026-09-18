import {FieldValue,Firestore,} from "firebase-admin/firestore";
import {Payment,} from "../payment/payment_entity";
import {TutorPayout,PayoutStatus,} from "./payout_entity";
import {TutorPayoutEligibilityService,PayoutEligibilityBooking,} from "./tutor_payout_eligibility_service";
import { PayoutTransactionService } from "../transactions/payout_transaction_service";
import { payoutFromFirestore } from "./payout_mapper";
import { PayoutProvider, PayoutProviderOutcomeUnknownError,} from "../provider/payout_provider";
import { ProviderValidator } from "../provider/provider_validator";
import { PayoutProviderIdentity } from "../provider/payout_provider_identity";

export interface CreatePayoutResult {
  payout: TutorPayout;
  created: boolean;
}

export class PayoutService {
  constructor(
    private readonly firestore: Firestore,
    private readonly eligibilityService: TutorPayoutEligibilityService,
    private readonly payoutTransactionService: PayoutTransactionService,
    private readonly payoutProvider: PayoutProvider,
    private readonly payoutProviderIdentity: PayoutProviderIdentity,
  ) {}

  async createPayout({
    booking,
    payment,
  }: {
    booking: PayoutEligibilityBooking;
    payment: Payment;
  }): Promise<CreatePayoutResult> {
    const eligibility =
      this.eligibilityService.evaluate({
        booking,
        payment,
      });

    if (!eligibility.eligible) {
      throw new Error(
        eligibility.reason ??
          "Booking is not eligible for payout.",
      );
    }

    const payoutId = `payout-${booking.id}`;

    return this.firestore.runTransaction(
      async (firestoreTransaction) => {
        const payoutRef =
          this.firestore
            .collection("tutorPayouts")
            .doc(payoutId);

        /*
         * All reads must happen before writes.
         */
        const payoutSnapshot =
          await firestoreTransaction.get(
            payoutRef,
          );

        /*
         * If the payout already exists,
         * validate it and return it idempotently.
         */
        if (payoutSnapshot.exists) {
          const data =
            payoutSnapshot.data();

          if (!data) {
            throw new Error(
              "Payout data is missing.",
            );
          }

          const existingPayout =
            payoutFromFirestore(
              payoutSnapshot.id,
              data,
            );

          this.validateExistingPayout({
            payout: existingPayout,
            booking,
            payment,
            expectedAmountCents: eligibility.payoutAmountCents,
          });

          return {
            payout: existingPayout,
            created: false,
          };
        }

        const now = new Date();

        const payout: TutorPayout = {
          id: payoutId,
          bookingId: booking.id,
          paymentId: payment.id,
          tutorId: booking.tutorId,

          amountCents: eligibility.payoutAmountCents,
          currency: "ZAR",
          status: PayoutStatus.pending,

          provider: null,
          providerPayoutId: null,

          createdAt: now,
          updatedAt: now,
          completedAt: null,

          failureReason: null,
        };
        
        // Transaction read before any writes happen.
        const transactionReadResult =
          await this.payoutTransactionService
            .readForPayoutInTransaction(
              firestoreTransaction,
              payout,
              booking,
              payment,
            );

        /*
         * Create the payout.
         */
        firestoreTransaction.create(
          payoutRef,
          {
            bookingId: payout.bookingId,
            paymentId: payout.paymentId,
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
          },
        );

        /*
         * Create the corresponding pending
         * payout ledger transaction using
         * the SAME Firestore transaction.
         */
        this.payoutTransactionService.createFromReadResultForPayoutInTransaction(
          firestoreTransaction,
          payout,
          booking,
          payment,
          transactionReadResult,
        );

        return {
          payout,
          created: true,
        };
      },
    );
  }

  async markProcessing(
    payoutId: string,
    expectedProviderPayoutId?: string,
  ): Promise<TutorPayout> {
    const payoutRef =
      this.firestore
        .collection("tutorPayouts")
        .doc(payoutId);

    return this.firestore.runTransaction(
      async (firestoreTransaction) => {
        const snapshot =
          await firestoreTransaction.get(
            payoutRef,
          );

        if (!snapshot.exists) {
          throw new Error(
            "Payout does not exist.",
          );
        }

        const data =
          snapshot.data();

        if (!data) {
          throw new Error(
            "Payout data is missing.",
          );
        }

        const payout =
          payoutFromFirestore(
            snapshot.id,
            data,
          );

        this.validateExpectedProviderPayoutId(
          payout,
          expectedProviderPayoutId,
        );

        /*
         * Idempotent.
         */
        if (
          payout.status ===
          PayoutStatus.processing
        ) {
          return payout;
        }

        if (
          payout.status !==
          PayoutStatus.pending
        ) {
          throw new Error(
            "Only a pending payout can be moved to processing.",
          );
        }

        firestoreTransaction.update(
          payoutRef,
          {
            status: PayoutStatus.processing,
            updatedAt: FieldValue.serverTimestamp(),
          },
        );

        return {
          ...payout,
          status: PayoutStatus.processing,
        };
      },
    );
  }

  async markSucceeded(
    payoutId: string,
    expectedProviderPayoutId?: string,
  ): Promise<TutorPayout> {
    const payoutRef = this.firestore
        .collection("tutorPayouts")
        .doc(payoutId);

    return this.firestore.runTransaction(
      async (firestoreTransaction) => {
        /*
         * Read payout first.
         */
        const payoutSnapshot = await firestoreTransaction.get(
            payoutRef,
          );

        if (!payoutSnapshot.exists) {
          throw new Error(
            "Payout does not exist.",
          );
        }

        const data =
          payoutSnapshot.data();

        if (!data) {
          throw new Error(
            "Payout data is missing.",
          );
        }

        const payout =
          payoutFromFirestore(
            payoutSnapshot.id,
            data,
          );

        this.validateExpectedProviderPayoutId(
          payout,
          expectedProviderPayoutId,
        );

        /*
         * Idempotent.
         */
        if (
          payout.status ===
          PayoutStatus.succeeded
        ) {
          return payout;
        }

        if (
          payout.status !==
          PayoutStatus.processing
        ) {
          throw new Error(
            "Only a processing payout can succeed.",
          );
        }

        /*
         * The payout transaction must also be
         * completed atomically with the payout.
         */
        await this.payoutTransactionService
          .markSucceededInTransaction(
            firestoreTransaction,
            payout,
          );

        const completedAt = new Date();

        firestoreTransaction.update(
          payoutRef,
          {
            status: PayoutStatus.succeeded,
            completedAt,
            updatedAt: FieldValue.serverTimestamp(),
            failureReason: null,
          },
        );

        return {
          ...payout,
          status: PayoutStatus.succeeded,
          completedAt,
          failureReason: null,
        };
      },
    );
  }

  async markFailed(
    payoutId: string,
    failureReason: string,
    expectedProviderPayoutId?: string,
  ): Promise<TutorPayout> {
    if (!failureReason.trim()) {
      throw new Error(
        "Failure reason cannot be empty.",
      );
    }

    const payoutRef =
      this.firestore
        .collection("tutorPayouts")
        .doc(payoutId);

    return this.firestore.runTransaction(
      async (firestoreTransaction) => {
        /*
         * Read payout first.
         */
        const payoutSnapshot =
          await firestoreTransaction.get(
            payoutRef,
          );

        if (!payoutSnapshot.exists) {
          throw new Error(
            "Payout does not exist.",
          );
        }

        const data = payoutSnapshot.data();

        if (!data) {
          throw new Error(
            "Payout data is missing.",
          );
        }

        const payout =
          payoutFromFirestore(
            payoutSnapshot.id,
            data,
          );

        this.validateExpectedProviderPayoutId(
          payout,
          expectedProviderPayoutId,
        );

        /*
         * Idempotent.
         */
        if (
          payout.status ===
          PayoutStatus.failed
        ) {
          return payout;
        }

        if (
          payout.status !== PayoutStatus.pending &&
          payout.status !== PayoutStatus.processing
        ) {
          throw new Error(
            "Only a pending or processing payout can fail.",
          );
        }

        /*
         * Fail the ledger transaction in the
         * SAME Firestore transaction.
         */
        await this.payoutTransactionService
          .markFailedInTransaction(
            firestoreTransaction,
            payout,
          );

        const reason = failureReason.trim();

        firestoreTransaction.update(
          payoutRef,
          {
            status: PayoutStatus.failed,
            failureReason: reason,
            updatedAt: FieldValue.serverTimestamp(),
          },
        );

        return {
          ...payout,
          status: PayoutStatus.failed,
          failureReason: reason,
        };
      },
    );
  }

  async attachProviderPayoutId(
    payoutId: string,
    providerPayoutId: string,
  ): Promise<void> {
    ProviderValidator.validateProviderPayoutId(providerPayoutId,);

    const payoutRef = this.firestore
      .collection("tutorPayouts")
      .doc(payoutId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const snapshot = await transaction.get(payoutRef);

        if (!snapshot.exists) {
          throw new Error(
            "Payout does not exist.",
          );
        }

        const data = snapshot.data();

        if (!data) {
          throw new Error(
            "Payout data is missing.",
          );
        }

        const existingProvider = data.provider ?? null;

        const existingProviderPayoutId = data.providerPayoutId ?? null;

        if (
          existingProviderPayoutId !== null
        ) {
          if (
            existingProviderPayoutId ===
            providerPayoutId
          ) {
            return;
          }

          throw new Error(
            "Payout is already associated with a different provider payout ID.",
          );
        }

        if (
          existingProvider !== null &&
          existingProvider !==
            this.payoutProvider.name
        ) {
          throw new Error(
            "Payout is already associated with a different provider.",
          );
        }

        await this.payoutProviderIdentity
          .claimInTransaction(
            transaction,
            {
              providerPayoutId,
              payoutId,
            },
          );

        transaction.update(payoutRef, {
          provider: this.payoutProvider.name,
          providerPayoutId,
          updatedAt: FieldValue.serverTimestamp(),
        });
      },
    );
  }

  async initiatePayout(
    payoutId: string,
  ): Promise<TutorPayout> {
    const payoutRef = this.firestore
      .collection("tutorPayouts")
      .doc(payoutId);

    const payoutSnapshot =
      await payoutRef.get();

    if (!payoutSnapshot.exists) {
      throw new Error(
        "Payout does not exist.",
      );
    }

    const payoutData =
      payoutSnapshot.data();

    if (!payoutData) {
      throw new Error(
        "Payout data is missing.",
      );
    }

    const payout =
      payoutFromFirestore(
        payoutSnapshot.id,
        payoutData,
      );

    if (
      payout.providerPayoutId !== null
    ) {
      return payout;
    }

    if (
      payout.status ===
      PayoutStatus.succeeded
    ) {
      return payout;
    }

    if (
      payout.status !==
      PayoutStatus.pending
    ) {
      throw new Error(
        "Only pending payouts can be initiated.",
      );
    }

    await this.markProcessing(
      payoutId,
    );

    try {
      const result =
        await this.payoutProvider.createPayout({
          amountCents:
            payout.amountCents,
          currency:
            payout.currency,
          payoutId:
            payout.id,
          tutorId:
            payout.tutorId,
        });

      ProviderValidator
        .validateProviderPayoutId(
          result.providerPayoutId,
        );

      await this.attachProviderPayoutId(
        payout.id,
        result.providerPayoutId,
      );

      const updatedSnapshot =
        await payoutRef.get();

      if (!updatedSnapshot.exists) {
        throw new Error(
          "Payout disappeared after provider initiation.",
        );
      }

      const updatedData =
        updatedSnapshot.data();

      if (!updatedData) {
        throw new Error(
          "Payout data is missing after provider initiation.",
        );
      }

      return payoutFromFirestore(
        updatedSnapshot.id,
        updatedData,
      );
    } catch (error) {
      if (
        error instanceof PayoutProviderOutcomeUnknownError
      ) {
        /*
         * The provider call's outcome is unknown (timeout,
         * network failure, ambiguous response). The provider
         * may have accepted the payout despite us not
         * receiving a confirmed response, so we must NOT mark
         * this failed — doing so could cause a duplicate real
         * transfer via retryPayout().
         *
         * The payout stays "processing" with no
         * providerPayoutId attached. It resolves either via
         * the eventual provider webhook (which attaches the
         * provider payout ID itself) or via manual
         * reconciliation.
         */
        throw error;
      }

      await this.markFailed(
        payout.id,
        error instanceof Error
          ? error.message
          : "Payout provider initiation failed.",
      );

      throw error;
    }
  }

  async retryPayout(
    payoutId: string,
  ): Promise<TutorPayout> {
    const payoutRef = this.firestore
      .collection("tutorPayouts")
      .doc(payoutId);

    return this.firestore.runTransaction(
      async (firestoreTransaction) => {
        /*
        * READ payout.
        */
        const payoutSnapshot =
          await firestoreTransaction.get(
            payoutRef,
          );

        if (!payoutSnapshot.exists) {
          throw new Error(
            "Payout does not exist.",
          );
        }

        const data = payoutSnapshot.data();

        if (!data) {
          throw new Error(
            "Payout data is missing.",
          );
        }

        const payout =
          payoutFromFirestore(
            payoutSnapshot.id,
            data,
          );

        /*
        * Idempotent: already reset, or never attempted.
        */
        if (
          payout.status ===
          PayoutStatus.pending
        ) {
          return payout;
        }

        /*
        * Idempotent: nothing to retry.
        */
        if (
          payout.status ===
          PayoutStatus.succeeded
        ) {
          return payout;
        }

        if (
          payout.status ===
          PayoutStatus.processing
        ) {
          throw new Error(
            "Cannot retry a payout that is currently processing.",
          );
        }

        if (
          payout.status ===
          PayoutStatus.cancelled
        ) {
          throw new Error(
            "Cancelled payouts cannot be retried.",
          );
        }

        /*
        * Only PayoutStatus.failed reaches here.
        *
        * If a provider payout ID is already attached, the
        * provider may have accepted the payout before failure
        * was recorded. Provider + providerPayoutId identity is
        * immutable, so we must not discard it and attempt a new
        * provider payout blindly. This requires reconciliation,
        * not a blind retry.
        */
        if (
          payout.providerPayoutId !== null
        ) {
          throw new Error(
            "Payout already has a provider payout ID attached and cannot be retried automatically. Resolve via reconciliation.",
          );
        }

        /*
        * READ done (getTransaction inside this call reads
        * before any writes below).
        */
        await this.payoutTransactionService
          .markPendingForRetryInTransaction(
            firestoreTransaction,
            payout,
          );

        /*
        * WRITE.
        */
        firestoreTransaction.update(
          payoutRef,
          {
            status: PayoutStatus.pending,
            failureReason: null,
            updatedAt: FieldValue.serverTimestamp(),
          },
        );

        return {
          ...payout,
          status: PayoutStatus.pending,
          failureReason: null,
        };
      },
    );
  }

  async findStuckPayoutCandidates(
    stuckThresholdMs: number,
  ): Promise<TutorPayout[]> {
    const cutoff = new Date(
      Date.now() - stuckThresholdMs,
    );

    const snapshot = await this.firestore
      .collection("tutorPayouts")
      .where("status","==",PayoutStatus.processing,)
      .where("providerPayoutId","==",null,)
      .where("updatedAt","<=",cutoff,)
      .get();

    return snapshot.docs.map((doc) =>
      payoutFromFirestore(
        doc.id,
        doc.data(),
      ),
    );
  }

  async markStuck(
    payoutId: string,
  ): Promise<TutorPayout> {
    const payoutRef = this.firestore
      .collection("tutorPayouts")
      .doc(payoutId);

    return this.firestore.runTransaction(
      async (firestoreTransaction) => {
        const snapshot =
          await firestoreTransaction.get(
            payoutRef,
          );

        if (!snapshot.exists) {
          throw new Error(
            "Payout does not exist.",
          );
        }

        const data = snapshot.data();

        if (!data) {
          throw new Error(
            "Payout data is missing.",
          );
        }

        const payout =
          payoutFromFirestore(
            snapshot.id,
            data,
          );

        /*
         * Idempotent.
         */
        if (
          payout.status ===
          PayoutStatus.stuck
        ) {
          return payout;
        }

        if (
          payout.status !==
          PayoutStatus.processing
        ) {
          throw new Error(
            "Only a processing payout can be marked stuck.",
          );
        }

        if (
          payout.providerPayoutId !== null
        ) {
          throw new Error(
            "Payout has a provider payout ID attached and is not stuck; it is awaiting a provider webhook.",
          );
        }

        firestoreTransaction.update(
          payoutRef,
          {
            status: PayoutStatus.stuck,
            updatedAt: FieldValue.serverTimestamp(),
          },
        );

        return {
          ...payout,
          status: PayoutStatus.stuck,
        };
      },
    );
  }

  /*
   * Operator confirmed (via provider dashboard/support)
   * that the provider never received or accepted this
   * payout. Resets it to pending so it can go through
   * the normal initiatePayout() flow again.
   */
  async resolveStuckPayoutAsFailed(
    payoutId: string,
    resolutionNote: string,
  ): Promise<TutorPayout> {
    if (!resolutionNote.trim()) {
      throw new Error("Resolution note cannot be empty.",);
    }

    const payoutRef = this.firestore
      .collection("tutorPayouts")
      .doc(payoutId);

    return this.firestore.runTransaction(
      async (firestoreTransaction) => {
        const snapshot =
          await firestoreTransaction.get(
            payoutRef,
          );

        if (!snapshot.exists) {
          throw new Error(
            "Payout does not exist.",
          );
        }

        const data = snapshot.data();

        if (!data) {
          throw new Error(
            "Payout data is missing.",
          );
        }

        const payout =
          payoutFromFirestore(
            snapshot.id,
            data,
          );

        if (
          payout.status !==
          PayoutStatus.stuck
        ) {
          throw new Error(
            "Only a stuck payout can be resolved as failed.",
          );
        }

        await this.payoutTransactionService
          .markPendingForRetryInTransaction(
            firestoreTransaction,
            payout,
          );

        const note = resolutionNote.trim();

        firestoreTransaction.update(
          payoutRef,
          {
            status: PayoutStatus.pending,
            failureReason: `Resolved from stuck: ${note}`,
            updatedAt: FieldValue.serverTimestamp(),
          },
        );

        return {
          ...payout,
          status: PayoutStatus.pending,
          failureReason: `Resolved from stuck: ${note}`,
        };
      },
    );
  }

  /*
   * Operator confirmed (via provider dashboard/support)
   * that the provider DID accept and complete the
   * payout, despite our system never receiving
   * confirmation. Attaches the real provider payout ID
   * and marks succeeded directly.
   */
  async resolveStuckPayoutAsSucceeded(
    payoutId: string,
    confirmedProviderPayoutId: string,
  ): Promise<TutorPayout> {
    ProviderValidator.validateProviderPayoutId(
      confirmedProviderPayoutId,
    );

    const payoutRef = this.firestore
      .collection("tutorPayouts")
      .doc(payoutId);

    return this.firestore.runTransaction(
      async (firestoreTransaction) => {
        const snapshot =
          await firestoreTransaction.get(
            payoutRef,
          );

        if (!snapshot.exists) {
          throw new Error(
            "Payout does not exist.",
          );
        }

        const data = snapshot.data();

        if (!data) {
          throw new Error(
            "Payout data is missing.",
          );
        }

        const payout =
          payoutFromFirestore(
            snapshot.id,
            data,
          );

        if (
          payout.status !==
          PayoutStatus.stuck
        ) {
          throw new Error(
            "Only a stuck payout can be resolved as succeeded.",
          );
        }

        if (
          payout.providerPayoutId !== null
        ) {
          throw new Error(
            "Stuck payout unexpectedly already has a provider payout ID attached.",
          );
        }

        await this.payoutProviderIdentity
          .claimInTransaction(
            firestoreTransaction,
            {
              providerPayoutId:
                confirmedProviderPayoutId,
              payoutId,
            },
          );

        await this.payoutTransactionService
          .markSucceededInTransaction(
            firestoreTransaction,
            {
              ...payout,
              providerPayoutId:
                confirmedProviderPayoutId,
            },
          );

        const completedAt = new Date();

        firestoreTransaction.update(
          payoutRef,
          {
            status: PayoutStatus.succeeded,
            provider:
              this.payoutProvider.name,
            providerPayoutId:
              confirmedProviderPayoutId,
            completedAt,
            updatedAt:
              FieldValue.serverTimestamp(),
            failureReason: null,
          },
        );

        return {
          ...payout,
          status: PayoutStatus.succeeded,
          provider:
            this.payoutProvider.name,
          providerPayoutId:
            confirmedProviderPayoutId,
          completedAt,
          failureReason: null,
        };
      },
    );
  }

  private validateExistingPayout({
    payout,
    booking,
    payment,
    expectedAmountCents,
  }: {
    payout: TutorPayout;
    booking: PayoutEligibilityBooking;
    payment: Payment;
    expectedAmountCents: number;
  }): void {
    if (
      payout.bookingId !==
      booking.id
    ) {
      throw new Error(
        "Existing payout belongs to a different booking.",
      );
    }

    if (
      payout.paymentId !==
      payment.id
    ) {
      throw new Error(
        "Existing payout belongs to a different payment.",
      );
    }

    if (
      payout.tutorId !==
      booking.tutorId
    ) {
      throw new Error(
        "Existing payout belongs to a different tutor.",
      );
    }

    if (
      payout.amountCents !==
      expectedAmountCents
    ) {
      throw new Error(
        "Existing payout amount does not match the eligible payout amount.",
      );
    }

    if (
      payout.currency !== "ZAR"
    ) {
      throw new Error(
        "Existing payout has an invalid currency.",
      );
    }
  }

  private validateExpectedProviderPayoutId(
    payout: TutorPayout,
    expectedProviderPayoutId: string | undefined,
  ): void {
    /*
     * Internal callers (e.g. initiatePayout, before the
     * provider has been contacted) omit this and skip
     * the check entirely.
     */
    if (expectedProviderPayoutId === undefined) {
      return;
    }

    if (payout.providerPayoutId === null) {
      throw new Error(
        "Payout has no provider payout ID attached yet.",
      );
    }

    if (
      payout.providerPayoutId !==
      expectedProviderPayoutId
    ) {
      throw new Error(
        "Provider payout ID does not match the payout.",
      );
    }
  }
}
