import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/streak/domain/entities/habit_entry.dart';
import 'package:math_matric/features/streak/domain/usercase/habit_entry_helper.dart';

class HabitEntryMapper {
  const HabitEntryMapper._();

  static List<HabitEntry> fromStudySessions(
    List<StudySessionData> sessions,
  ) {
    final grouped = <DateTime, List<StudySessionData>>{};

    for (final session in sessions) {
      final day = normalizeDate(session.startedAt);

      grouped.putIfAbsent(day, () => []);
      grouped[day]!.add(session);
    }

    return grouped.entries.map((group) {
      final sessions = group.value;

      return HabitEntry(
        date: group.key,
        totalStudyMinutes: sessions.fold(
          0,(sum, session) =>
            sum + session.endedAt.difference(session.startedAt).inMinutes,
        ),
        activities: sessions
            .map((e) => e.activity)
            .toSet(),
      );
    }).toList()
      ..sort(
        (a, b) => b.date.compareTo(a.date),
      );
  }
}
