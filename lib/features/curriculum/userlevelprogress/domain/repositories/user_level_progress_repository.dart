import 'package:math_matric/features/curriculum/userlevelprogress/domain/entities/user_level_progresses_entity.dart';

abstract class UserLevelProgressRepository {
  Future<List<UserLevelProgressEntity>> getAllUserLevelProgresses();

  Future<UserLevelProgressEntity?> getUserLevelProgress(
    String levelId,
  );

  Future<List<UserLevelProgressEntity>> getProgressByTopic(
    String topicId,
  );

  Future<List<UserLevelProgressEntity>> getCompletedLevels();

  Future<List<UserLevelProgressEntity>> getIncompleteLevels();
}
