import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/daily_chart_data.dart';

class ChartTimeFrameDataCalculator {
  const ChartTimeFrameDataCalculator();
  
  List<DailyChartData> calculate({
    required List<StudySessionEntity> sessions,
    required DateTime today,
    required AnalyticsTimeframe timeframe,
  }) {
    final normalizedToday = DateTime(
      today.year,
      today.month,
      today.day,
    );

    int? days;

    switch (timeframe) {
      case AnalyticsTimeframe.days7:
        days = 7;
        break;

      case AnalyticsTimeframe.days30:
        days = 30;
        break;

      case AnalyticsTimeframe.allTime:
        days = null;
        break;
    }

    // All Time
    if (days == null) {
      if (sessions.isEmpty) {
        return [];
      }

      final completedSessions = sessions
          .where((session) => session.endedAt != null)
          .toList();

      if (completedSessions.isEmpty) {
        return [];
      }

      final earliestSession = completedSessions
          .map(
            (session) => DateTime(
              session.startedAt.year,
              session.startedAt.month,
              session.startedAt.day,
            ),
          )
          .reduce(
            (a, b) => a.isBefore(b) ? a : b,
          );

      days = normalizedToday
              .difference(earliestSession)
              .inDays +
          1;
    }

    final result = List.generate(
      days,
      (index) {
        final date = normalizedToday.subtract(
          Duration(days: days! - 1 - index),
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

      final date = DateTime(
        session.startedAt.year,
        session.startedAt.month,
        session.startedAt.day,
      );

      final index = result.indexWhere(
        (item) => item.date == date,
      );

      if (index == -1) continue;

      final current = result[index];

      result[index] = DailyChartData(
        date: current.date,
        minutes: current.minutes +
            session.endedAt!
                .difference(session.startedAt)
                .inMinutes,
        correctAnswers:
            current.correctAnswers +
                session.correctAnswers,
        totalQuestions:
            current.totalQuestions +
                session.questionsAnswered,
      );
    }

    return result;
  }
}
