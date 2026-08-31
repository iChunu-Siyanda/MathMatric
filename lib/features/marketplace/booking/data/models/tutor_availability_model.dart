import 'package:math_matric/features/marketplace/booking/domain/entities/availability_window.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/tutor_availability.dart';

class TutorAvailabilityModel extends TutorAvailability {
  const TutorAvailabilityModel({
    required super.tutorId,
    required super.timezone,
    required super.weeklySchedule,
  });

  factory TutorAvailabilityModel.fromFirestore(
    Map<String, dynamic> map,
  ) {
    final rawSchedule = Map<String, dynamic>.from(
      map['weeklySchedule'] ?? {},
    );
    final schedule = <int, List<AvailabilityWindow>>{};

    for (final entry in rawSchedule.entries) {
      final day = int.parse(entry.key);

      final windows = (entry.value as List).map(
        (item) => AvailabilityWindow(
          start: item['start'] as String,
          end: item['end'] as String,
        ),
      )
      .toList();

      schedule[day] = windows;
    }

    return TutorAvailabilityModel(
      tutorId: map['tutorId'] as String,
      timezone: map['timezone'] as String,
      weeklySchedule: schedule,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tutorId': tutorId,
      'timezone': timezone,
      'weeklySchedule': weeklySchedule.map(
        (day, windows) => MapEntry(
          day.toString(),
          windows.map(
            (window) => {
              'start': window.start,
              'end': window.end,
            },
          )
          .toList(),
        ),
      ),
    };
  }
}
