import { onCall, HttpsError } from "firebase-functions/v2/https";
import { db } from "../../shared/firebase";
import { PayoutService } from "../payout/payout_service";
import { TutorPayoutEligibilityService } from "../payout/tutor_payout_eligibility_service";
import { TwentyPercentPlatformFeeCalculator } from "../payout/platform_fee_calculator";
import { TransactionReferenceIdentity } from "../transactions/transaction_reference_identity";
import { TransactionService } from "../transactions/transaction_service";
import { PayoutTransactionService } from "../transactions/payout_transaction_service";
import { MockPayoutProvider } from "../provider/mock_payout_provider";
import { PayoutProvider } from "../provider/payout_provider";
import { PayoutProviderIdentity } from "../provider/payout_provider_identity";

const payoutProvider: PayoutProvider = new MockPayoutProvider();

const referenceIdentity =
  new TransactionReferenceIdentity(db);

const transactionService =
  new TransactionService(db, referenceIdentity);

const payoutTransactionService =
  new PayoutTransactionService(db, transactionService);

const feeCalculator =
  new TwentyPercentPlatformFeeCalculator();

const eligibilityService =
  new TutorPayoutEligibilityService(feeCalculator);

const payoutProviderIdentity =
  new PayoutProviderIdentity(db, payoutProvider);

const payoutService = new PayoutService(
  db,
  eligibilityService,
  payoutTransactionService,
  payoutProvider,
  payoutProviderIdentity,
);

/*
 * Every callable in this file requires the caller's ID
 * token to carry a custom claim { admin: true }.
 *
 * Set this once, out of band, via the Admin SDK:
 *
 *   await getAuth().setCustomUserClaims(uid, { admin: true });
 *
 * There is currently no UI for this — it must be run as
 * a one-off script against your own Firebase project.
 */
function requireAdmin(
  auth: { token?: Record<string, unknown> } | undefined,
): void {
  if (!auth) {
    throw new HttpsError(
      "unauthenticated",
      "Sign-in required.",
    );
  }

  if (auth.token?.admin !== true) {
    throw new HttpsError(
      "permission-denied",
      "Admin privileges required.",
    );
  }
}

export const resolveStuckPayoutAsFailed = onCall(
  async (request) => {
    requireAdmin(request.auth);

    const { payoutId, resolutionNote } =
      request.data ?? {};

    if (
      typeof payoutId !== "string" ||
      !payoutId.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "payoutId is required.",
      );
    }

    if (
      typeof resolutionNote !== "string" ||
      !resolutionNote.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "resolutionNote is required.",
      );
    }

    try {
      const payout =
        await payoutService
          .resolveStuckPayoutAsFailed(
            payoutId,
            resolutionNote,
          );

      return { payout };
    } catch (error) {
      throw new HttpsError(
        "failed-precondition",
        error instanceof Error
          ? error.message
          : "Failed to resolve stuck payout.",
      );
    }
  },
);

export const resolveStuckPayoutAsSucceeded = onCall(
  async (request) => {
    requireAdmin(request.auth);

    const {
      payoutId,
      confirmedProviderPayoutId,
    } = request.data ?? {};

    if (
      typeof payoutId !== "string" ||
      !payoutId.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "payoutId is required.",
      );
    }

    if (
      typeof confirmedProviderPayoutId !==
        "string" ||
      !confirmedProviderPayoutId.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "confirmedProviderPayoutId is required.",
      );
    }

    try {
      const payout =
        await payoutService
          .resolveStuckPayoutAsSucceeded(
            payoutId,
            confirmedProviderPayoutId,
          );

      return { payout };
    } catch (error) {
      throw new HttpsError(
        "failed-precondition",
        error instanceof Error
          ? error.message
          : "Failed to resolve stuck payout.",
      );
    }
  },
);

/*
 * Read-only: lists current stuck-payout candidates so an
 * operator can decide which of the two resolve functions
 * to call, and with what confirmedProviderPayoutId. This
 * does NOT mutate anything (it does not call markStuck) —
 * it mirrors what payoutStuckSweep would find, for manual
 * visibility between sweep runs.
 */
export const listStuckPayoutCandidates = onCall(
  async (request) => {
    requireAdmin(request.auth);

    const thresholdMs =
      typeof request.data?.thresholdMs ===
      "number"
        ? request.data.thresholdMs
        : 30 * 60 * 1000;

    const candidates =
      await payoutService
        .findStuckPayoutCandidates(
          thresholdMs,
        );

    return { candidates };
  },
);
