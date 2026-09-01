import 'package:equatable/equatable.dart';

sealed class BookingCancellationEvent extends Equatable{
  const BookingCancellationEvent();

  @override
  List<Object?> get props => [];
}

class BookingCancellationRequested extends BookingCancellationEvent {
  final String bookingId;

  const BookingCancellationRequested({
    required this.bookingId,
  });

  @override
  List<Object?> get props => [bookingId];
}

class BookingCancellationReset extends BookingCancellationEvent {
  const BookingCancellationReset();

   @override
  List<Object?> get props => [];
}
