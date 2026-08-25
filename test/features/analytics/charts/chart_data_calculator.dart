import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/daily_chart_data.dart';

class ChartDataCalculator {
  const ChartDataCalculator();

  List<DailyChartData> calculate({
    required List<StudySessionEntity> sessions,
    required DateTime today,
    required int days,
  }) {
    final normalizedToday = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final result = List.generate(
      days,
      (index) {
        final date = normalizedToday.subtract(
          Duration(days: days - 1 - index),
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
            current.correctAnswers + session.correctAnswers,
        totalQuestions:
            current.totalQuestions + session.questionsAnswered,
      );
    }

    return result;
  }
}
