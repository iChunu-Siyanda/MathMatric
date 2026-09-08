import { HttpsError, onCall } from "firebase-functions/v2/https";
import { db } from "../../shared/firebase";
import { getStudentAccount } from "../../students/student_account_service";
import { PaymentService } from "./payment_service";
import { MockPaymentProvider } from "./mock_payment_provider";

const paymentService = new PaymentService(db, new MockPaymentProvider());

export const initiatePayment = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "Authentication is required.",
    );
  }

  const { bookingId } = request.data ?? {};

  if (
    typeof bookingId !== "string" ||
    bookingId.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "bookingId is required.",
    );
  }

  const studentId = request.auth.uid;

  await getStudentAccount(studentId);

  try {
    const checkout =await paymentService.createPayment({
      bookingId,
      studentId,
    });

    return {
      success: true,
      payment: checkout.payment,
      checkout: {
        provider: checkout.provider,
        providerPaymentId: checkout.providerPaymentId,
        checkoutUrl: checkout.checkoutUrl,
      },
    };
  } catch (error) {
    if (error instanceof HttpsError) {
      throw error;
    }

    console.error(
      "Failed to initiate payment.",
      error,
    );

    throw new HttpsError(
      "failed-precondition",
      error instanceof Error
        ? error.message
        : "Unable to initiate payment.",
    );
  }
});
