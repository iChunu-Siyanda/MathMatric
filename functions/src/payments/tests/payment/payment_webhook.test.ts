import {
  beforeEach,
  describe,
  expect,
  it,
  vi,
} from "vitest";

import {
  Request,
  Response,
} from "express";

import {
  PaymentProvider,
  PaymentWebhookEvent,
} from "../provider/payment_provider";

import {
  PaymentWebhookHandler,
} from "../webhooks/payment_webhook_handler";

import {
  handlePaymentWebhookRequest,
} from "../webhooks/payment_webhook_request_handler";

describe("paymentWebhook", () => {
  const event: PaymentWebhookEvent = {
    eventId: "event-123",
    bookingId: "booking-123",
    providerPaymentId:
      "mock-booking-123",
    status: "paid",
    failureReason: null,
    occurredAt: new Date(
      "2026-02-01T15:00:00.000Z",
    ),
  };

  let request: Request;
  let response: Response;
  let paymentProvider: PaymentProvider;
  let paymentWebhookHandler: PaymentWebhookHandler;

  beforeEach(() => {
    paymentProvider = {
      name: "mock",

      verifyWebhook:
        vi.fn().mockReturnValue(event),
    } as unknown as PaymentProvider;

    paymentWebhookHandler = {
      handle:
        vi.fn().mockResolvedValue({
          statusCode: 200,
          message: "Webhook processed.",
        }),
    } as unknown as PaymentWebhookHandler;

    request = {
      method: "POST",

      headers: {
        "x-payment-signature":
          "test-signature",
      },

      rawBody: Buffer.from(
        JSON.stringify(event),
      ),
    } as unknown as Request;

    const responseMock = {
      status: vi.fn(),
      send: vi.fn(),
    };

    responseMock.status.mockReturnValue(
      responseMock,
    );

    response =
      responseMock as unknown as Response;
  });

  it(
    "processes a valid POST webhook",
    async () => {
      await handlePaymentWebhookRequest(
        request,
        response,
        paymentProvider,
        paymentWebhookHandler,
      );

      expect(
        paymentProvider.verifyWebhook,
      ).toHaveBeenCalledWith(
        request.rawBody!.toString(
          "utf8",
        ),
        "test-signature",
      );

      expect(
        paymentWebhookHandler.handle,
      ).toHaveBeenCalledWith(
        event,
      );

      expect(
        response.status,
      ).toHaveBeenCalledWith(
        200,
      );

      expect(
        response.send,
      ).toHaveBeenCalledWith(
        "Webhook processed.",
      );
    },
  );

  it(
    "rejects non-POST requests",
    async () => {
      request.method = "GET";

      await handlePaymentWebhookRequest(
        request,
        response,
        paymentProvider,
        paymentWebhookHandler,
      );

      expect(
        response.status,
      ).toHaveBeenCalledWith(
        405,
      );

      expect(
        response.send,
      ).toHaveBeenCalledWith(
        "Method Not Allowed",
      );

      expect(
        paymentProvider.verifyWebhook,
      ).not.toHaveBeenCalled();

      expect(
        paymentWebhookHandler.handle,
      ).not.toHaveBeenCalled();
    },
  );

  it(
    "rejects a missing webhook signature",
    async () => {
      request.headers = {};

      await handlePaymentWebhookRequest(
        request,
        response,
        paymentProvider,
        paymentWebhookHandler,
      );

      expect(
        response.status,
      ).toHaveBeenCalledWith(
        401,
      );

      expect(
        response.send,
      ).toHaveBeenCalledWith(
        "Missing webhook signature.",
      );

      expect(
        paymentProvider.verifyWebhook,
      ).not.toHaveBeenCalled();

      expect(
        paymentWebhookHandler.handle,
      ).not.toHaveBeenCalled();
    },
  );

  it(
    "rejects a missing webhook body",
    async () => {
      request.rawBody =
        undefined;

      await handlePaymentWebhookRequest(
        request,
        response,
        paymentProvider,
        paymentWebhookHandler,
      );

      expect(
        response.status,
      ).toHaveBeenCalledWith(
        400,
      );

      expect(
        response.send,
      ).toHaveBeenCalledWith(
        "Missing webhook body.",
      );

      expect(
        paymentProvider.verifyWebhook,
      ).not.toHaveBeenCalled();

      expect(
        paymentWebhookHandler.handle,
      ).not.toHaveBeenCalled();
    },
  );

  it(
    "passes the raw request body to the provider",
    async () => {
      const rawBody =
        '{"some":"provider-payload"}';

      request.rawBody =
        Buffer.from(rawBody);

      await handlePaymentWebhookRequest(
        request,
        response,
        paymentProvider,
        paymentWebhookHandler,
      );

      expect(
        paymentProvider.verifyWebhook,
      ).toHaveBeenCalledWith(
        rawBody,
        "test-signature",
      );
    },
  );

  it(
    "returns 500 when webhook verification fails",
    async () => {
      vi.mocked(
        paymentProvider.verifyWebhook,
      ).mockImplementation(() => {
        throw new Error(
          "Invalid webhook signature.",
        );
      });

      await handlePaymentWebhookRequest(
        request,
        response,
        paymentProvider,
        paymentWebhookHandler,
      );

      expect(
        response.status,
      ).toHaveBeenCalledWith(
        500,
      );

      expect(
        response.send,
      ).toHaveBeenCalledWith(
        "Webhook processing failed.",
      );

      expect(
        paymentWebhookHandler.handle,
      ).not.toHaveBeenCalled();
    },
  );

  it(
    "returns 500 when the webhook handler fails",
    async () => {
      vi.mocked(
        paymentWebhookHandler.handle,
      ).mockRejectedValue(
        new Error(
          "Payment processing failed.",
        ),
      );

      await handlePaymentWebhookRequest(
        request,
        response,
        paymentProvider,
        paymentWebhookHandler,
      );

      expect(
        response.status,
      ).toHaveBeenCalledWith(
        500,
      );

      expect(
        response.send,
      ).toHaveBeenCalledWith(
        "Webhook processing failed.",
      );
    },
  );

  it(
    "does not call the handler when verification fails",
    async () => {
      vi.mocked(
        paymentProvider.verifyWebhook,
      ).mockImplementation(() => {
        throw new Error(
          "Invalid webhook.",
        );
      });

      await handlePaymentWebhookRequest(
        request,
        response,
        paymentProvider,
        paymentWebhookHandler,
      );

      expect(
        paymentWebhookHandler.handle,
      ).not.toHaveBeenCalled();
    },
  );
});
