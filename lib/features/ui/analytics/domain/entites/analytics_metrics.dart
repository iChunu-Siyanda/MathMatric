import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/activity_analysis.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_chart_point.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/topic_progress_card_entity.dart';

class AnalyticsMetrics {
  final List<UserTopicProgressEntity> topics;
  final List<UserLevelProgressEntity> levels;
  final List<QuestionAttemptEntity> questionAttempts;
  final List<StudySessionEntity> sessions;

  final List<QuestionAttemptEntity> filteredAttempts;
  final List<UserLevelProgressEntity> filteredLevels;

  final List<TopicProgressCardEntity> topicProgressCards;

  final int totalEarnedXP;
  final double overallAccuracy;
  final double overallCompletionRate;
  final double avgTimePerQuestionSeconds;
  final int totalPracticeTimeSeconds;

  final List<AnalyticsChartPoint> studyVolume;
  final List<AnalyticsChartPoint> accuracyTrend;
  final int totalStudyMinutes;
  final int totalQuestionsAnswered;
  final List<ActivityAnalytics> activityBreakdown;

  const AnalyticsMetrics({
    required this.topics,
    required this.levels,
    required this.questionAttempts,
    required this.sessions,
    required this.filteredAttempts,
    required this.filteredLevels,
    required this.topicProgressCards,
    required this.totalEarnedXP,
    required this.overallAccuracy,
    required this.overallCompletionRate,
    required this.avgTimePerQuestionSeconds,
    required this.totalPracticeTimeSeconds, 
    required this.studyVolume, 
    required this.accuracyTrend, 
    required this.totalStudyMinutes, 
    required this.totalQuestionsAnswered, 
    required this.activityBreakdown,
  });
}
