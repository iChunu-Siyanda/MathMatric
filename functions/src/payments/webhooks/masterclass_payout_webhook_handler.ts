import {
  MasterclassPayoutService,
} from "../masterclasses/payout/masterclass_payout_service";

import {
  PayoutWebhookEvent,
} from "../provider/payout_provider";

import {
  WebhookEventService,
} from "./webhook_event_service";

export interface MasterclassPayoutWebhookHandlerDependencies {
  masterclassPayoutService: MasterclassPayoutService;
  webhookEventService: WebhookEventService;
}

export interface MasterclassPayoutWebhookHandlerResult {
  statusCode: number;
  message: string;
}

export class MasterclassPayoutWebhookHandler {
  constructor(
    private readonly dependencies: MasterclassPayoutWebhookHandlerDependencies,
  ) {}

  async handle(
    event: PayoutWebhookEvent,
  ): Promise<MasterclassPayoutWebhookHandlerResult> {
    const {
      masterclassPayoutService,
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
      /*
       * Same self-healing attach-first pattern as the
       * booking payout webhook: if this webhook arrives
       * before initiatePayout's own attach step landed
       * (timeout/ambiguous-outcome case), attaching here
       * resolves it rather than rejecting.
       */
      await masterclassPayoutService
        .attachProviderPayoutId(
          event.payoutId,
          event.providerPayoutId,
        );

      switch (event.status) {
        case "processing":
          await masterclassPayoutService
            .markProcessing(
              event.payoutId,
              event.providerPayoutId,
            );

          break;

        case "succeeded":
          await masterclassPayoutService
            .markSucceeded(
              event.payoutId,
              event.providerPayoutId,
            );

          break;

        case "failed":
          await masterclassPayoutService
            .markFailed(
              event.payoutId,
              event.failureReason ??
                "Masterclass payout failed.",
              event.providerPayoutId,
            );

          break;

        default:
          throw new Error(
            "Unsupported masterclass payout status.",
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
          "Failed to record masterclass payout webhook failure.",
          markFailedError,
        );
      }

      throw error;
    }
  }
}
