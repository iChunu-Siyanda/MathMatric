import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_metrics.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/topic_progress_card_entity.dart';

class AnalyticsCalculator {
  const AnalyticsCalculator();

  List<TopicProgressCardEntity> _buildTopicProgressCards({
    required List<UserTopicProgressEntity> topics,
    required List<UserLevelProgressEntity> levels,
  }) {
    return topics.map((topic) {
      final topicLevels = levels
          .where((level) => level.topicId == topic.id)
          .toList();

      final completedCount =
          topicLevels.where((level) => level.completed).length;

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

  AnalyticsMetrics calculate({
    required List<StudySessionEntity> sessions,
    required List<QuestionAttemptEntity> questionAttempts,
    required List<UserLevelProgressEntity> levels,
    required List<UserTopicProgressEntity> topics,
    required AnalyticsTimeframe timeframe,
  }) {
    
    final cutoff = _getCutoff(timeframe);

    final filteredAttempts = questionAttempts
        .where((q) => q.answeredAt.isAfter(cutoff))
        .toList();

    final filteredLevels = levels
        .where((l) => l.lastPlayed.isAfter(cutoff))
        .toList();

    final topicProgressCards = _buildTopicProgressCards(
      topics: topics, 
      levels: levels,
    );    

    final totalEarnedXP = filteredLevels.fold<int>(
      0,
      (sum, level) => sum + level.earnedXP,
    );

    final overallAccuracy = filteredAttempts.isEmpty
        ? 0.0
        : filteredAttempts.where((q) => q.correct).length /
            filteredAttempts.length *
            100;

    final totalPracticeTimeSeconds = filteredAttempts.fold<int>(
      0,
      (sum, question) => sum + question.timeTaken,
    );

    final avgTimePerQuestionSeconds = filteredAttempts.isEmpty
        ? 0.0
        : totalPracticeTimeSeconds / filteredAttempts.length;

    final overallCompletionRate = levels.isEmpty
        ? 0.0
        : levels.where((l) => l.completed).length /
            levels.length *
            100;

    return AnalyticsMetrics(
      topics: topics,
      levels: levels,
      questionAttempts: questionAttempts,
      sessions: sessions,
      filteredAttempts: filteredAttempts,
      filteredLevels: filteredLevels,
      topicProgressCards: topicProgressCards,
      totalEarnedXP: totalEarnedXP,
      overallAccuracy: overallAccuracy,
      overallCompletionRate: overallCompletionRate,
      avgTimePerQuestionSeconds: avgTimePerQuestionSeconds,
      totalPracticeTimeSeconds: totalPracticeTimeSeconds,
    );
  }

  DateTime _getCutoff(AnalyticsTimeframe timeframe) {
    final now = DateTime.now();

    switch (timeframe) {
      case AnalyticsTimeframe.days7:
        return now.subtract(const Duration(days: 7));

      case AnalyticsTimeframe.days30:
        return now.subtract(const Duration(days: 30));

      case AnalyticsTimeframe.allTime:
        return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }
}
