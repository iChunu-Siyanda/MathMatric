import 'package:math_matric/features/marketplace/payments/domain/entities/payment_checkout_entity.dart';

import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  const PaymentRepositoryImpl({required this.remoteDataSource,});

  @override
  Future<PaymentCheckoutEntity> initiatePayment({
    required String bookingId,
  }) {
    return remoteDataSource.initiatePayment(
      bookingId: bookingId,
    );
  }

  @override
  Future<PaymentEntity?> getPayment({
    required String paymentId,
  }) {
    return remoteDataSource.getPayment(
      paymentId: paymentId,
    );
  }
}
