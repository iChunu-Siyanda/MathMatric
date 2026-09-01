import 'package:equatable/equatable.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';

class RequestBookingEntity extends Equatable {
  final String tutorId;
  final DateTime scheduledAt;
  final int durationMinutes;
  final TeachingMode teachingMode;

  const RequestBookingEntity({
    required this.tutorId,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.teachingMode,
  });

  @override
  List<Object?> get props => [
    tutorId,
    scheduledAt,
    durationMinutes,
    teachingMode,
  ];
}
