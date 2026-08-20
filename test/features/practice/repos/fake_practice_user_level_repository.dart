import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';

class FakePracticeLevelProgressRepository implements UserLevelProgressRepository {
  List<UserLevelProgressEntity> progresses = [];

  @override
  Future<List<UserLevelProgressEntity>> getProgressByTopic(
    String topicId,
  ) async {
    return progresses;
  }

  @override
  Future<List<UserLevelProgressEntity>>
      getAllUserLevelProgresses() async => [];

  @override
  Future<UserLevelProgressEntity?> getUserLevelProgress(
    String levelId,
  ) async => null;

  @override
  Future<List<UserLevelProgressEntity>> getCompletedLevels() async => [];

  @override
  Future<List<UserLevelProgressEntity>> getIncompleteLevels() async => [];

  @override
  Future<void> sync(String userId) async {}

  @override
  Future<void> saveProgress(UserLevelProgressEntity progress) {
    throw UnimplementedError();
  }
}
