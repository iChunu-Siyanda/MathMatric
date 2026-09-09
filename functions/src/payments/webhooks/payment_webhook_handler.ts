import {
  PaymentService,
} from "../payment/payment_service";

import {
  PaymentSuccessService,
} from "../payment/payent_success_service";

import {
  PaymentWebhookEvent,
} from "../provider/payment_provider";

import {
  WebhookEventService,
} from "./webhook_event_service";

export interface PaymentWebhookHandlerDependencies {
  paymentService: PaymentService;
  paymentSuccessService: PaymentSuccessService;
  webhookEventService: WebhookEventService;
}

export interface PaymentWebhookHandlerResult {
  statusCode: number;
  message: string;
}

export class PaymentWebhookHandler {
  constructor(
    private readonly dependencies:
      PaymentWebhookHandlerDependencies,
  ) {}

  async handle(
    event: PaymentWebhookEvent,
  ): Promise<PaymentWebhookHandlerResult> {
    const {
      paymentService,
      paymentSuccessService,
      webhookEventService,
    } = this.dependencies;

    const shouldProcess =
      await webhookEventService
        .startProcessing(event.eventId);

    if (!shouldProcess) {
      return {
        statusCode: 200,
        message: "Already processed.",
      };
    }

    try {
      switch (event.status) {
        case "processing":
          await paymentService
            .markProcessing({
              paymentId:
                event.bookingId,
            });

          break;

        case "paid":
          await paymentSuccessService
            .markPaymentPaid({
              bookingId:
                event.bookingId,

              providerPaymentId:
                event.providerPaymentId,

              paidAt:
                event.occurredAt,
            });

          break;

        case "failed":
          await paymentService
            .markFailed({
              bookingId:
                event.bookingId,

              failureReason:
                event.failureReason ??
                "Payment failed.",
            });

          break;

        default:
          throw new Error(
            "Unsupported payment status.",
          );
      }

      await webhookEventService
        .markProcessed(
          event.eventId,
        );

      return {
        statusCode: 200,
        message: "Webhook processed.",
      };
    } catch (error) {
      try {
        await webhookEventService
          .markFailed(
            event.eventId,
            error instanceof Error
              ? error.message
              : "Unknown webhook error.",
          );
      } catch (markFailedError) {
        console.error(
          "Failed to record webhook failure.",
          markFailedError,
        );
      }

      throw error;
    }
  }
}
