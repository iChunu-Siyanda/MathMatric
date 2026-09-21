import {
  MasterclassPaymentService,
} from "../masterclasses/payment/masterclass_payment_service";

import {
  MasterclassPaymentSuccessService,
} from "../masterclasses/payment/masterclass_payment_success_service";

import {
  PaymentWebhookEvent,
} from "../provider/payment_provider";

import {
  WebhookEventService,
} from "./webhook_event_service";

export interface MasterclassPaymentWebhookHandlerDependencies {
  masterclassPaymentService: MasterclassPaymentService;
  masterclassPaymentSuccessService: MasterclassPaymentSuccessService;
  webhookEventService: WebhookEventService;
}

export interface MasterclassPaymentWebhookHandlerResult {
  statusCode: number;
  message: string;
}

export class MasterclassPaymentWebhookHandler {
  constructor(
    private readonly dependencies: MasterclassPaymentWebhookHandlerDependencies,
  ) {}

  async handle(
    event: PaymentWebhookEvent,
  ): Promise<MasterclassPaymentWebhookHandlerResult> {
    const {
      masterclassPaymentService,
      masterclassPaymentSuccessService,
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
          await masterclassPaymentService
            .markProcessing(
              event.bookingId,
            );

          break;

        case "paid":
          await masterclassPaymentSuccessService
            .markPaymentPaid({
              enrollmentId:
                event.bookingId,
              providerPaymentId:
                event.providerPaymentId,
              paidAt:
                event.occurredAt,
            });

          break;

        case "failed":
          await masterclassPaymentService
            .markFailed({
              enrollmentId:
                event.bookingId,
              failureReason:
                event.failureReason ??
                "Masterclass payment failed.",
            });

          break;

        default:
          throw new Error(
            "Unsupported masterclass payment status.",
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
          "Failed to record masterclass payment webhook failure.",
          markFailedError,
        );
      }

      throw error;
    }
  }
}
