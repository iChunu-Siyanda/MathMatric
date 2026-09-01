import 'package:math_matric/features/marketplace/booking/domain/entities/booking_entity.dart';

sealed class BookingHistoryState {
  const BookingHistoryState();
}

class BookingHistoryInitial extends BookingHistoryState {
  const BookingHistoryInitial();
}

class BookingHistoryLoading extends BookingHistoryState {
  const BookingHistoryLoading();
}

class BookingHistoryLoaded extends BookingHistoryState {
  final List<BookingEntity> bookings;

  const BookingHistoryLoaded({
    required this.bookings,
  });
}

class BookingHistoryError extends BookingHistoryState {
  final String message;

  const BookingHistoryError(
    this.message,
  );
}
