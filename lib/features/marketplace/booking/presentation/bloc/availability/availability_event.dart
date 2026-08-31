import 'package:equatable/equatable.dart';

sealed class AvailabilityEvent extends Equatable {
  const AvailabilityEvent();

  @override
  List<Object?> get props => [];
}

final class AvailabilityRequested extends AvailabilityEvent {
  final String tutorId;
  final DateTime date;
  final int durationMinutes;

  const AvailabilityRequested({
    required this.tutorId,
    required this.date,
    required this.durationMinutes,
  });

  @override
  List<Object?> get props => [
    tutorId,
    date,
    durationMinutes,
  ];
}

final class AvailabilityDateChanged extends AvailabilityEvent {
  final DateTime date;

  const AvailabilityDateChanged({
    required this.date,
  });

  @override
  List<Object?> get props => [date];
}

final class AvailabilityDurationChanged extends AvailabilityEvent {
  final int durationMinutes;

  const AvailabilityDurationChanged({
    required this.durationMinutes,
  });

  @override
  List<Object?> get props => [durationMinutes,];
}

final class AvailabilityRefreshRequested extends AvailabilityEvent {
  const AvailabilityRefreshRequested();
}
