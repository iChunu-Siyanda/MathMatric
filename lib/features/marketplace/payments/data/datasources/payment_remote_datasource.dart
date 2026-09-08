import 'package:math_matric/features/marketplace/payments/data/models/payment_model.dart';
import 'package:math_matric/features/marketplace/payments/domain/entities/payment_checkout_entity.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentCheckoutEntity> initiatePayment({
    required String bookingId,
  });

  Future<PaymentModel?> getPayment({
    required String paymentId,
  });
}
