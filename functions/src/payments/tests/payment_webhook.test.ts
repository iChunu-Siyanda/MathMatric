import {
  beforeEach,
  describe,
  expect,
  it,
  vi,
} from "vitest";

const {
  verifyWebhook,
  markProcessing,
  markPaidFromProvider,
  markFailed,
  startProcessing,
  markProcessed,
  markWebhookFailed,
} = vi.hoisted(() => ({
  verifyWebhook: vi.fn(),
  markProcessing: vi.fn(),
  markPaidFromProvider: vi.fn(),
  markFailed: vi.fn(),

  startProcessing: vi.fn(),
  markProcessed: vi.fn(),
  markWebhookFailed: vi.fn(),
}));

vi.mock("./mock_payment_provider", () => ({
  MockPaymentProvider: class {
    readonly name = "mock";

    createPayment = vi.fn();

    verifyWebhook = verifyWebhook;
  },
}));

vi.mock("./payment_service", () => ({
  PaymentService: class {
    markProcessing = markProcessing;
    markPaidFromProvider = markPaidFromProvider;
    markFailed = markFailed;
  },
}));

vi.mock("./webhook_event_service", () => ({
  WebhookEventService: class {
    startProcessing = startProcessing;
    markProcessed = markProcessed;
    markFailed = markWebhookFailed;
  },
}));

vi.mock("../shared/firebase", () => ({
  db: {},
}));

import { paymentWebhook } from "../webhooks/payment_webhook";

