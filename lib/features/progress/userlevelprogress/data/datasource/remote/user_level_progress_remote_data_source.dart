import 'package:math_matric/features/progress/userlevelprogress/data/models/user_level_progresses_model.dart';

abstract class UserLevelProgressRemoteDataSource {
  Future<List<UserLevelProgressModel>> getAllUserLevelProgresses(
    String userId,
  );

  Future<UserLevelProgressModel?> getUserLevelProgress(
    String userId,
    String levelId,
  );

  Future<void> saveUserLevelProgress(
    String userId,
    UserLevelProgressModel progress,
  );

  Future<void> saveUserLevelProgresses(
    String userId,
    List<UserLevelProgressModel> progresses,
  );

  Future<void> deleteUserLevelProgress(
    String userId,
    String progressId,
  );
}
