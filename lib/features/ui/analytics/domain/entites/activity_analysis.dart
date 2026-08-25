import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';

class ActivityAnalytics {
  final StudyActivity activity;
  final int totalMinutes;

  const ActivityAnalytics({
    required this.activity,
    required this.totalMinutes,
  });
}
