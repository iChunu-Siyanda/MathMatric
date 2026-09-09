import {
  describe,
  expect,
  it,
  vi,
} from "vitest";

import {
  PaymentWebhookHandler,
  PaymentWebhookHandlerDependencies,
} from "../webhooks/payment_webhook_handler";

import {
  PaymentService,
} from "../payment/payment_service";

import {
  PaymentSuccessService,
} from "../payment/payent_success_service";

import {
  WebhookEventService,
} from "../webhooks/webhook_event_service";

import {
  PaymentWebhookEvent,
} from "../provider/payment_provider";

function createEvent(
  overrides:
    Partial<PaymentWebhookEvent> = {},
): PaymentWebhookEvent {
  return {
    providerPaymentId:
      "mock-payment-1",

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

    ...overrides,
  };
}

function createDependencies() {
  const paymentService = {
    markProcessing:
      vi.fn().mockResolvedValue(undefined),

    markFailed:
      vi.fn().mockResolvedValue(undefined),
  } as unknown as PaymentService;

  const paymentSuccessService = {
    markPaymentPaid:
      vi.fn().mockResolvedValue(undefined),
  } as unknown as PaymentSuccessService;

  const webhookEventService = {
    startProcessing:
      vi.fn().mockResolvedValue(true),

    markProcessed:
      vi.fn().mockResolvedValue(undefined),

    markFailed:
      vi.fn().mockResolvedValue(undefined),
  } as unknown as WebhookEventService;

  const dependencies:
    PaymentWebhookHandlerDependencies =
    {
      paymentService,
      paymentSuccessService,
      webhookEventService,
    };

  return {
    dependencies,
    paymentService,
    paymentSuccessService,
    webhookEventService,
  };
}

