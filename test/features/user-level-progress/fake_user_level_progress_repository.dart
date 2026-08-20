import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';

class FakeUserLevelProgressRepository implements UserLevelProgressRepository {
  UserLevelProgressEntity? progress;
  UserLevelProgressEntity? savedProgress;

  @override
  Future<UserLevelProgressEntity?> getUserLevelProgress(
    String levelId,
  ) async {
    return progress;
  }

  @override
  Future<void> saveProgress(
    UserLevelProgressEntity progress,
  ) async {
    savedProgress = progress;
  }

  @override
  Future<List<UserLevelProgressEntity>>
      getAllUserLevelProgresses() async {
    return [];
  }

  @override
  Future<List<UserLevelProgressEntity>> getProgressByTopic(
    String topicId,
  ) async {
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
  Future<void> sync(String userId) async {}
}
