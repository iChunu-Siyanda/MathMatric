import 'package:equatable/equatable.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_entity.dart';

sealed class RescheduleBookingState extends Equatable {
  const RescheduleBookingState();

  @override
  List<Object?> get props => [];
}

final class RescheduleBookingInitial extends RescheduleBookingState {
  const RescheduleBookingInitial();
}

final class RescheduleBookingInProgress extends RescheduleBookingState {
  const RescheduleBookingInProgress();
}

class RescheduleBookingSuccess extends RescheduleBookingState {
  final BookingEntity booking;

  const RescheduleBookingSuccess({
    required this.booking,
  });

  @override
  List<Object?> get props => [booking];
}

final class RescheduleBookingError extends RescheduleBookingState {
  final String message;

  const RescheduleBookingError(
    this.message,
  );

  @override
  List<Object?> get props => [message];
}