describe(
  "PaymentWebhookHandler",
  () => {
    it(
      "processes a paid event",
      async () => {
        const {
          dependencies,
          paymentSuccessService,
          webhookEventService,
        } = createDependencies();

        const handler =
          new PaymentWebhookHandler(
            dependencies,
          );

        const event =
          createEvent({
            status: "paid",
          });

        const result =
          await handler.handle(event);

        expect(result)
          .toEqual({
            statusCode: 200,
            message:
              "Webhook processed.",
          });

        expect(
          webhookEventService
            .startProcessing,
        ).toHaveBeenCalledWith(
          "event-1",
        );

        expect(
          paymentSuccessService
            .markPaymentPaid,
        ).toHaveBeenCalledWith({
          bookingId:
            "booking-1",

          providerPaymentId:
            "mock-payment-1",

          paidAt:
            new Date(
              "2026-02-01T15:00:00.000Z",
            ),
        });

        expect(
          webhookEventService
            .markProcessed,
        ).toHaveBeenCalledWith(
          "event-1",
        );
      },
    );

    it(
      "processes a processing event",
      async () => {
        const {
          dependencies,
          paymentService,
          paymentSuccessService,
          webhookEventService,
        } = createDependencies();

        const handler =
          new PaymentWebhookHandler(
            dependencies,
          );

        await handler.handle(
          createEvent({
            status: "processing",
          }),
        );

        expect(
          paymentService
            .markProcessing,
        ).toHaveBeenCalledWith({
          paymentId:
            "booking-1",
        });

        expect(
          paymentSuccessService
            .markPaymentPaid,
        ).not.toHaveBeenCalled();

        expect(
          webhookEventService
            .markProcessed,
        ).toHaveBeenCalledWith(
          "event-1",
        );
      },
    );

    it(
      "processes a failed event",
      async () => {
        const {
          dependencies,
          paymentService,
          paymentSuccessService,
          webhookEventService,
        } = createDependencies();

        const handler =
          new PaymentWebhookHandler(
            dependencies,
          );

        await handler.handle(
          createEvent({
            status: "failed",
            failureReason:
              "Insufficient funds.",
          }),
        );

        expect(
          paymentService.markFailed,
        ).toHaveBeenCalledWith({
          bookingId:
            "booking-1",

          failureReason:
            "Insufficient funds.",
        });

        expect(
          paymentSuccessService
            .markPaymentPaid,
        ).not.toHaveBeenCalled();

        expect(
          webhookEventService
            .markProcessed,
        ).toHaveBeenCalledWith(
          "event-1",
        );
      },
    );

    it(
      "uses the default failure reason when none is provided",
      async () => {
        const {
          dependencies,
          paymentService,
        } = createDependencies();

        const handler =
          new PaymentWebhookHandler(
            dependencies,
          );

        await handler.handle(
          createEvent({
            status: "failed",
            failureReason: null,
          }),
        );

        expect(
          paymentService.markFailed,
        ).toHaveBeenCalledWith({
          bookingId:
            "booking-1",

          failureReason:
            "Payment failed.",
        });
      },
    );

    it(
      "returns 200 without processing a duplicate webhook",
      async () => {
        const {
          dependencies,
          paymentService,
          paymentSuccessService,
          webhookEventService,
        } = createDependencies();

        vi.mocked(
          webhookEventService
            .startProcessing,
        ).mockResolvedValue(false);

        const handler =
          new PaymentWebhookHandler(
            dependencies,
          );

        const result =
          await handler.handle(
            createEvent(),
          );

        expect(result)
          .toEqual({
            statusCode: 200,
            message:
              "Already processed.",
          });

        expect(
          paymentService
            .markProcessing,
        ).not.toHaveBeenCalled();

        expect(
          paymentService.markFailed,
        ).not.toHaveBeenCalled();

        expect(
          paymentSuccessService
            .markPaymentPaid,
        ).not.toHaveBeenCalled();

        expect(
          webhookEventService
            .markProcessed,
        ).not.toHaveBeenCalled();

        expect(
          webhookEventService
            .markFailed,
        ).not.toHaveBeenCalled();
      },
    );

    it(
      "marks the webhook failed when payment processing fails",
      async () => {
        const {
          dependencies,
          paymentSuccessService,
          webhookEventService,
        } = createDependencies();

        vi.mocked(
          paymentSuccessService
            .markPaymentPaid,
        ).mockRejectedValue(
          new Error(
            "Ledger creation failed.",
          ),
        );

        const handler =
          new PaymentWebhookHandler(
            dependencies,
          );

        await expect(
          handler.handle(
            createEvent({
              status: "paid",
            }),
          ),
        ).rejects.toThrow(
          "Ledger creation failed.",
        );

        expect(
          webhookEventService
            .markFailed,
        ).toHaveBeenCalledWith(
          "event-1",
          "Ledger creation failed.",
        );

        expect(
          webhookEventService
            .markProcessed,
        ).not.toHaveBeenCalled();
      },
    );

    it(
      "marks the webhook failed when processing event handling fails",
      async () => {
        const {
          dependencies,
          paymentService,
          webhookEventService,
        } = createDependencies();

        vi.mocked(
          paymentService.markProcessing,
        ).mockRejectedValue(
          new Error(
            "Payment processing failed.",
          ),
        );

        const handler =
          new PaymentWebhookHandler(
            dependencies,
          );

        await expect(
          handler.handle(
            createEvent({
              status: "processing",
            }),
          ),
        ).rejects.toThrow(
          "Payment processing failed.",
        );

        expect(
          webhookEventService
            .markFailed,
        ).toHaveBeenCalledWith(
          "event-1",
          "Payment processing failed.",
        );

        expect(
          webhookEventService
            .markProcessed,
        ).not.toHaveBeenCalled();
      },
    );

    it(
      "marks the webhook failed when failed-payment handling fails",
      async () => {
        const {
          dependencies,
          paymentService,
          webhookEventService,
        } = createDependencies();

        vi.mocked(
          paymentService.markFailed,
        ).mockRejectedValue(
          new Error(
            "Failed to update payment.",
          ),
        );

        const handler =
          new PaymentWebhookHandler(
            dependencies,
          );

        await expect(
          handler.handle(
            createEvent({
              status: "failed",
            }),
          ),
        ).rejects.toThrow(
          "Failed to update payment.",
        );

        expect(
          webhookEventService
            .markFailed,
        ).toHaveBeenCalledWith(
          "event-1",
          "Failed to update payment.",
        );

        expect(
          webhookEventService
            .markProcessed,
        ).not.toHaveBeenCalled();
      },
    );

    it(
      "does not mark the webhook processed when payment success fails",
      async () => {
        const {
          dependencies,
          paymentSuccessService,
          webhookEventService,
        } = createDependencies();

        vi.mocked(
          paymentSuccessService
            .markPaymentPaid,
        ).mockRejectedValue(
          new Error(
            "Payment transaction failed.",
          ),
        );

        const handler =
          new PaymentWebhookHandler(
            dependencies,
          );

        await expect(
          handler.handle(
            createEvent(),
          ),
        ).rejects.toThrow(
          "Payment transaction failed.",
        );

        expect(
          webhookEventService
            .markProcessed,
        ).not.toHaveBeenCalled();

        expect(
          webhookEventService
            .markFailed,
        ).toHaveBeenCalledTimes(1);
      },
    );

    it(
      "propagates the original processing error when recording webhook failure also fails",
      async () => {
        const {
          dependencies,
          paymentSuccessService,
          webhookEventService,
        } = createDependencies();

        vi.mocked(
          paymentSuccessService
            .markPaymentPaid,
        ).mockRejectedValue(
          new Error(
            "Original payment error.",
          ),
        );

        vi.mocked(
          webhookEventService
            .markFailed,
        ).mockRejectedValue(
          new Error(
            "Webhook failure recording error.",
          ),
        );

        const handler =
          new PaymentWebhookHandler(
            dependencies,
          );

        await expect(
          handler.handle(
            createEvent(),
          ),
        ).rejects.toThrow(
          "Original payment error.",
        );
      },
    );

    it(
      "passes the provider occurrence time to payment success",
      async () => {
        const {
          dependencies,
          paymentSuccessService,
        } = createDependencies();

        const handler =
          new PaymentWebhookHandler(
            dependencies,
          );

        const occurredAt =
          new Date(
            "2026-04-10T12:30:00.000Z",
          );

        await handler.handle(
          createEvent({
            status: "paid",
            occurredAt,
          }),
        );

        expect(
          paymentSuccessService
            .markPaymentPaid,
        ).toHaveBeenCalledWith({
          bookingId:
            "booking-1",

          providerPaymentId:
            "mock-payment-1",

          paidAt: occurredAt,
        });
      },
    );

    it(
      "does not process a webhook after startProcessing returns false",
      async () => {
        const {
          dependencies,
          paymentService,
          paymentSuccessService,
          webhookEventService,
        } = createDependencies();

        vi.mocked(
          webhookEventService
            .startProcessing,
        ).mockResolvedValue(false);

        const handler =
          new PaymentWebhookHandler(
            dependencies,
          );

        await handler.handle(
          createEvent({
            status: "paid",
          }),
        );

        expect(
          paymentSuccessService
            .markPaymentPaid,
        ).not.toHaveBeenCalled();

        expect(
          paymentService
            .markProcessing,
        ).not.toHaveBeenCalled();

        expect(
          paymentService.markFailed,
        ).not.toHaveBeenCalled();
      },
    );

    it(
      "does not mark the event processed if payment processing throws",
      async () => {
        const {
          dependencies,
          paymentService,
          webhookEventService,
        } = createDependencies();

        vi.mocked(
          paymentService
            .markProcessing,
        ).mockRejectedValue(
          new Error(
            "Processing unavailable.",
          ),
        );

        const handler =
          new PaymentWebhookHandler(
            dependencies,
          );

        await expect(
          handler.handle(
            createEvent({
              status: "processing",
            }),
          ),
        ).rejects.toThrow(
          "Processing unavailable.",
        );

        expect(
          webhookEventService
            .markProcessed,
        ).not.toHaveBeenCalled();

        expect(
          webhookEventService
            .markFailed,
        ).toHaveBeenCalledWith(
          "event-1",
          "Processing unavailable.",
        );
      },
    );
  },
);
