import 'package:math_matric/features/marketplace/payments/domain/entities/payment_entity.dart';
import 'package:math_matric/features/marketplace/payments/domain/repositories/payment_repository.dart';

class GetPaymentUseCase {
  final PaymentRepository repository;
  const GetPaymentUseCase(this.repository);

  Future<PaymentEntity?> call({
    required String paymentId,
  }) {
    return repository.getPayment(paymentId: paymentId);
  }
}
