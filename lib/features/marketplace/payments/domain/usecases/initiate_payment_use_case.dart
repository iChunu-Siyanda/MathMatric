import 'package:math_matric/features/marketplace/payments/domain/entities/payment_entity.dart';
import 'package:math_matric/features/marketplace/payments/domain/repositories/payment_repository.dart';

class InitiatePaymentUseCase {
  final PaymentRepository repository;

  const InitiatePaymentUseCase(this.repository);

  Future<PaymentEntity> call({
    required String bookingId,
  }) {
    return repository.initiatePayment(
      bookingId: bookingId,
    );
  }
}
