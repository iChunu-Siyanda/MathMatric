import 'package:math_matric/features/streak/domain/entities/habit_summary.dart';

sealed class HabitEvent {
  const HabitEvent();
}

final class HabitStarted extends HabitEvent {
  const HabitStarted();
}

final class HabitSummaryUpdated extends HabitEvent {
  const HabitSummaryUpdated(this.summary);

  final HabitSummary summary;
}
