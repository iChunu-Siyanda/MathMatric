import 'package:equatable/equatable.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/availability_window.dart';

class TutorAvailability extends Equatable {
  final String tutorId;
  final String timezone;

  /// 1 = Monday ... 7 = Sunday
  final Map<int, List<AvailabilityWindow>> weeklySchedule;

  const TutorAvailability({
    required this.tutorId,
    required this.timezone,
    required this.weeklySchedule,
  });

  @override
  List<Object?> get props => [
    tutorId,
    timezone,
    weeklySchedule,
  ];
}
