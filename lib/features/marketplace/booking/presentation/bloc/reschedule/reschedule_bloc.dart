import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/reschedule_booking_use_case.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/reschedule/reschedule_booking_event.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/reschedule/reschedule_booking_state.dart';

class RescheduleBookingBloc extends Bloc<RescheduleBookingEvent,RescheduleBookingState> {
  final RescheduleBookingUseCase rescheduleBooking;

  RescheduleBookingBloc({
    required this.rescheduleBooking,
  }) : super(const RescheduleBookingInitial(),) {
    on<RescheduleBookingRequested>(_onRequested,);
    on<RescheduleBookingReset>(_onReset,);
  }

  Future<void> _onRequested(
    RescheduleBookingRequested event,
    Emitter<RescheduleBookingState> emit,
  ) async {
    emit(
      const RescheduleBookingInProgress(),
    );

    try {
      final booking = await rescheduleBooking(event.request,);

      emit(RescheduleBookingSuccess(booking: booking,),);
    } catch (e) {
      emit(RescheduleBookingError(e.toString(),),);
    }
  }

  void _onReset(
    RescheduleBookingReset event,
    Emitter<RescheduleBookingState> emit,
  ) {
    emit(const RescheduleBookingInitial(),);
  }
}
