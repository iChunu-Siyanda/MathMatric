

import 'package:math_matric/routes/papers/resources/my_progress/models/activities.dart';

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
