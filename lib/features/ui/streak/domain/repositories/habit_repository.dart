import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';
import 'package:math_matric/features/ui/streak/domain/entities/habit_summary.dart';
import 'package:math_matric/features/ui/streak/domain/mapper/habit_entry_mapper.dart';
import 'package:math_matric/features/ui/streak/domain/usercase/habit_entry_helper.dart';

class HabitRepository {
  HabitRepository(this._studySessionRepository,);
  final StudySessionRepository _studySessionRepository;

  Stream<HabitSummary> watchSummary() {
    return _studySessionRepository.watchStudySessions().map((sessions) {
      final model = sessions.map((m) => m.toDrift()).toList();
      final entries = HabitEntryMapper.fromStudySessions(model);

      return HabitSummary(
        currentStreak: calculateCurrentStreak(entries),
        longestStreak: calculateLongestStreak(entries),
        weeklyProgressScore: calculateWeeklyProgressScore(entries),
      );
    });
  }
}
