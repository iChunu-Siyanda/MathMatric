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
  PayoutProvider,
  PayoutWebhookEvent,
} from "../../provider/payout_provider";

import {
  PayoutWebhookHandler,
} from "../../webhooks/payout_webhook_handler";

import {
  handlePayoutWebhookRequest,
} from "../../webhooks/payout_webhook_request_handler";

describe(
  "handlePayoutWebhookRequest",
  () => {
    const event: PayoutWebhookEvent = {
      providerPayoutId:
        "provider-payout-1",
      payoutId:
        "payout-1",
      status:
        "succeeded",
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
          "x-payout-signature":
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
      const payoutProvider = {
        name: "mock",

        verifyWebhook:
          vi.fn().mockReturnValue(event),
      } as unknown as PayoutProvider;

      const payoutWebhookHandler = {
        handle:
          vi.fn().mockResolvedValue({
            statusCode: 200,
            message:
              "Webhook processed.",
          }),
      } as unknown as PayoutWebhookHandler;

      return {
        payoutProvider,
        payoutWebhookHandler,
      };
    }

    it(
      "processes a valid POST webhook",
      async () => {
        const {
          payoutProvider,
          payoutWebhookHandler,
        } = createDependencies();

        const request =
          createRequest();

        const response =
          createResponse();

        await handlePayoutWebhookRequest(
          request,
          response,
          payoutProvider,
          payoutWebhookHandler,
        );

        expect(
          payoutProvider.verifyWebhook,
        ).toHaveBeenCalledWith(
          request.rawBody!.toString(
            "utf8",
          ),
          "valid-signature",
        );

        expect(
          payoutWebhookHandler.handle,
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
          payoutProvider,
          payoutWebhookHandler,
        } = createDependencies();

        const request =
          createRequest({
            method: "GET",
          });

        const response =
          createResponse();

        await handlePayoutWebhookRequest(
          request,
          response,
          payoutProvider,
          payoutWebhookHandler,
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
          payoutProvider.verifyWebhook,
        ).not.toHaveBeenCalled();

        expect(
          payoutWebhookHandler.handle,
        ).not.toHaveBeenCalled();
      },
    );

    it(
      "rejects a missing webhook signature",
      async () => {
        const {
          payoutProvider,
          payoutWebhookHandler,
        } = createDependencies();

        const request =
          createRequest({
            headers: {},
          });

        const response =
          createResponse();

        await handlePayoutWebhookRequest(
          request,
          response,
          payoutProvider,
          payoutWebhookHandler,
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
          payoutProvider.verifyWebhook,
        ).not.toHaveBeenCalled();

        expect(
          payoutWebhookHandler.handle,
        ).not.toHaveBeenCalled();
      },
    );

    it(
      "rejects a missing webhook body",
      async () => {
        const {
          payoutProvider,
          payoutWebhookHandler,
        } = createDependencies();

        const request =
          createRequest({
            rawBody: undefined,
          });

        const response =
          createResponse();

        await handlePayoutWebhookRequest(
          request,
          response,
          payoutProvider,
          payoutWebhookHandler,
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
          payoutProvider.verifyWebhook,
        ).not.toHaveBeenCalled();

        expect(
          payoutWebhookHandler.handle,
        ).not.toHaveBeenCalled();
      },
    );

    it(
      "passes the raw request body to the provider",
      async () => {
        const {
          payoutProvider,
          payoutWebhookHandler,
        } = createDependencies();

        const request =
          createRequest();

        const response =
          createResponse();

        await handlePayoutWebhookRequest(
          request,
          response,
          payoutProvider,
          payoutWebhookHandler,
        );

        expect(
          payoutProvider.verifyWebhook,
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
          payoutProvider,
          payoutWebhookHandler,
        } = createDependencies();

        vi.mocked(
          payoutProvider.verifyWebhook,
        ).mockImplementation(() => {
          throw new Error(
            "Invalid webhook signature.",
          );
        });

        const response =
          createResponse();

        await handlePayoutWebhookRequest(
          createRequest(),
          response,
          payoutProvider,
          payoutWebhookHandler,
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
          payoutWebhookHandler.handle,
        ).not.toHaveBeenCalled();
      },
    );

    it(
      "returns 500 when the webhook handler fails",
      async () => {
        const {
          payoutProvider,
          payoutWebhookHandler,
        } = createDependencies();

        vi.mocked(
          payoutWebhookHandler.handle,
        ).mockRejectedValue(
          new Error(
            "Payout processing failed.",
          ),
        );

        const response =
          createResponse();

        await handlePayoutWebhookRequest(
          createRequest(),
          response,
          payoutProvider,
          payoutWebhookHandler,
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
          payoutProvider,
          payoutWebhookHandler,
        } = createDependencies();

        vi.mocked(
          payoutProvider.verifyWebhook,
        ).mockImplementation(() => {
          throw new Error(
            "Invalid webhook.",
          );
        });

        const response =
          createResponse();

        await handlePayoutWebhookRequest(
          createRequest(),
          response,
          payoutProvider,
          payoutWebhookHandler,
        );

        expect(
          payoutWebhookHandler.handle,
        ).not.toHaveBeenCalled();
      },
    );
  },
);