describe("paymentWebhook", () => {
  const event = {
    eventId: "event-123",
    bookingId: "booking-123",
    providerPaymentId: "mock-booking-123",
    status: "paid" as const,
    failureReason: null,
  };

  let request: any;
  let response: any;

  beforeEach(() => {
    vi.clearAllMocks();

    verifyWebhook.mockReturnValue(event);

    startProcessing.mockResolvedValue(true);
    markProcessing.mockResolvedValue(undefined);
    markPaidFromProvider.mockResolvedValue(undefined);
    markFailed.mockResolvedValue(undefined);
    markProcessed.mockResolvedValue(undefined);
    markWebhookFailed.mockResolvedValue(undefined);

    request = {
      method: "POST",
      headers: {
        "x-payment-signature": "test-signature",
      },
      rawBody: Buffer.from(
        JSON.stringify(event),
      ),
    };

    response = {
      status: vi.fn().mockReturnThis(),
      send: vi.fn().mockReturnThis(),
    };
  });

  it("rejects non-POST requests", async () => {
    request.method = "GET";

    await paymentWebhook(
      request,
      response,
    );

    expect(response.status).toHaveBeenCalledWith(
      405,
    );

    expect(response.send).toHaveBeenCalledWith(
      "Method Not Allowed",
    );

    expect(verifyWebhook).not.toHaveBeenCalled();
  });

  it("rejects a missing webhook signature", async () => {
    request.headers = {};

    await paymentWebhook(
      request,
      response,
    );

    expect(response.status).toHaveBeenCalledWith(
      401,
    );

    expect(response.send).toHaveBeenCalledWith(
      "Missing webhook signature.",
    );

    expect(verifyWebhook).not.toHaveBeenCalled();
  });

  it("rejects an invalid webhook signature", async () => {
    verifyWebhook.mockImplementation(() => {
      throw new Error(
        "Invalid webhook signature.",
      );
    });

    await paymentWebhook(
      request,
      response,
    );

    expect(verifyWebhook).toHaveBeenCalledWith(
      JSON.stringify(event),
      "test-signature",
    );

    expect(response.status).toHaveBeenCalledWith(
      500,
    );

    expect(response.send).toHaveBeenCalledWith(
      "Webhook processing failed.",
    );

    expect(startProcessing).not.toHaveBeenCalled();
  });

  it("processes a paid webhook", async () => {
    await paymentWebhook(
      request,
      response,
    );

    expect(verifyWebhook).toHaveBeenCalledWith(
      JSON.stringify(event),
      "test-signature",
    );

    expect(startProcessing).toHaveBeenCalledWith(
      event.eventId,
    );

    expect(
      markPaidFromProvider,
    ).toHaveBeenCalledWith({
      bookingId: event.bookingId,
      provider: "mock",
      providerPaymentId:
        event.providerPaymentId,
    });

    expect(markProcessed).toHaveBeenCalledWith(
      event.eventId,
    );

    expect(response.status).toHaveBeenCalledWith(
      200,
    );

    expect(response.send).toHaveBeenCalledWith(
      "Webhook processed.",
    );
  });

  it("processes a processing webhook", async () => {
    verifyWebhook.mockReturnValue({
      ...event,
      status: "processing",
    });

    await paymentWebhook(
      request,
      response,
    );

    expect(markProcessing).toHaveBeenCalledWith({
      paymentId: event.bookingId,
    });

    expect(
      markPaidFromProvider,
    ).not.toHaveBeenCalled();

    expect(markProcessed).toHaveBeenCalledWith(
      event.eventId,
    );

    expect(response.status).toHaveBeenCalledWith(
      200,
    );
  });

  it("processes a failed webhook", async () => {
    verifyWebhook.mockReturnValue({
      ...event,
      status: "failed",
      failureReason: "Card declined.",
    });

    await paymentWebhook(
      request,
      response,
    );

    expect(markFailed).toHaveBeenCalledWith({
      bookingId: event.bookingId,
      failureReason: "Card declined.",
    });

    expect(
      markPaidFromProvider,
    ).not.toHaveBeenCalled();

    expect(markProcessed).toHaveBeenCalledWith(
      event.eventId,
    );

    expect(response.status).toHaveBeenCalledWith(
      200,
    );
  });

  it("uses the default failure reason when none is provided", async () => {
    verifyWebhook.mockReturnValue({
      ...event,
      status: "failed",
      failureReason: null,
    });

    await paymentWebhook(
      request,
      response,
    );

    expect(markFailed).toHaveBeenCalledWith({
      bookingId: event.bookingId,
      failureReason: "Payment failed.",
    });
  });

  it("does not process an already processed webhook", async () => {
    startProcessing.mockResolvedValue(false);

    await paymentWebhook(
      request,
      response,
    );

    expect(
      markPaidFromProvider,
    ).not.toHaveBeenCalled();

    expect(markProcessing).not.toHaveBeenCalled();
    expect(markFailed).not.toHaveBeenCalled();
    expect(markProcessed).not.toHaveBeenCalled();

    expect(response.status).toHaveBeenCalledWith(
      200,
    );

    expect(response.send).toHaveBeenCalledWith(
      "Already processed.",
    );
  });

  it("does not mark the webhook processed when payment processing fails", async () => {
    markPaidFromProvider.mockRejectedValue(
      new Error("Payment service unavailable."),
    );

    await paymentWebhook(
      request,
      response,
    );

    expect(markProcessed).not.toHaveBeenCalled();

    expect(
      markWebhookFailed,
    ).toHaveBeenCalledWith(
      event.eventId,
      "Payment service unavailable.",
    );

    expect(response.status).toHaveBeenCalledWith(
      500,
    );

    expect(response.send).toHaveBeenCalledWith(
      "Webhook processing failed.",
    );
  });

  it("records a webhook failure when processing fails", async () => {
    markProcessing.mockRejectedValue(
      new Error("Unable to update payment."),
    );

    verifyWebhook.mockReturnValue({
      ...event,
      status: "processing",
    });

    await paymentWebhook(
      request,
      response,
    );

    expect(
      markWebhookFailed,
    ).toHaveBeenCalledWith(
      event.eventId,
      "Unable to update payment.",
    );

    expect(markProcessed).not.toHaveBeenCalled();
  });

  it("returns 500 when webhook event verification fails", async () => {
    verifyWebhook.mockImplementation(() => {
      throw new Error("Malformed webhook.");
    });

    await paymentWebhook(
      request,
      response,
    );

    expect(response.status).toHaveBeenCalledWith(
      500,
    );

    expect(
      startProcessing,
    ).not.toHaveBeenCalled();
  });

  it("does not mark an event as processed when startProcessing fails", async () => {
    startProcessing.mockRejectedValue(
      new Error(
        "Unable to acquire webhook lease.",
      ),
    );

    await paymentWebhook(
      request,
      response,
    );

    expect(markProcessed).not.toHaveBeenCalled();

    expect(
      markWebhookFailed,
    ).toHaveBeenCalledWith(
      event.eventId,
      "Unable to acquire webhook lease.",
    );

    expect(response.status).toHaveBeenCalledWith(
      500,
    );
  });

  it("handles an unknown error type", async () => {
    markPaidFromProvider.mockRejectedValue(
      "unexpected failure",
    );

    await paymentWebhook(
      request,
      response,
    );

    expect(
      markWebhookFailed,
    ).toHaveBeenCalledWith(
      event.eventId,
      "Unknown webhook error.",
    );

    expect(response.status).toHaveBeenCalledWith(
      500,
    );
  });

  it("passes the raw request body to the provider", async () => {
    const rawBody =
      '{"some":"provider-payload"}';

    request.rawBody = Buffer.from(rawBody);

    await paymentWebhook(
      request,
      response,
    );

    expect(verifyWebhook).toHaveBeenCalledWith(
      rawBody,
      "test-signature",
    );
  });
});
