import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_metrics.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/domain/extensions/analytics_calculator_extension.dart';
import 'package:math_matric/shared/services/app_clock.dart';

class AnalyticsCalculator {
  final AppClock clock;
  const AnalyticsCalculator(this.clock);

  AnalyticsMetrics calculate({
    required List<StudySessionEntity> sessions,
    required List<QuestionAttemptEntity> questionAttempts,
    required List<UserLevelProgressEntity> levels,
    required List<UserTopicProgressEntity> topics,
    required AnalyticsTimeframe timeframe,
  }) {
    
    final cutoff = getCutoff(timeframe);

    final filteredAttempts = cutoff == null
        ? questionAttempts 
        : questionAttempts.where((q) => q.answeredAt.isAfter(cutoff)).toList();

    final filteredLevels = cutoff == null
        ? levels
        : levels.where((l) => l.lastPlayed.isAfter(cutoff)).toList();

    final filteredSessions = cutoff == null 
        ? sessions 
        : sessions.where((session) {
          final startedAt = session.startedAt;
          return startedAt.isAfter(cutoff);
        })
        .toList();  

    final studyVolume = buildStudyVolume(
      sessions: filteredSessions,
    );

    final accuracyTrend = buildAccuracyTrend(
      attempts: filteredAttempts,
    );

    final totalStudyMinutes = calculateTotalStudyMinutes(
      filteredSessions,
    );

    final totalQuestionsAnswered = calculateTotalQuestionsAnswered(filteredSessions);

    final activityBreakdown = buildActivityBreakdown(
      sessions: filteredSessions,
    );
  
    final topicProgressCards = buildTopicProgressCards(
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

      studyVolume: studyVolume,
      accuracyTrend: accuracyTrend,
      totalStudyMinutes: totalStudyMinutes,
      totalQuestionsAnswered: totalQuestionsAnswered,
      activityBreakdown: activityBreakdown,
    );
  }
}
