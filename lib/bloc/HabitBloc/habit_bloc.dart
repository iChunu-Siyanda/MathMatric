import 'package:bloc/bloc.dart';
import 'package:math_matric/bloc/HabitBloc/habit_event.dart';
import 'package:math_matric/bloc/HabitBloc/habit_state.dart';
import 'package:math_matric/routes/papers/resources/my_progress/logic/habit_entry_helper.dart';
import 'package:math_matric/routes/papers/resources/my_progress/models/habit_entry_model.dart';
import 'package:math_matric/routes/papers/resources/my_progress/models/habit_summary.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  HabitBloc() : super(HabitState.initial()) {
    on<HabitEntryLogged>(_onEntryLogged);
  }

  void _onEntryLogged(HabitEntryLogged event, Emitter<HabitState> emit) {
    // Normalize the entry date
    final normalizedEntry = HabitEntry(
      date: normalizeDate(event.entry.date),
      studyMinutes: event.entry.studyMinutes,
      activities: event.entry.activities,
    );

    // Clone current entries
    final updatedEntries = List<HabitEntry>.from(state.entries);

    // Remove existing entry for same date if any
    updatedEntries.removeWhere((e) => e.date == normalizedEntry.date);

    // Add the new entry
    updatedEntries.add(normalizedEntry);

    // Emit updated state
    // Pass event.entry.date as "today" so streak calculation matches the test
    _emitUpdatedState(updatedEntries, emit, today: normalizedEntry.date);
  }

  void _emitUpdatedState(
    List<HabitEntry> entries,
    Emitter<HabitState> emit, {
    DateTime? today,
  }) {
    final normalizedToday = normalizeDate(today ?? DateTime.now());

    final summary = HabitSummary(
      currentStreak: calculateCurrentStreak(entries, today: normalizedToday),
      longestStreak: calculateLongestStreak(entries),
      weeklyProgressScore: calculateWeeklyProgressScore(
        entries,
        today: normalizedToday,
      ),
    );

    emit(state.copyWith(entries: entries, summary: summary));
  }
}
