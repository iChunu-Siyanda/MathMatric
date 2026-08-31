import 'package:equatable/equatable.dart';

class AvailableSlot extends Equatable {
  final DateTime start;
  final DateTime end;

  const AvailableSlot({
    required this.start,
    required this.end,
  });

  @override
  List<Object?> get props => [
    start,
    end,
  ];
}

sealed class AvailabilityState extends Equatable {
  const AvailabilityState();

  @override
  List<Object?> get props => [];
}

final class AvailabilityInitial extends AvailabilityState {
  const AvailabilityInitial();
}

final class AvailabilityLoading extends AvailabilityState {
  const AvailabilityLoading();
}

final class AvailabilityLoaded extends AvailabilityState {
  final String tutorId;
  final DateTime date;
  final int durationMinutes;
  final List<AvailableSlot> slots;

  const AvailabilityLoaded({
    required this.tutorId,
    required this.date,
    required this.durationMinutes,
    required this.slots,
  });

  @override
  List<Object?> get props => [
    tutorId,
    date,
    durationMinutes,
    slots,
  ];
}

final class AvailabilityError extends AvailabilityState {
  final String message;

  const AvailabilityError(
    this.message,
  );

  @override
  List<Object?> get props => [message];
}
