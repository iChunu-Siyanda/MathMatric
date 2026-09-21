import { onCall, HttpsError } from "firebase-functions/v2/https";
import { db } from "../../../shared/firebase";
import { MasterclassPaymentService } from "./masterclass_payment_service";
import { MasterclassPaymentSuccessService } from "./masterclass_payment_success_service";
import { TransactionReferenceIdentity } from "../../transactions/transaction_reference_identity";
import { TransactionService } from "../../transactions/transaction_service";
import { MockPaymentProvider } from "../../provider/mock_payment_provider";
import { PaymentProvider } from "../../provider/payment_provider";

const paymentProvider: PaymentProvider = new MockPaymentProvider();

const masterclassPaymentService =
  new MasterclassPaymentService(db, paymentProvider);

const referenceIdentity =
  new TransactionReferenceIdentity(db);

const transactionService =
  new TransactionService(db, referenceIdentity);

const masterclassPaymentSuccessService =
  new MasterclassPaymentSuccessService(
    db,
    transactionService,
  );

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

export const resolveMasterclassPaymentAsFailed = onCall(
  async (request) => {
    requireAdmin(request.auth);

    const { enrollmentId, resolutionNote } =
      request.data ?? {};

    if (
      typeof enrollmentId !== "string" ||
      !enrollmentId.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "enrollmentId is required.",
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
      await masterclassPaymentService
        .resolvePaymentAsFailed(
          enrollmentId,
          resolutionNote,
        );

      return { resolved: true };
    } catch (error) {
      throw new HttpsError(
        "failed-precondition",
        error instanceof Error
          ? error.message
          : "Failed to resolve stuck masterclass payment.",
      );
    }
  },
);

export const resolveMasterclassPaymentAsPaid = onCall(
  async (request) => {
    requireAdmin(request.auth);

    const {
      enrollmentId,
      providerPaymentId,
      paidAt,
    } = request.data ?? {};

    if (
      typeof enrollmentId !== "string" ||
      !enrollmentId.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "enrollmentId is required.",
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
      Number.isNaN(resolvedPaidAt.getTime())
    ) {
      throw new HttpsError(
        "invalid-argument",
        "paidAt is invalid.",
      );
    }

    try {
      const payment =
        await masterclassPaymentSuccessService
          .markPaymentPaid({
            enrollmentId,
            providerPaymentId,
            paidAt: resolvedPaidAt,
          });

      return { payment };
    } catch (error) {
      throw new HttpsError(
        "failed-precondition",
        error instanceof Error
          ? error.message
          : "Failed to resolve stuck masterclass payment.",
      );
    }
  },
);

export const listStuckMasterclassPaymentCandidates = onCall(
  async (request) => {
    requireAdmin(request.auth);

    const thresholdMs =
      typeof request.data?.thresholdMs ===
      "number"
        ? request.data.thresholdMs
        : 10 * 60 * 1000;

    const candidates =
      await masterclassPaymentService
        .findStuckPaymentCandidates(
          thresholdMs,
        );

    return { candidates };
  },
);
