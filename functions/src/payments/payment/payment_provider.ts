export interface PaymentWebhookEvent {
  providerPaymentId: string;
  bookingId: string;
  status:
    | "processing"
    | "paid"
    | "failed";
  failureReason: string | null;
  eventId: string;
}

export interface PaymentProvider {
  readonly name: string;

  createPayment({
    amountCents,
    currency,
    bookingId,
    studentId,
  }: {
    amountCents: number;
    currency: "ZAR";
    bookingId: string;
    studentId: string;
  }): Promise<{
    providerPaymentId: string;
    checkoutUrl: string;
  }>;

  verifyWebhook(
    payload: string,
    signature: string,
  ): PaymentWebhookEvent;
}
