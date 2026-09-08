import { Payment } from "./payment_entity";

export interface PaymentCheckout {
  payment: Payment;
  provider: string;
  providerPaymentId: string;
  checkoutUrl: string;
}
