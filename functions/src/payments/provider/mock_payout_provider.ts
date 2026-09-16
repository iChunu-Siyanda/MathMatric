import {PayoutProvider,PayoutWebhookEvent,} from "./payout_provider";
import { ProviderValidator } from "./provider_validator";

export class MockPayoutProvider implements PayoutProvider
{
  readonly name = "mock";

  async createPayout({
    amountCents,
    currency,
    payoutId,
    tutorId,
  }: {
    amountCents: number;
    currency: "ZAR";
    payoutId: string;
    tutorId: string;
  }) {
    ProviderValidator.validateAmount(
      amountCents,
    );

    ProviderValidator.validateCurrency(
      currency,
    );

    if (!payoutId.trim()) {
      throw new Error(
        "Payout ID cannot be empty.",
      );
    }

    if (!tutorId.trim()) {
      throw new Error(
        "Tutor ID cannot be empty.",
      );
    }

    return {
      providerPayoutId:
        `mock-payout-${payoutId}`,
    };
  }

  verifyWebhook(
    payload: string,
    signature: string,
  ): PayoutWebhookEvent {
    if (signature !== "test-signature") {
      throw new Error(
        "Invalid webhook signature.",
      );
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

    const occurredAt =
      new Date(event.occurredAt);

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
      providerPayoutId: event.providerPayoutId,
      payoutId: event.payoutId,
      status: event.status,
      failureReason: event.failureReason ?? null,
      eventId: event.eventId,
      occurredAt,
    };
  }
}
