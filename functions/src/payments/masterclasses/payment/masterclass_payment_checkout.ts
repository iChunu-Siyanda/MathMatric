import { MasterclassPayment } from "./masterclass_payment_entity";

export interface MasterclassPaymentCheckout {
  payment: MasterclassPayment;
  provider: string;
  providerPaymentId: string;
  checkoutUrl: string;
}
