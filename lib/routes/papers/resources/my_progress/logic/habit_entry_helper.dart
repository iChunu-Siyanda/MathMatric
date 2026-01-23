//“Does this day count as a study day?”
import 'package:math_matric/routes/papers/resources/my_progress/models/activities.dart';
import 'package:math_matric/routes/papers/resources/my_progress/models/habit_entry_model.dart';

bool isValidStudyDay(HabitEntry entry) {
  final hasEnoughTime = entry.studyMinutes >= 20;

  final hasMeaningfulActivity = entry.activities.contains(StudyActivity.practice) ||
      entry.activities.contains(StudyActivity.pastPapers);

  return hasEnoughTime || hasMeaningfulActivity;
}

//Streaks break if dates are not normalized. So use:
DateTime normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

//Convert entries to a date look up. Use a map for O(1):
Map<DateTime, HabitEntry> mapEntriesByDate(List<HabitEntry> entries) {
  return {
    for (final entry in entries) normalizeDate(entry.date): entry,
  };
} //missing date = not studied

//Calculation of current streak
int calculateCurrentStreak(
  List<HabitEntry> entries, {
  DateTime? today,
}) {
  final normalizedToday = normalizeDate(today ?? DateTime.now());
  final entryMap = mapEntriesByDate(entries);

  int streak = 0;
  DateTime currentDay = normalizedToday;

  while (true) {
    final entry = entryMap[currentDay];

    if (entry == null || !isValidStudyDay(entry)) {
      break;
    }

    streak++;
    currentDay = currentDay.subtract(const Duration(days: 1));
  }

  return streak;
}

//longest streak calculation
int calculateLongestStreak(List<HabitEntry> entries) {
  if (entries.isEmpty) return 0;

  final entryMap = mapEntriesByDate(entries);
  final sortedDates = entryMap.keys.toList()..sort();

  int longest = 0;
  int current = 0;
  DateTime? previousDay;

  for (final date in sortedDates) {
    final entry = entryMap[date]!;

    if (!isValidStudyDay(entry)) {
      current = 0;
      previousDay = null;
      continue;
    }

    if (previousDay == null ||
        date.difference(previousDay).inDays == 1) {
      current++;
    } else {
      current = 1;
    }

    longest = longest > current ? longest : current;
    previousDay = date;
  }

  return longest;
}

//Weekly progress calculation, based on 7 days.
int calculateWeeklyProgressScore(
  List<HabitEntry> entries, {
  DateTime? today,
}) {
  final normalizedToday = normalizeDate(today ?? DateTime.now());
  final entryMap = mapEntriesByDate(entries);

  int studiedDays = 0;

  for (int i = 0; i < 7; i++) {
    final date = normalizedToday.subtract(Duration(days: i));
    final entry = entryMap[date];

    if (entry != null && isValidStudyDay(entry)) {
      studiedDays++;
    }
  }

  return ((studiedDays / 7) * 100).round();
}
