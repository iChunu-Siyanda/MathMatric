import 'package:math_matric/features/ui/practice/domain/entities/practice_topic_data.dart';
import 'package:math_matric/features/ui/practice/domain/repositories/practice_respository.dart';
import 'package:math_matric/features/progress/services/level_unlock_calculator.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';

class LoadPracticeTopicUseCase {
  final PracticeRepository practiceRepository;
  final UserLevelProgressRepository levelProgressRepository;
  final LevelUnlockCalculator unlockCalculator;

  const LoadPracticeTopicUseCase({
    required this.practiceRepository,
    required this.levelProgressRepository,
    required this.unlockCalculator,
  });

  Future<PracticeTopicData> call(String topicId) async {
    final topic = await practiceRepository.getPracticeTopicById(topicId);

    final levels = await practiceRepository.getLevelsForTopic(topicId);

    final progresses = await levelProgressRepository.getProgressByTopic(topicId);

    final orderedLevelIds = levels.map((level) => level.levelId).toList();

    final enrichedLevels = levels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;

      final levelProgress = progresses
          .where((p) => p.levelId == level.levelId)
          .firstOrNull;

      final isCompleted = levelProgress?.completed ?? false;

      final isUnlocked = unlockCalculator.isUnlocked(
        index: index,
        progresses: progresses,
        orderedLevelIds: orderedLevelIds,
      );

      final earnedXP = levelProgress?.earnedXP ?? 0;

      final progress = level.xpReward == 0
          ? 0.0
          : earnedXP / level.xpReward;

      return level.copyWith(
        isCompleted: isCompleted,
        isUnlocked: isUnlocked,
        progress: progress.clamp(0.0, 1.0),
      );
    }).toList();

    final earnedXp = progresses.fold<int>(
      0,
      (total, progress) => total + progress.earnedXP,
    );

    final totalXp = levels.fold<int>(
      0,
      (total, level) => total + level.xpReward,
    );

    final topicProgress = totalXp == 0
        ? 0.0
        : (earnedXp / totalXp).clamp(0.0, 1.0);

    return PracticeTopicData(
      practiceTopic: topic,
      levels: enrichedLevels,
      earnedXp: earnedXp,
      totalXp: totalXp,
      progress: topicProgress,
    );
  }
}
