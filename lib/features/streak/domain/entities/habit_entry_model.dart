

import 'package:math_matric/features/streak/domain/entities/activities.dart';

class HabitEntry {
  final DateTime date; // normalized date (YYYY-MM-DD)
  final int studyMinutes;
  final List<StudyActivity> activities;

  const HabitEntry({
    required this.date,
    required this.studyMinutes,
    required this.activities,
  });
}
