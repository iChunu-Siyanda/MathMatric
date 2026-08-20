import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';

class FakeLevelProgressRepository implements UserLevelProgressRepository {
  List<UserLevelProgressEntity> levels = [];

  @override
  Future<List<UserLevelProgressEntity>> getProgressByTopic(
    String topicId,
  ) async {
    return levels;
  }

  @override
  Future<UserLevelProgressEntity?> getUserLevelProgress(
    String levelId,
  ) async {
    return null;
  }

  @override
  Future<List<UserLevelProgressEntity>>
      getAllUserLevelProgresses() async {
    return [];
  }

  @override
  Future<List<UserLevelProgressEntity>>
      getCompletedLevels() async {
    return [];
  }

  @override
  Future<List<UserLevelProgressEntity>>
      getIncompleteLevels() async {
    return [];
  }

  @override
  Future<void> saveProgress(
    UserLevelProgressEntity progress,
  ) async {}

  @override
  Future<void> sync(String userId) async {}
}
