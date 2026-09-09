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

  async refundPayment({
    refundId,
  }: {
    providerPaymentId: string;
    amountCents: number;
    currency: "ZAR";
    refundId: string;
    bookingId: string;
  }) {
    return {
      providerRefundId: `mock-refund-${refundId}`,
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

    if (
      typeof event.occurredAt !==
      "string"
    ) {
      throw new Error(
        "Webhook occurredAt is required.",
      );
    }

    const occurredAt = new Date(event.occurredAt);

    if (
      Number.isNaN(
        occurredAt.getTime(),
      )
    ) {
      throw new Error(
        "Webhook occurredAt is invalid.",
      );
    }

    return {
      providerPaymentId: event.providerPaymentId,
      bookingId: event.bookingId,
      status: event.status,
      failureReason: event.failureReason ?? null,
      eventId: event.eventId,
      occurredAt: occurredAt,
    };
  }
}

// {
//   provider: "mock",
//   providerRefundId: "mock-refund-refund-1",

//   bookingId: "booking-1",
//   paymentId: "booking-1",
//   refundId: "refund-1",

//   refundPath:
//     "payments/booking-1/refunds/refund-1",

//   createdAt: Timestamp
// }