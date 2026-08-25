import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/daily_chart_data.dart';

class DailyChartDataBuilder {
  static List<DailyChartData> build({
    required List<StudySessionEntity> sessions,
    required AnalyticsTimeframe timeframe,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final numberOfDays = switch (timeframe) {
      AnalyticsTimeframe.days7 => 7,
      AnalyticsTimeframe.days30 => 30,
      AnalyticsTimeframe.allTime => _calculateAllTimeDays(today, sessions),
    };

    final result = List.generate(
      numberOfDays,
      (index) {
        final date = today.subtract(
          Duration(days: numberOfDays - 1 - index),
        );

        return DailyChartData(
          date: date,
          minutes: 0,
          correctAnswers: 0,
          totalQuestions: 0,
        );
      },
    );

    for (final session in sessions) {
      if (session.endedAt == null) continue;

      final sessionDate = DateTime(
        session.startedAt.year,
        session.startedAt.month,
        session.startedAt.day,
      );

      final index = result.indexWhere((data) => data.date == sessionDate);
      if (index == -1) continue;

      final current = result[index];
      final duration = session.endedAt!
          .difference(session.startedAt)
          .inMinutes;

      result[index] = DailyChartData(
        date: current.date,
        minutes: current.minutes + duration,
        correctAnswers: current.correctAnswers + session.correctAnswers,
        totalQuestions: current.totalQuestions + session.questionsAnswered,
      );
    }

    return result;
  }

  static int _calculateAllTimeDays(DateTime today, List<StudySessionEntity> sessions) {
    if (sessions.isEmpty) return 7;

    final oldestSession = sessions
        .map((session) => session.startedAt)
        .reduce((a, b) => a.isBefore(b) ? a : b);

    final oldestDate = DateTime(
      oldestSession.year,
      oldestSession.month,
      oldestSession.day,
    );

    return today.difference(oldestDate).inDays + 1;
  }
}
