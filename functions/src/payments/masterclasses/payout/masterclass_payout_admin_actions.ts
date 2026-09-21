import { onCall, HttpsError } from "firebase-functions/v2/https";
import { db } from "../../../shared/firebase";
import { MasterclassPayoutService } from "./masterclass_payout_service";
import { MasterclassPayoutEligibilityService } from "./masterclass_payout_eligibility_service";
import { TwentyPercentPlatformFeeCalculator } from "../../payout/platform_fee_calculator";
import { TransactionReferenceIdentity } from "../../transactions/transaction_reference_identity";
import { TransactionService } from "../../transactions/transaction_service";
import { MockPayoutProvider } from "../../provider/mock_payout_provider";
import { PayoutProvider } from "../../provider/payout_provider";
import { PayoutProviderIdentity } from "../../provider/payout_provider_identity";

const payoutProvider: PayoutProvider = new MockPayoutProvider();

const referenceIdentity =
  new TransactionReferenceIdentity(db);

const transactionService =
  new TransactionService(db, referenceIdentity);

const feeCalculator =
  new TwentyPercentPlatformFeeCalculator();

const eligibilityService =
  new MasterclassPayoutEligibilityService(feeCalculator);

const payoutProviderIdentity =
  new PayoutProviderIdentity(db, payoutProvider);

const masterclassPayoutService = new MasterclassPayoutService(
  db,
  eligibilityService,
  transactionService,
  payoutProvider,
  payoutProviderIdentity,
);

/*
 * Same admin gate as payout_admin_actions.ts and
 * payment_admin_actions.ts.
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

export const resolveMasterclassStuckPayoutAsFailed = onCall(
  async (request) => {
    requireAdmin(request.auth);

    const { payoutId, resolutionNote } = request.data ?? {};

    if (typeof payoutId !== "string" || !payoutId.trim()) {
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
        await masterclassPayoutService.resolveStuckPayoutAsFailed(
          payoutId,
          resolutionNote,
        );

      return { payout };
    } catch (error) {
      throw new HttpsError(
        "failed-precondition",
        error instanceof Error
          ? error.message
          : "Failed to resolve stuck masterclass payout.",
      );
    }
  },
);

export const resolveMasterclassStuckPayoutAsSucceeded = onCall(
  async (request) => {
    requireAdmin(request.auth);

    const { payoutId, confirmedProviderPayoutId } =
      request.data ?? {};

    if (typeof payoutId !== "string" || !payoutId.trim()) {
      throw new HttpsError(
        "invalid-argument",
        "payoutId is required.",
      );
    }

    if (
      typeof confirmedProviderPayoutId !== "string" ||
      !confirmedProviderPayoutId.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "confirmedProviderPayoutId is required.",
      );
    }

    try {
      const payout =
        await masterclassPayoutService.resolveStuckPayoutAsSucceeded(
          payoutId,
          confirmedProviderPayoutId,
        );

      return { payout };
    } catch (error) {
      throw new HttpsError(
        "failed-precondition",
        error instanceof Error
          ? error.message
          : "Failed to resolve stuck masterclass payout.",
      );
    }
  },
);

export const listStuckMasterclassPayoutCandidates = onCall(
  async (request) => {
    requireAdmin(request.auth);

    const thresholdMs =
      typeof request.data?.thresholdMs === "number"
        ? request.data.thresholdMs
        : 30 * 60 * 1000;

    const candidates =
      await masterclassPayoutService.findStuckPayoutCandidates(
        thresholdMs,
      );

    return { candidates };
  },
);
