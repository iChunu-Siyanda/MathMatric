import 'package:math_matric/features/marketplace/payments/domain/entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<PaymentEntity> initiatePayment({
    required String bookingId,
  });

  Future<PaymentEntity?> getPayment({
    required String paymentId,
  });
}
