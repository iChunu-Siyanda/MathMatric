export interface PayoutWebhookEvent {
  providerPayoutId: string;
  payoutId: string;
  status:
    | "processing"
    | "succeeded"
    | "failed";
  failureReason: string | null;
  eventId: string;
  occurredAt: Date;
}

export interface PayoutProvider {
  readonly name: string;

  createPayout({
    amountCents,
    currency,
    payoutId,
    tutorId,
  }: {
    amountCents: number;
    currency: "ZAR";
    payoutId: string;
    tutorId: string;
  }): Promise<{
    providerPayoutId: string;
  }>;

  verifyWebhook(
    payload: string,
    signature: string,
  ): PayoutWebhookEvent;
}

export class PayoutProviderOutcomeUnknownError extends Error {
  constructor(
    message = "Payout provider call outcome is unknown.",
  ) {
    super(message);
    this.name = "PayoutProviderOutcomeUnknownError";
  }
}
