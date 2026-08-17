import 'package:firebase_auth/firebase_auth.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/datasource/local/user_level_progress_local_data_source.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/datasource/remote/user_level_progress_remote_data_source.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';

class UserLevelProgressRepositoryImpl implements UserLevelProgressRepository {
  final UserLevelProgressLocalDataSource local;
  final UserLevelProgressRemoteDataSource remote;
  final FirebaseAuth auth;
  UserLevelProgressRepositoryImpl(
    this.local,
    this.remote,
    this.auth,
  );

  @override
  Future<List<UserLevelProgressEntity>> getAllUserLevelProgresses() async {
    final models = await local.getAllUserLevelProgresses();

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<UserLevelProgressEntity?>
      getUserLevelProgress(
    String levelId,
  ) async {
    final model = await local.getUserLevelProgress(
      levelId,
    );

    return model?.toEntity();
  }

  @override
  Future<List<UserLevelProgressEntity>>
      getProgressByTopic(
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
  Future<List<UserLevelProgressEntity>>
      getCompletedLevels() async {
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
  Future<void> sync() async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('Cannot sync: user is not authenticated.');
    }

    final unsynced = await local.getUnsyncedAttempts();
    if (unsynced.isEmpty) return;

    await remote.saveUserLevelProgresses(
      user.uid,
      unsynced,
    );

    for (final progress in unsynced) {
      await local.markAttemptSynced(
        progress.id,
      );
    }
  }
}
