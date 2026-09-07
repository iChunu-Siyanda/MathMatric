import 'package:equatable/equatable.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

final class InitiatePaymentRequested extends PaymentEvent {
  final String bookingId;

  const InitiatePaymentRequested({
    required this.bookingId,
  });

  @override
  List<Object?> get props => [bookingId];
}

final class PaymentRequested extends PaymentEvent {
  final String paymentId;

  const PaymentRequested({
    required this.paymentId,
  });

  @override
  List<Object?> get props => [paymentId];
}

final class PaymentReset extends PaymentEvent {
  const PaymentReset();
}
