import {
  PaymentProvider,
  PaymentWebhookEvent,
} from "./payment_provider";

export class MockPaymentProvider
  implements PaymentProvider
{
  readonly name = "mock";

  async createPayment({
    bookingId,
  }: {
    amountCents: number;
    currency: "ZAR";
    bookingId: string;
    studentId: string;
  }) {
    return {
      providerPaymentId: `mock-${bookingId}`,
      checkoutUrl: `https://example.com/pay/${bookingId}`,
    };
  }

  verifyWebhook(
    payload: string,
    signature: string,
  ): PaymentWebhookEvent {
    if (signature !== "test-signature") {
      throw new Error("Invalid webhook signature.");
    }

    const event = JSON.parse(payload);

    return {
      providerPaymentId: event.providerPaymentId,
      bookingId: event.bookingId,
      status: event.status,
      failureReason: event.failureReason ?? null,
      eventId: event.eventId,
    };
  }
}
