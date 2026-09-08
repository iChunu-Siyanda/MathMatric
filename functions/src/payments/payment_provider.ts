export interface PaymentProvider {
  readonly name:string;

  createPayment({
    amountCents,
    currency,
    bookingId,
    studentId,
  }: {
    amountCents: number;
    currency: string;
    bookingId: string;
    studentId: string;
  }): Promise<{
    providerPaymentId: string;
    checkoutUrl: string;
  }>;
}
