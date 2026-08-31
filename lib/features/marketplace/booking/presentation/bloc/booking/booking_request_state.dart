import 'package:equatable/equatable.dart';
import '../../../domain/entities/booking_entity.dart';

sealed class BookingRequestState extends Equatable {
  const BookingRequestState();

  @override
  List<Object?> get props => [];
}

final class BookingRequestInitial extends BookingRequestState {
  const BookingRequestInitial();
}

final class BookingRequestSubmitting extends BookingRequestState {
  const BookingRequestSubmitting();
}

final class BookingRequestSubmittedState extends BookingRequestState {
  final BookingEntity booking;

  const BookingRequestSubmittedState({required this.booking,});

  @override
  List<Object?> get props => [booking];
}

final class BookingRequestError extends BookingRequestState {
  final String message;

  const BookingRequestError(this.message,);

  @override
  List<Object?> get props => [message];
}
