import 'package:math_matric/features/marketplace/payments/data/models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> initiatePayment({
    required String bookingId,
  });

  Future<PaymentModel?> getPayment({
    required String paymentId,
  });
}
