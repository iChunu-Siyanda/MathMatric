import { onCall, HttpsError } from "firebase-functions/v2/https";
import { db } from "../../shared/firebase";
import { PaymentService } from "../payment/payment_service";
import { PaymentSuccessService } from "../payment/payment_success_service";
import { TransactionReferenceIdentity } from "../transactions/transaction_reference_identity";
import { TransactionService } from "../transactions/transaction_service";
import { MockPaymentProvider } from "../provider/mock_payment_provider";
import { PaymentProvider } from "../provider/payment_provider";

const paymentProvider: PaymentProvider = new MockPaymentProvider();

const paymentService = new PaymentService(db, paymentProvider);

const referenceIdentity =
  new TransactionReferenceIdentity(db);

const transactionService =
  new TransactionService(db, referenceIdentity);

const paymentSuccessService =
  new PaymentSuccessService(
    db,
    transactionService,
  );

/*
 * Same admin gate as payout_admin_actions.ts.
 * Requires the caller's ID token to carry
 * { admin: true }. See that file for how the
 * claim is set.
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

export const resolvePaymentAsFailed = onCall(
  async (request) => {
    requireAdmin(request.auth);

    const { bookingId, resolutionNote } =
      request.data ?? {};

    if (
      typeof bookingId !== "string" ||
      !bookingId.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "bookingId is required.",
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
      await paymentService
        .resolvePaymentAsFailed(
          bookingId,
          resolutionNote,
        );

      return { resolved: true };
    } catch (error) {
      throw new HttpsError(
        "failed-precondition",
        error instanceof Error
          ? error.message
          : "Failed to resolve stuck payment.",
      );
    }
  },
);

/*
 * Operator confirmed (via provider dashboard/
 * support) that the student's charge DID actually
 * go through, despite our system never receiving
 * the webhook. Reuses the same markPaymentPaid path
 * a real webhook would take — providerPaymentId is
 * already stored on the payment (set during
 * createPayment's checkout phase), so the operator
 * only needs to confirm the paidAt time.
 */
export const resolvePaymentAsPaid = onCall(
  async (request) => {
    requireAdmin(request.auth);

    const { bookingId, providerPaymentId, paidAt } =
      request.data ?? {};

    if (
      typeof bookingId !== "string" ||
      !bookingId.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "bookingId is required.",
      );
    }

    if (
      typeof providerPaymentId !== "string" ||
      !providerPaymentId.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "providerPaymentId is required.",
      );
    }

    const resolvedPaidAt =
      typeof paidAt === "string"
        ? new Date(paidAt)
        : new Date();

    if (
      Number.isNaN(
        resolvedPaidAt.getTime(),
      )
    ) {
      throw new HttpsError(
        "invalid-argument",
        "paidAt is invalid.",
      );
    }

    try {
      const payment =
        await paymentSuccessService
          .markPaymentPaid({
            bookingId,
            providerPaymentId,
            paidAt: resolvedPaidAt,
          });

      return { payment };
    } catch (error) {
      throw new HttpsError(
        "failed-precondition",
        error instanceof Error
          ? error.message
          : "Failed to resolve stuck payment.",
      );
    }
  },
);

/*
 * Read-only: lists current stuck-payment candidates.
 * Does NOT mutate anything (does not call markStuck).
 */
export const listStuckPaymentCandidates = onCall(
  async (request) => {
    requireAdmin(request.auth);

    const thresholdMs =
      typeof request.data?.thresholdMs ===
      "number"
        ? request.data.thresholdMs
        : 30 * 60 * 1000;

    const candidates =
      await paymentService
        .findStuckPaymentCandidates(
          thresholdMs,
        );

    return { candidates };
  },
);
