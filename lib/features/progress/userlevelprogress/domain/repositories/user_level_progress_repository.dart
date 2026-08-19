import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';

abstract class UserLevelProgressRepository {
  // Study Session Lifecycle:
  Future<void> saveProgress(
    UserLevelProgressEntity progress,
  );

  // Queries:
  Future<List<UserLevelProgressEntity>> getAllUserLevelProgresses();

  Future<UserLevelProgressEntity?> getUserLevelProgress(
    String levelId,
  );

  Future<List<UserLevelProgressEntity>> getProgressByTopic(
    String topicId,
  );

  Future<List<UserLevelProgressEntity>> getCompletedLevels();

  Future<List<UserLevelProgressEntity>> getIncompleteLevels();

  // Sync:
  Future<void> sync(String userId);
}
