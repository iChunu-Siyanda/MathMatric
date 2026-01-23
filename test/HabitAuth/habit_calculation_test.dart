import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/routes/papers/resources/my_progress/logic/habit_entry_helper.dart';
import 'package:math_matric/routes/papers/resources/my_progress/models/activities.dart';
import 'package:math_matric/routes/papers/resources/my_progress/models/habit_entry_model.dart';

// Helper to create normalized HabitEntry
HabitEntry entry({
  required DateTime date,
  int minutes = 0,
  List<StudyActivity> activities = const [],
}) {
  return HabitEntry(
    date: normalizeDate(date), // must match BLoC normalization
    studyMinutes: minutes,
    activities: activities,
  );
}

// Fixed today for testing
final testToday = DateTime(2026, 1, 10);

void main() {
  // Test valid study day rules
  group('isValidStudyDay', () {
    test('returns true when studyMinutes >= 20', () {
      final e = entry(date: testToday, minutes: 25);
      expect(isValidStudyDay(e), true);
    });

    test('returns true when practice activity exists', () {
      final e = entry(date: testToday, activities: [StudyActivity.practice]);
      expect(isValidStudyDay(e), true);
    });

    test('returns false for notes only with low minutes', () {
      final e = entry(date: testToday, minutes: 10, activities: [StudyActivity.notes]);
      expect(isValidStudyDay(e), false);
    });
  });

  // Test current streak
  group('calculateCurrentStreak', () {
    test('returns 0 when today is not studied', () {
      final entries = [entry(date: testToday.subtract(const Duration(days: 1)), minutes: 30)];
      final streak = calculateCurrentStreak(entries, today: testToday);
      expect(streak, 0);
    });

    test('counts consecutive days correctly', () {
      final entries = [
        entry(date: testToday, minutes: 30),
        entry(date: testToday.subtract(const Duration(days: 1)), minutes: 40),
        entry(date: testToday.subtract(const Duration(days: 2)), minutes: 25),
      ];
      final streak = calculateCurrentStreak(entries, today: testToday);
      expect(streak, 3);
    });

    test('breaks streak on missing day', () {
      final entries = [
        entry(date: testToday, minutes: 30),
        // missing yesterday
        entry(date: testToday.subtract(const Duration(days: 2)), minutes: 25),
      ];
      final streak = calculateCurrentStreak(entries, today: testToday);
      expect(streak, 1);
    });
  });

  // Test longest streak
  group('calculateLongestStreak', () {
    test('returns longest streak anywhere in history', () {
      final entries = [
        entry(date: DateTime(2026, 1, 1), minutes: 30),
        entry(date: DateTime(2026, 1, 2), minutes: 30),
        entry(date: DateTime(2026, 1, 4), minutes: 30),
        entry(date: DateTime(2026, 1, 5), minutes: 30),
        entry(date: DateTime(2026, 1, 6), minutes: 30),
      ];
      final longest = calculateLongestStreak(entries);
      expect(longest, 3); // Jan 4–6
    });
  });

  // Test weekly progress score
  group('calculateWeeklyProgressScore', () {
    test('calculates score over last 7 days', () {
      final entries = [
        entry(date: testToday, minutes: 30),
        entry(date: testToday.subtract(const Duration(days: 1)), minutes: 30),
        entry(date: testToday.subtract(const Duration(days: 2)), minutes: 30),
        entry(date: testToday.subtract(const Duration(days: 3)), minutes: 30),
      ];

      final score = calculateWeeklyProgressScore(entries, today: testToday);
      expect(score, 57); // 4/7 ≈ 57%
    });
  });
}
