import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/get_student_bookings.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/history/booking_history_event.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/history/booking_history_state.dart';

class BookingHistoryBloc extends Bloc<BookingHistoryEvent,BookingHistoryState> {
  final GetStudentBookings getStudentBookings;
  final String studentId;

  BookingHistoryBloc({
    required this.getStudentBookings,
    required this.studentId,
  }) : super(const BookingHistoryInitial(),) {
    on<BookingHistoryRequested>(_onRequested,);
    on<BookingHistoryRefreshRequested>( _onRefreshRequested,);
  }

  Future<void> _onRequested(
    BookingHistoryRequested event,
    Emitter<BookingHistoryState> emit,
  ) async {
    emit(const BookingHistoryLoading(),);

    try {
      final bookings =await getStudentBookings(studentId: studentId,);

      emit(BookingHistoryLoaded(bookings: bookings,),);
    } catch (e) {
      emit(BookingHistoryError(e.toString(),),);
    }
  }

  Future<void> _onRefreshRequested(
    BookingHistoryRefreshRequested event,
    Emitter<BookingHistoryState> emit,
  ) async {
    try {
      final bookings = await getStudentBookings(studentId: studentId,);

      emit(BookingHistoryLoaded(bookings: bookings,),);
    } catch (e) {
      emit(BookingHistoryError(e.toString(),),
      );
    }
  }
}

// Should be able to request a slip:

// Tutor
// ────────────
// Name
// Photo
// Rating

// Lesson
// ────────────
// Mathematics
// Date
// Start time
// Duration
// Online / In-person

// Price
// ────────────
// R350

// Status
// ────────────
// Awaiting tutor

// Actions
// ────────────
// Cancel request
