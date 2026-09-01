import 'package:equatable/equatable.dart';

sealed class BookingCancellationState extends Equatable{
  const BookingCancellationState();

  @override
  List<Object?> get props => [];
}

class BookingCancellationInitial extends BookingCancellationState {
  const BookingCancellationInitial();
}

class BookingCancellationInProgress extends BookingCancellationState {
  const BookingCancellationInProgress();
}

class BookingCancellationSuccess extends BookingCancellationState {
  final String bookingId;

  const BookingCancellationSuccess({required this.bookingId,});

   @override
  List<Object?> get props => [bookingId];
}

class BookingCancellationError extends BookingCancellationState {
  final String message;

  const BookingCancellationError(this.message,);

   @override
  List<Object?> get props => [message];
}
