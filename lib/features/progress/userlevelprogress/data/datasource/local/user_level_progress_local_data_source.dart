import 'package:math_matric/features/progress/userlevelprogress/data/models/user_level_progresses_model.dart';

abstract class UserLevelProgressLocalDataSource {
  Future<List<UserLevelProgressModel>> getAllUserLevelProgresses();

  Future<UserLevelProgressModel?> getUserLevelProgress(
    String levelId,
  );

  Future<List<UserLevelProgressModel>> getProgressByTopic(
    String topicId,
  );

  Future<List<UserLevelProgressModel>> getUnsyncedAttempts();

  Future<void> markAttemptSynced(
    String attemptId,
  );

  Future<List<UserLevelProgressModel>> getCompletedLevels();

  Future<List<UserLevelProgressModel>> getIncompleteLevels();

  Future<void> saveUserLevelProgresses(
    List<UserLevelProgressModel> progresses,
  );

  Future<void> saveUserLevelProgress(
    UserLevelProgressModel progress,
  );

  Future<void> clearUserLevelProgresses();

  Future<int> deleteUserLevelProgress(
    String levelId,
  );
}
