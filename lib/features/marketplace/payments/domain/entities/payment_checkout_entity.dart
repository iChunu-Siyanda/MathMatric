import 'payment_entity.dart';

class PaymentCheckoutEntity {
  final PaymentEntity payment;
  final String provider;
  final String providerPaymentId;
  final String checkoutUrl;

  const PaymentCheckoutEntity({
    required this.payment,
    required this.provider,
    required this.providerPaymentId,
    required this.checkoutUrl,
  });
}
