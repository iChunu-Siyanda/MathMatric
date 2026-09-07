import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_payment_use_case.dart';
import '../../domain/usecases/initiate_payment_use_case.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitiatePaymentUseCase initiatePayment;
  final GetPaymentUseCase getPayment;

  PaymentBloc({
    required this.initiatePayment,
    required this.getPayment,
  }) : super(const PaymentInitial()) {
    on<InitiatePaymentRequested>(_onInitiatePaymentRequested,);
    on<PaymentRequested>(_onPaymentRequested,);
    on<PaymentReset>(_onPaymentReset,);
  }

  Future<void> _onInitiatePaymentRequested(
    InitiatePaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());

    try {
      final payment = await initiatePayment(bookingId: event.bookingId,);

      emit(PaymentLoaded(payment: payment,),);
    } catch (error) {
      emit(PaymentFailure(message: _errorMessage(error),),);
    }
  }

  Future<void> _onPaymentRequested(
    PaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());

    try {
      final payment = await getPayment(paymentId: event.paymentId,);

      if (payment == null) {
        emit(const PaymentNotFound());
        return;
      }

      emit(PaymentLoaded(payment: payment,),);
    } catch (error) {
      emit(PaymentFailure(message: _errorMessage(error),),);
    }
  }

  void _onPaymentReset(
    PaymentReset event,
    Emitter<PaymentState> emit,
  ) {
    emit(const PaymentInitial());
  }

  String _errorMessage(Object error) {
    return error.toString();
  }
}
