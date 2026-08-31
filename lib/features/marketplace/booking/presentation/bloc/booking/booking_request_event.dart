import 'package:equatable/equatable.dart';
import '../../../domain/entities/booking_entity.dart';

sealed class BookingRequestEvent extends Equatable {
  const BookingRequestEvent();

  @override
  List<Object?> get props => [];
}

final class BookingRequestSubmittedEvent extends BookingRequestEvent {
  final BookingEntity booking;

  const BookingRequestSubmittedEvent({required this.booking,});

  @override
  List<Object?> get props => [booking];
}

final class BookingRequestReset extends BookingRequestEvent {
  const BookingRequestReset();
}
