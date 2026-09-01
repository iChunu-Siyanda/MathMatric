import 'package:equatable/equatable.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/request_booking_entity.dart';

sealed class BookingRequestEvent extends Equatable {
  const BookingRequestEvent();

  @override
  List<Object?> get props => [];
}

final class BookingRequestSubmittedEvent extends BookingRequestEvent {
  final RequestBookingEntity request;

  const BookingRequestSubmittedEvent({required this.request,});

  @override
  List<Object?> get props => [request];
}

final class BookingRequestReset extends BookingRequestEvent {
  const BookingRequestReset();
}
