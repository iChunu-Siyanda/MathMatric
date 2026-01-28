import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:math_matric/features/streak/presentation/bloc/habit_bloc.dart';
import 'package:math_matric/features/streak/presentation/bloc/habit_event.dart';
import 'package:math_matric/features/streak/presentation/bloc/habit_state.dart';
import 'package:math_matric/features/streak/domain/usercase/habit_entry_helper.dart';
import 'package:math_matric/features/streak/domain/entities/activities.dart';
import 'package:math_matric/features/streak/domain/entities/habit_entry_model.dart';

// Helper to create normalized HabitEntry
HabitEntry createEntry({
  required DateTime date,
  int minutes = 0,
  List<StudyActivity> activities = const [],
}) {
  return HabitEntry(
    date: normalizeDate(date),
    studyMinutes: minutes,
    activities: activities,
  );
}

// Fixed today for testing
final testToday = DateTime(2026, 1, 10);

void main() {
  group('HabitBloc Tests', () {
    blocTest<HabitBloc, HabitState>(
      'initial state is correct',
      build: () => HabitBloc(),
      verify: (bloc) {
        expect(bloc.state.entries, []);
        expect(bloc.state.currentStreak, 0);
        expect(bloc.state.longestStreak, 0);
        expect(bloc.state.weeklyProgressScore, 0);
      },
    );

    // blocTest<HabitBloc, HabitState>(
    //   'emits updated streak when entries are logged',
    //   build: () => HabitBloc(),
    //   act: (bloc) {
    //     bloc.add(HabitEntryLogged(createEntry(date: testToday, minutes: 30)));
    //     bloc.add(HabitEntryLogged(createEntry(date: testToday.subtract(const Duration(days: 1)), minutes: 30)));
    //   },
    //   skip: 1, // skip initial state
    //   expect: () => [
    //     isA<HabitState>().having((s) => s.currentStreak, 'currentStreak', 1),
    //     isA<HabitState>().having((s) => s.currentStreak, 'currentStreak', 2),
    //   ],
    // );

    blocTest<HabitBloc, HabitState>(
      'emits updated streak when entries are logged',
      build: () => HabitBloc(),
      act: (bloc) {
        bloc.add(
          HabitEntryLogged(
            createEntry(
              date: testToday.subtract(const Duration(days: 1)),
              minutes: 30,
            ),
          ),
        );
        bloc.add(HabitEntryLogged(createEntry(date: testToday, minutes: 30)));
      },
      verify: (bloc) {
        expect(bloc.state.currentStreak, 2);
      },
    );

    blocTest<HabitBloc, HabitState>(
      'current streak resets when a day is missed',
      build: () => HabitBloc(),
      act: (bloc) {
        bloc.add(HabitEntryLogged(createEntry(date: testToday, minutes: 30)));
        bloc.add(
          HabitEntryLogged(
            createEntry(
              date: testToday.subtract(const Duration(days: 2)),
              minutes: 30,
            ),
          ),
        );
      },
      skip: 1, // skip initial state
      expect: () => [
        // Only the final state matters here
        isA<HabitState>().having((s) => s.currentStreak, 'currentStreak', 1),
      ],
    );

    blocTest<HabitBloc, HabitState>(
      'calculates weekly progress score correctly',
      build: () => HabitBloc(),
      act: (bloc) {
        final entries = [
          createEntry(date: testToday, minutes: 30),
          createEntry(
            date: testToday.subtract(const Duration(days: 1)),
            minutes: 30,
          ),
          createEntry(
            date: testToday.subtract(const Duration(days: 2)),
            minutes: 30,
          ),
          createEntry(
            date: testToday.subtract(const Duration(days: 3)),
            minutes: 30,
          ),
        ];

        for (final e in entries) {
          bloc.add(HabitEntryLogged(e));
        }
      },
      skip: 4, // skip intermediate emissions
      verify: (bloc) {
        final weeklyScore = calculateWeeklyProgressScore(
          bloc.state.entries,
          today: testToday,
        );
        expect(weeklyScore, 57);
      },
    );

    blocTest<HabitBloc, HabitState>(
      'calculates longest streak correctly',
      build: () => HabitBloc(),
      act: (bloc) {
        final entries = [
          createEntry(date: DateTime(2026, 1, 1), minutes: 30),
          createEntry(date: DateTime(2026, 1, 2), minutes: 30),
          createEntry(date: DateTime(2026, 1, 4), minutes: 30),
          createEntry(date: DateTime(2026, 1, 5), minutes: 30),
          createEntry(date: DateTime(2026, 1, 6), minutes: 30),
        ];

        for (final e in entries) {
          bloc.add(HabitEntryLogged(e));
        }
      },
      skip: 5,
      verify: (bloc) {
        expect(bloc.state.longestStreak, 3);
      },
    );
  });
}
