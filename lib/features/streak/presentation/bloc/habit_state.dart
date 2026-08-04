import 'package:math_matric/features/streak/domain/entities/habit_summary.dart';

sealed class HabitState {
  const HabitState();
}

final class HabitInitial extends HabitState {
  const HabitInitial();
}

final class HabitLoading extends HabitState {
  const HabitLoading();
}

final class HabitLoaded extends HabitState {
  final HabitSummary summary;

  const HabitLoaded(this.summary);
  
  int get currentStreak => summary.currentStreak;
  int get longestStreak => summary.longestStreak;
  int get weeklyProgressScore => summary.weeklyProgressScore;
}

final class HabitFailure extends HabitState {
  final Object error;

  const HabitFailure(this.error);
}
