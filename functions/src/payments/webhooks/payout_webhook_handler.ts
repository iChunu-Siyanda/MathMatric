import {
  PayoutService,
} from "../payout/payout_service";

import {
  PayoutWebhookEvent,
} from "../provider/payout_provider";

import {
  WebhookEventService,
} from "./webhook_event_service";

export interface PayoutWebhookHandlerDependencies {
  payoutService: PayoutService;
  webhookEventService: WebhookEventService;
}

export interface PayoutWebhookHandlerResult {
  statusCode: number;
  message: string;
}

export class PayoutWebhookHandler {
  constructor(
    private readonly dependencies: PayoutWebhookHandlerDependencies,
  ) {}

  async handle(
    event: PayoutWebhookEvent,
  ): Promise<PayoutWebhookHandlerResult> {
    const {
      payoutService,
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
      await payoutService
        .attachProviderPayoutId(
          event.payoutId,
          event.providerPayoutId,
        );

      switch (event.status) {
        case "processing":
          await payoutService
            .markProcessing(
              event.payoutId,
              event.providerPayoutId,
            );
          break;

        case "succeeded":
          await payoutService
            .markSucceeded(
              event.payoutId,
              event.providerPayoutId,
            );
          break;

        case "failed":
          await payoutService
            .markFailed(
              event.payoutId,
              event.failureReason ?? "Payout failed.",
              event.providerPayoutId,
            );
          break;

        default:
          throw new Error(
            "Unsupported payout status.",
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
