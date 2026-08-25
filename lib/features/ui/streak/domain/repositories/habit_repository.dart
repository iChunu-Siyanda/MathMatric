import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';
import 'package:math_matric/features/ui/streak/domain/entities/habit_summary.dart';
import 'package:math_matric/features/ui/streak/domain/mapper/habit_entry_mapper.dart';
import 'package:math_matric/features/ui/streak/domain/usercase/habit_entry_helper.dart';
import 'package:math_matric/shared/services/app_clock.dart';

class HabitRepository {
  final StudySessionRepository _studySessionRepository;
  final AppClock _clock;

  HabitRepository(
    this._studySessionRepository,
    this._clock,
  );
    

  Stream<HabitSummary> watchSummary() {
    return _studySessionRepository.watchStudySessions().map((sessions) {
      final model = sessions.map((m) => m.toDrift()).toList();
      final entries = HabitEntryMapper.fromStudySessions(model);
      final today = _clock.now();

      return HabitSummary(
        currentStreak: calculateCurrentStreak(entries,today: today,),
        longestStreak: calculateLongestStreak(entries),
        weeklyProgressScore: calculateWeeklyProgressScore(entries, today: today,),
      );
    });
  }
}
