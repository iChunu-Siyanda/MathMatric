import 'package:math_matric/features/marketplace/payments/domain/entities/payment_checkout_entity.dart';
import 'package:math_matric/features/marketplace/payments/domain/entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<PaymentCheckoutEntity> initiatePayment({
    required String bookingId,
  });

  Future<PaymentEntity?> getPayment({
    required String paymentId,
  });
}
