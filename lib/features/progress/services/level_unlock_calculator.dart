import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';

class LevelUnlockCalculator {
  const LevelUnlockCalculator();

  bool isUnlocked({
    required int index,
    required List<UserLevelProgressEntity> progresses,
    required List<String> orderedLevelIds,
  }) {
    if (index == 0) {
      return true;
    }

    final previousLevelId = orderedLevelIds[index - 1];

    return progresses.any(
      (progress) => progress.levelId == previousLevelId && progress.completed,
    );
  }
}
