import 'package:math_matric/shared/entities/payment_status.dart';

class PaymentEntity {
  final String id;
  final String bookingId;
  final String studentId;
  final String tutorId;

  final int amountCents;
  final String currency;

  final PaymentStatus status;

  final String? provider;
  final String? providerPaymentId;

  final DateTime createdAt;
  final DateTime updatedAt;

  final DateTime? paidAt;
  final String? failureReason;

  const PaymentEntity({
    required this.id,
    required this.bookingId,
    required this.studentId,
    required this.tutorId,
    required this.amountCents,
    required this.currency,
    required this.status,
    required this.provider,
    required this.providerPaymentId,
    required this.createdAt,
    required this.updatedAt,
    required this.paidAt,
    required this.failureReason,
  });
}
