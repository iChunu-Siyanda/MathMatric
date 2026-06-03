import 'package:math_matric/features/papers/domain/entities/practice_topic_data.dart';
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
    final topic = await practiceRepository.getPracticeTopicById(topicId);
    final levels = await practiceRepository.getLevelsForTopic(topicId);
    final completed = await progressRepository.getCompletedLevels(topicId);
    final earnedXp = await progressRepository.getEarnedXp(topicId);

    final Map<String, int> levelXpMap = {};
    for (var lvl in levels) {
      final lvlXp = await progressRepository.getLevelXp(lvl.levelId);
      levelXpMap[lvl.levelId] = lvlXp;
    }
    final enrichedLevels = _computeUnlocks(levels, completed, levelXpMap);
    
    final totalXp =
        levels.fold(0, (sum, el) => sum + el.xpReward); //el as in element, 0 is the 1st element.

    final double progress = totalXp == 0 ? 0 : earnedXp / totalXp;

    return PracticeTopicData(
      practiceTopic: topic,
      levels: enrichedLevels,
      earnedXp: earnedXp,
      totalXp: totalXp,
      progress: progress,
    );
  }

  List<PracticeLevel> _computeUnlocks(
      List<PracticeLevel> levels,
      List<String> completed,
      Map<String, int> levelXpMap,
    ) {

    return levels.asMap().entries.map((entry) { //convert to map of {0:[...], 1:[...],...}
      final index = entry.key;
      final level = entry.value;

      final isCompleted = completed.contains(level.levelId); //If the current level's ID is in that list, isCompleted becomes true.
      final isUnlocked =
          index == 0 || completed.contains(levels[index - 1].levelId); 
          //Index == 0 is always true, "index - 1" checks if prev ID is in the completed list if yes then it is unlocked.

      final int levelEarnedXp = levelXpMap[level.levelId] ?? 0;
      final double levelProgress = level.xpReward == 0 ? 0.0 : levelEarnedXp / level.xpReward;
      return level.copyWith(
        isCompleted: isCompleted,
        isUnlocked: isUnlocked,
        progress: levelProgress,
      );
    }).toList();
  }
}

//copyWith creates a new version of that level with the updated isCompleted and isUnlocked flags, 
//leaving all other data (like title or XP) exactly the same.
