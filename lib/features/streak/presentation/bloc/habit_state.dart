//“What does the UI need to know right now?”
import 'package:math_matric/features/streak/domain/entities/habit_entry.dart';
import 'package:math_matric/features/streak/domain/entities/habit_summary.dart';

class HabitState {
  final List<HabitEntry> entries;
  final HabitSummary summary;

  const HabitState({required this.entries, required this.summary});

  factory HabitState.initial() {
    return HabitState(entries: const [], summary: HabitSummary.initial());
  }

  //copyWitn() creates a "modified clone" of your current HabitState, since it is immutable.
  HabitState copyWith({
    List<HabitEntry>? entries,
    HabitSummary ? summary,
    
  }) {
    return HabitState(
      entries: entries ?? this.entries,
      summary: summary ?? this.summary,
    );
  }
  
  int get currentStreak => summary.currentStreak;
  int get longestStreak => summary.longestStreak;
  int get weeklyProgressScore => summary.weeklyProgressScore;
}
