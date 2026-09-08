import 'package:equatable/equatable.dart';
import 'package:math_matric/features/marketplace/payments/domain/entities/payment_checkout_entity.dart';
import '../../domain/entities/payment_entity.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

final class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

final class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

final class PaymentLoaded extends PaymentState {
  final PaymentEntity payment;

  const PaymentLoaded({
    required this.payment,
  });

  @override
  List<Object?> get props => [payment];
}

final class PaymentCheckoutLoaded extends PaymentState {
  final PaymentCheckoutEntity checkout;

  const PaymentCheckoutLoaded({
    required this.checkout,
  });

  @override
  List<Object?> get props => [checkout];
}

final class PaymentNotFound extends PaymentState {
  const PaymentNotFound();
}

final class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
