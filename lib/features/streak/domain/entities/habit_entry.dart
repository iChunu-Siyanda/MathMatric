import 'package:math_matric/features/streak/domain/entities/activities.dart';

class HabitEntry {
  final DateTime date; // normalized date (YYYY-MM-DD)
  final int totalStudyMinutes;
  final Set<StudyActivity> activities;

  const HabitEntry({
    required this.date,
    required this.totalStudyMinutes,
    required this.activities,
  });
}
