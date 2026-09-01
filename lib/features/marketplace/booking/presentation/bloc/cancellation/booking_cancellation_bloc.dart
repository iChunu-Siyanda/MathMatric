import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/cancel_booking.dart';
import 'booking_cancellation_event.dart';
import 'booking_cancellation_state.dart';

class BookingCancellationBloc extends Bloc<BookingCancellationEvent,BookingCancellationState> {
  final CancelBooking cancelBooking;

  BookingCancellationBloc({
    required this.cancelBooking,
  }) : super(const BookingCancellationInitial(),) {
    on<BookingCancellationRequested>(_onCancellationRequested,);
    on<BookingCancellationReset>(_onReset,);
  }

  Future<void> _onCancellationRequested(
    BookingCancellationRequested event,
    Emitter<BookingCancellationState> emit,
  ) async {
    emit(const BookingCancellationInProgress(),);

    try {
      await cancelBooking(event.bookingId,);

      emit(BookingCancellationSuccess(bookingId: event.bookingId,),
      );
    } catch (e) {
      emit(BookingCancellationError(e.toString(),),);
    }
  }

  void _onReset(
    BookingCancellationReset event,
    Emitter<BookingCancellationState> emit,
  ) {
    emit(const BookingCancellationInitial(),);
  }
}

// When cancellation succeeds, MyBookingsPage needs to reflect the new status. 
//Since we've parked realtime streams, 
//for now the page can refresh/reload its bookings after:
// BookingCancellationSuccess
