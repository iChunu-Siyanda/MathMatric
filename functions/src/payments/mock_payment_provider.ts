import { PaymentProvider } from "./payment_provider";

export class MockPaymentProvider implements PaymentProvider
{
  readonly name = "mock";
  async createPayment({
    bookingId,
  }: {
    amountCents: number;
    currency: string;
    bookingId: string;
    studentId: string;
  }) {
    return {
      providerPaymentId: `mock-${bookingId}`,
      checkoutUrl: `https://example.com/pay/${bookingId}`,
    };
  }
}
