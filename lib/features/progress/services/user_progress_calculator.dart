import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';

class UserProgressCalculator {
  const UserProgressCalculator();

  UserLevelProgressEntity updateLevelProgress({
    required UserLevelProgressEntity current,
    required int earnedXP,
    required double score,
    required bool completed,
    required DateTime now,
  }) {
    return UserLevelProgressEntity(
      id: current.id,
      levelId: current.levelId,
      topicId: current.topicId,
      completed: completed,
      earnedXP: current.earnedXP + earnedXP,
      bestScore: score > current.bestScore
          ? score
          : current.bestScore,
      attempts: current.attempts + 1,
      completedAt: completed
          ? (current.completedAt ?? now)
          : current.completedAt,
      lastPlayed: now,
    );
  }

  UserTopicProgressEntity updateTopicProgress({
    required UserTopicProgressEntity current,
    required int earnedXP,
    required double mastery,
    required DateTime now,
  }) {
    return UserTopicProgressEntity(
      id: current.id,
      topicId: current.topicId,
      earnedXP: current.earnedXP + earnedXP,
      mastery: mastery,
      lastPlayed: now,
      favorite: current.favorite,
    );
  }

  bool isLevelCompleted({
    required double accuracy,
  }) {
    return accuracy >= 80.0;
  }

  bool isNewBestScore({
    required double currentBest,
    required double newScore,
  }) {
    return newScore > currentBest;
  }
  
  bool isNewBest({
    required double currentBestScore,
    required int? currentBestTime,
    required double newScore,
    required int newTime,
  }) {
    if (newScore > currentBestScore) {
      return true;
    }

    if (newScore < currentBestScore) {
      return false;
    }

    // Same score, but no previous time exists.
    if (currentBestTime == null) {
      return true;
    }

    return newTime < currentBestTime;
  }

  double calculateMastery(
    List<double> attempts,
  ) {
    if (attempts.isEmpty) {
      return 0.0;
    }

    final recent = attempts.reversed.take(3).toList();

    if (recent.length == 1) {
      return recent[0];
    }

    if (recent.length == 2) {
      return (recent[0] * 0.60) + (recent[1] * 0.40);
    }

    return (recent[0] * 0.50) + (recent[1] * 0.30) + (recent[2] * 0.20);
  }

  int calculateNewCorrectAnswers({
    required List<String> previouslyCorrectQuestionIds,
    required Map<String, bool> currentAnswers,
  }) {
    return currentAnswers.entries.where(
          (entry) => entry.value && !previouslyCorrectQuestionIds.contains(entry.key),
        ).length;
  }
}
