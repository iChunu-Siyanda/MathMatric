import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/create_booking.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/booking/booking_request_event.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/booking/booking_request_state.dart';

class BookingRequestBloc extends Bloc<BookingRequestEvent, BookingRequestState> {
  final CreateBooking createBooking;

  BookingRequestBloc({
    required this.createBooking,
  }) : super(const BookingRequestInitial(),) {
    on<BookingRequestSubmittedEvent>(_onSubmitted,);
    on<BookingRequestReset>(_onReset,);
  }

  Future<void> _onSubmitted(
    BookingRequestSubmittedEvent event,
    Emitter<BookingRequestState> emit,
  ) async {
    emit(
      const BookingRequestSubmitting(),
    );

    try {
      final booking = await createBooking(
        event.booking,
      );

      emit(
        BookingRequestSubmittedState(
          booking: booking,
        ),
      );
    } catch (e) {
      emit(
        BookingRequestError(
          e.toString(),
        ),
      );
    }
  }

  void _onReset(
    BookingRequestReset event,
    Emitter<BookingRequestState> emit,
  ) {
    emit(
      const BookingRequestInitial(),
    );
  }
}
