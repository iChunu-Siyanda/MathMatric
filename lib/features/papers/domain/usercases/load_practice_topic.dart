import 'package:math_matric/features/papers/domain/usercases/practice_topic_data.dart';
import 'package:math_matric/features/papers/domain/entities/pactice_level.dart';
import 'package:math_matric/features/papers/domain/respositories/practice_respository.dart';
import 'package:math_matric/features/papers/domain/respositories/user_progress_repository.dart';

class LoadPracticeTopicUseCase {
  final PracticeRepository practiceRepository;
  final UserProgressRepository progressRepository;

  LoadPracticeTopicUseCase({
    required this.practiceRepository,
    required this.progressRepository,
  });

  Future<PracticeTopicData> call(String topicId) async {
    final topic = await practiceRepository.getTopicById(topicId);
    final levels = await practiceRepository.getLevelsForTopic(topicId);
    final completed = await progressRepository.getCompletedLevels(topicId);
    final earnedXp = await progressRepository.getEarnedXp(topicId);

    final enrichedLevels = _computeUnlocks(levels, completed);

    final totalXp =
        levels.fold(0, (sum, l) => sum + l.xpReward);

    final double progress = totalXp == 0 ? 0 : earnedXp / totalXp;

    return PracticeTopicData(
      topic: topic,
      levels: enrichedLevels,
      earnedXp: earnedXp,
      totalXp: totalXp,
      progress: progress,
    );
  }

  List<PracticeLevel> _computeUnlocks(
      List<PracticeLevel> levels,
      List<String> completed) {

    return levels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;

      final isCompleted = completed.contains(level.id);
      final isUnlocked =
          index == 0 || completed.contains(levels[index - 1].id);

      return level.copyWith(
        isCompleted: isCompleted,
        isUnlocked: isUnlocked,
      );
    }).toList();
  }
}
