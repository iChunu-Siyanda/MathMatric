import 'package:math_matric/features/progress/userlevelprogress/data/datasource/local/user_level_progress_local_data_source.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/datasource/remote/user_level_progress_remote_data_source.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/models/user_level_progresses_model.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';

class UserLevelProgressRepositoryImpl implements UserLevelProgressRepository {
  final UserLevelProgressLocalDataSource local;
  final UserLevelProgressRemoteDataSource remote;
  UserLevelProgressRepositoryImpl(
    this.local,
    this.remote,
  );

  @override
  Future<List<UserLevelProgressEntity>> getAllUserLevelProgresses() async {
    final models = await local.getAllUserLevelProgresses();

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<UserLevelProgressEntity?> getUserLevelProgress(
    String levelId,
  ) async {
    final model = await local.getUserLevelProgress(
      levelId,
    );

    return model?.toEntity();
  }

  @override
  Future<List<UserLevelProgressEntity>> getProgressByTopic(
    String topicId,
  ) async {
    final models = await local.getProgressByTopic(
      topicId,
    );

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<List<UserLevelProgressEntity>> getCompletedLevels() async {
    final models = await local.getCompletedLevels();

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<List<UserLevelProgressEntity>>
      getIncompleteLevels() async {
    final models = await local.getIncompleteLevels();

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<void> sync(String userId) async {
    final unsynced = await local.getUnsyncedAttempts();
    if (unsynced.isEmpty) return;

    await remote.saveUserLevelProgresses(
      userId,
      unsynced,
    );

    for (final progress in unsynced) {
      await local.markAttemptSynced(
        progress.id,
      );
    }
  }

  @override
  Future<void> saveProgress(UserLevelProgressEntity progress) {
    return local.saveUserLevelProgress(UserLevelProgressModel.fromEntity(progress));
  }
}
