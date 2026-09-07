import 'package:math_matric/shared/entities/payment_status.dart';
import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.bookingId,
    required super.studentId,
    required super.tutorId,
    required super.amountCents,
    required super.currency,
    required super.status,
    required super.provider,
    required super.providerPaymentId,
    required super.createdAt,
    required super.updatedAt,
    required super.paidAt,
    required super.failureReason,
  });

  factory PaymentModel.fromFirestore(
    Map<String, dynamic> map,
  ) {
    return PaymentModel(
      id: map['id'] as String,
      bookingId: map['bookingId'] as String,
      studentId: map['studentId'] as String,
      tutorId: map['tutorId'] as String,
      amountCents: map['amountCents'] as int,
      currency: map['currency'] as String,
      status: _statusFromString(
        map['status'] as String,
      ),
      provider: map['provider'] as String?,
      providerPaymentId:
          map['providerPaymentId'] as String?,
      createdAt: (map['createdAt'] as dynamic).toDate(),
      updatedAt: (map['updatedAt'] as dynamic).toDate(),
      paidAt: map['paidAt'] == null
          ? null
          : (map['paidAt'] as dynamic).toDate(),
      failureReason:
          map['failureReason'] as String?,
    );
  }

  static PaymentStatus _statusFromString(String value) {
  switch (value) {
    case 'pending':
      return PaymentStatus.pending;
    case 'processing':
      return PaymentStatus.processing;
    case 'paid':
      return PaymentStatus.paid;
    case 'failed':
      return PaymentStatus.failed;
    case 'cancelled':
      return PaymentStatus.cancelled;
    case 'refunded':
      return PaymentStatus.refunded;
    case 'partially_refunded':
      return PaymentStatus.partiallyRefunded;
    default:
      throw FormatException(
        'Unknown payment status: $value',
      );
  }
}
}
