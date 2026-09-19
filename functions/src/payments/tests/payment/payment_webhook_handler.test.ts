import {
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

describe(
  "handlePaymentWebhookRequest",
  () => {
    const event: PaymentWebhookEvent = {
      providerPaymentId:
        "provider-payment-1",
      bookingId:
        "booking-1",
      status:
        "paid",
      failureReason:
        null,
      eventId:
        "event-1",
      occurredAt:
        new Date(
          "2026-02-01T15:00:00.000Z",
        ),
    };

    function createRequest(
      overrides: Partial<Request> = {},
    ): Request {
      return {
        method: "POST",
        headers: {
          "x-payment-signature":
            "valid-signature",
        },
        rawBody: Buffer.from(
          JSON.stringify(event),
        ),
        ...overrides,
      } as unknown as Request;
    }

    function createResponse(): Response {
      const response = {
        status: vi.fn(),
        send: vi.fn(),
      };

      response.status.mockReturnValue(
        response,
      );

      return response as unknown as Response;
    }

    function createDependencies() {
      const paymentProvider = {
        name: "mock",

        verifyWebhook:
          vi.fn().mockReturnValue(event),
      } as unknown as PaymentProvider;

      const paymentWebhookHandler = {
        handle:
          vi.fn().mockResolvedValue({
            statusCode: 200,
            message:
              "Webhook processed.",
          }),
      } as unknown as PaymentWebhookHandler;

      return {
        paymentProvider,
        paymentWebhookHandler,
      };
    }

    it(
      "processes a valid POST webhook",
      async () => {
        const {
          paymentProvider,
          paymentWebhookHandler,
        } = createDependencies();

        const request =
          createRequest();

        const response =
          createResponse();

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
          "valid-signature",
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
        const {
          paymentProvider,
          paymentWebhookHandler,
        } = createDependencies();

        const request =
          createRequest({
            method: "GET",
          });

        const response =
          createResponse();

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
        const {
          paymentProvider,
          paymentWebhookHandler,
        } = createDependencies();

        const request =
          createRequest({
            headers: {},
          });

        const response =
          createResponse();

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
        const {
          paymentProvider,
          paymentWebhookHandler,
        } = createDependencies();

        const request =
          createRequest({
            rawBody: undefined,
          });

        const response =
          createResponse();

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
        const {
          paymentProvider,
          paymentWebhookHandler,
        } = createDependencies();

        const request =
          createRequest();

        const response =
          createResponse();

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
          "valid-signature",
        );
      },
    );

    it(
      "returns 500 when webhook verification fails",
      async () => {
        const {
          paymentProvider,
          paymentWebhookHandler,
        } = createDependencies();

        vi.mocked(
          paymentProvider.verifyWebhook,
        ).mockImplementation(() => {
          throw new Error(
            "Invalid webhook signature.",
          );
        });

        const response =
          createResponse();

        await handlePaymentWebhookRequest(
          createRequest(),
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
        const {
          paymentProvider,
          paymentWebhookHandler,
        } = createDependencies();

        vi.mocked(
          paymentWebhookHandler.handle,
        ).mockRejectedValue(
          new Error(
            "Payment processing failed.",
          ),
        );

        const response =
          createResponse();

        await handlePaymentWebhookRequest(
          createRequest(),
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
        const {
          paymentProvider,
          paymentWebhookHandler,
        } = createDependencies();

        vi.mocked(
          paymentProvider.verifyWebhook,
        ).mockImplementation(() => {
          throw new Error(
            "Invalid webhook.",
          );
        });

        const response =
          createResponse();

        await handlePaymentWebhookRequest(
          createRequest(),
          response,
          paymentProvider,
          paymentWebhookHandler,
        );

        expect(
          paymentWebhookHandler.handle,
        ).not.toHaveBeenCalled();
      },
    );
  },
);
