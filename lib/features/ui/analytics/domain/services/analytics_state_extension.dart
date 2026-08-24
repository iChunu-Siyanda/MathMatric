// analytics_loaded_extension.dart (or directly at the bottom of analytics_state.dart)
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/presentation/bloc/analytics_state.dart';
import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';

extension AnalyticsLoadedExtension on AnalyticsLoaded {
  //====== Time Frames ===============
  DateTime get _timeframeCutoff {
    final now = DateTime.now();
    switch (selectedTimeframe) {
      case AnalyticsTimeframe.days7:
        return now.subtract(const Duration(days: 7));
      case AnalyticsTimeframe.days30:
        return now.subtract(const Duration(days: 30));
      case AnalyticsTimeframe.allTime:
        return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  // Attempts filtered by selected timeframe
  List<QuestionAttemptEntity> get filteredAttempts => questionAttempts
      .where((q) => q.answeredAt.isAfter(_timeframeCutoff))
      .toList();

  // Progress entries active within selected timeframe
  List<UserLevelProgressEntity> get filteredLevels => levels
      .where((l) => l.lastPlayed.isAfter(_timeframeCutoff))
      .toList();

  // ==========================================
  // 2. OVERALL ENGAGEMENT & XP METRICS
  // ==========================================

  // Total XP accumulated across filtered levels
  int get totalEarnedXP => filteredLevels.fold(0, (sum, level) => sum + level.earnedXP);

  // Overall completion percentage across all available levels
  double get overallCompletionRate {
    if (levels.isEmpty) return 0.0;
    final completedCount = levels.where((l) => l.completed).length;
    return (completedCount / levels.length) * 100;
  }

  // Total practice time in seconds across filtered attempts
  int get totalPracticeTimeSeconds => filteredAttempts.fold(0, (sum, q) => sum + q.timeTaken);

  // ==========================================
  // 3. ACCURACY & PERFORMANCE METRICS
  // ==========================================

  // Overall correctness percentage for filtered attempts
  double get overallAccuracy {
    if (filteredAttempts.isEmpty) return 0.0;
    final correctCount = filteredAttempts.where((q) => q.correct).length;
    return (correctCount / filteredAttempts.length) * 100;
  }

  // Average speed per question in seconds
  double get avgTimePerQuestionSeconds {
    if (filteredAttempts.isEmpty) return 0.0;
    final totalTime = filteredAttempts.fold(0, (sum, q) => sum + q.timeTaken);
    return totalTime / filteredAttempts.length;
  }

  // ==========================================
  // 4. BEHAVIOR & DIAGNOSTIC INSIGHTS
  // ==========================================

  // Levels where user is struggling (high attempts or low score despite completion)
  List<UserLevelProgressEntity> get highEffortLevels => filteredLevels
      .where((l) => l.attempts > 3 || (l.completed && l.bestScore < 0.60))
      .toList()
        ..sort((a, b) => b.attempts.compareTo(a.attempts));

  // Questions flagged as potential guessing (incorrect AND answered in under 3 seconds)
  List<QuestionAttemptEntity> get suspectedGuesses => filteredAttempts
      .where((q) => !q.correct && q.timeTaken < 3)
      .toList();

  // Levels completed on the very first attempt
  List<UserLevelProgressEntity> get firstTryCompletions => filteredLevels
      .where((l) => l.completed && l.attempts == 1)
      .toList();

  // ==========================================
  // 5. SUBJECT-LEVEL AGGREGATIONS
  // ==========================================

  // Map of topic IDs to their average best score
  Map<String, double> get avgScorePerTopic {
    final Map<String, List<double>> topicScores = {};

    for (final level in filteredLevels) {
      topicScores.putIfAbsent(level.topicId, () => []).add(level.bestScore);
    }

    return topicScores.map((topicId, scores) {
      final avg = scores.reduce((a, b) => a + b) / scores.length;
      return MapEntry(topicId, avg);
    });
  }
}
