import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/calculator/analytics_calculator.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/activity_analysis.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_chart_point.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/topic_progress_card_entity.dart';
import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';

extension AnalyticsCalculatorExtension on AnalyticsCalculator{
  DateTime? getCutoff(AnalyticsTimeframe timeframe) {
    final now = clock.now();

    switch (timeframe) {
      case AnalyticsTimeframe.days7:
        return now.subtract(const Duration(days: 7));

      case AnalyticsTimeframe.days30:
        return now.subtract(const Duration(days: 30));

      case AnalyticsTimeframe.allTime:
        return null;
    }
  }

  List<TopicProgressCardEntity> buildTopicProgressCards({
    required List<UserTopicProgressEntity> topics,
    required List<UserLevelProgressEntity> levels,
  }) {
    return topics.map((topic) {
      final topicLevels = levels
          .where((level) => level.topicId == topic.id)
          .toList();

      final completedCount = topicLevels.where((level) => level.completed).length;

      final averageBestScore = topicLevels.isEmpty
          ? 0.0
          : topicLevels
                  .map((level) => level.bestScore)
                  .reduce((a, b) => a + b) /
              topicLevels.length;

      DateTime? latestPlay;

      for (final level in topicLevels) {
        if (latestPlay == null ||
            level.lastPlayed.isAfter(latestPlay)) {
          latestPlay = level.lastPlayed;
        }
      }

      return TopicProgressCardEntity(
        topic: topic,
        totalLevels: topicLevels.length,
        completedLevels: completedCount,
        averageBestScore: averageBestScore,
        lastPlayed: latestPlay,
      );
    }).toList()
      ..sort(
        (a, b) => a.completionPercentage
            .compareTo(b.completionPercentage),
      );
  }

  List<AnalyticsChartPoint> buildStudyVolume({
    required List<StudySessionEntity> sessions,
  }) {
    final Map<DateTime, int> minutesByDay = {};

    for (final session in sessions) {
      if (session.endedAt == null) continue;

      final date = DateTime(
        session.startedAt.year,
        session.startedAt.month,
        session.startedAt.day,
      );

      final minutes = session.endedAt!
          .difference(session.startedAt)
          .inMinutes;

      minutesByDay[date] = (minutesByDay[date] ?? 0) + minutes;
    }

    final dates = minutesByDay.keys.toList()..sort();

    return dates.map((date) {
      return AnalyticsChartPoint(
        date: date,
        value: minutesByDay[date]!.toDouble(),
      );
    }).toList();
  }

  List<AnalyticsChartPoint> buildAccuracyTrend({
    required List<QuestionAttemptEntity> attempts,
  }) {
    final Map<DateTime, List<QuestionAttemptEntity>> attemptsByDay = {};

    for (final attempt in attempts) {
      final date = DateTime(
        attempt.answeredAt.year,
        attempt.answeredAt.month,
        attempt.answeredAt.day,
      );

      attemptsByDay.putIfAbsent(date, () => []);
      attemptsByDay[date]!.add(attempt);
    }

    final dates = attemptsByDay.keys.toList()..sort();

    return dates.map((date) {
      final dayAttempts = attemptsByDay[date]!;

      final correct = dayAttempts
          .where((attempt) => attempt.correct)
          .length;

      final accuracy = dayAttempts.isEmpty
          ? 0.0
          : (correct / dayAttempts.length) * 100;

      return AnalyticsChartPoint(
        date: date,
        value: accuracy,
      );
    }).toList();
  }

  int calculateTotalStudyMinutes(
    List<StudySessionEntity> sessions,
  ) {
    return sessions.fold(
      0,
      (total, session) {
        if (session.endedAt == null) return total;

        return total + session.endedAt!
              .difference(session.startedAt)
              .inMinutes;
      },
    );
  }

  int calculateTotalQuestionsAnswered(
    List<StudySessionEntity> sessions,
  ) {
    return sessions.fold(
      0,
      (total, session) => total + session.questionsAnswered,
    );
  }

  List<ActivityAnalytics> buildActivityBreakdown({
    required List<StudySessionEntity> sessions,
  }) {
    final Map<StudyActivity, int> minutesByActivity = {};

    for (final session in sessions) {
      if (session.endedAt == null) continue;

      final minutes = session.endedAt!
          .difference(session.startedAt)
          .inMinutes;

      minutesByActivity[session.activity] = (minutesByActivity[session.activity] ?? 0) + minutes;
    }

    return StudyActivity.values.map((activity) {
      return ActivityAnalytics(
        activity: activity,
        totalMinutes: minutesByActivity[activity] ?? 0,
      );
    }).toList();
  }

}
