import 'package:equatable/equatable.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/reschedule_booking_entity.dart';

sealed class RescheduleBookingEvent extends Equatable {
  const RescheduleBookingEvent();

  @override
  List<Object?> get props => [];
}

final class RescheduleBookingRequested extends RescheduleBookingEvent {
  final RescheduleBookingEntity request;

  const RescheduleBookingRequested(
    this.request,
  );

  @override
  List<Object?> get props => [request];
}

final class RescheduleBookingReset extends RescheduleBookingEvent {
  const RescheduleBookingReset();
}
