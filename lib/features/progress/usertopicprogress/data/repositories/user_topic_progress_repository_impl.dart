import 'package:math_matric/features/progress/usertopicprogress/data/datasource/local/user_topic_progress_local_data_source.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/datasource/remote/user_topic_progress_remote_data_source.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/models/user_topic_progresses_model.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/repositories/user_topic_progress_repository.dart';

class UserTopicProgressRepositoryImpl implements UserTopicProgressRepository {
  final UserTopicProgressLocalDataSource local;
  final UserTopicProgressRemoteDataSource remote;

  UserTopicProgressRepositoryImpl(
    this.local,
    this.remote,
  );

  @override
  Future<List<UserTopicProgressEntity>>
      getAllUserTopicProgresses() async {
    final models =
        await local.getAllUserTopicProgresses();

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<UserTopicProgressEntity?>
      getUserTopicProgress(
    String topicId,
  ) async {
    final model =
        await local.getUserTopicProgress(topicId);

    return model?.toEntity();
  }

  @override
  Future<List<UserTopicProgressEntity>>
      getFavoriteTopics() async {
    final models = await local.getFavoriteTopics();

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<UserTopicProgressEntity?>
      getLastPlayedTopic() async {
    final model =
        await local.getLastPlayedTopic();

    return model?.toEntity();
  }

  @override
  Future<void> sync(String userId) async {
    final unsynced = await local.getUnsyncedAttempts();
    if (unsynced.isEmpty) return;

    await remote.saveUserTopicProgresses(
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
  Future<void> saveProgress(UserTopicProgressEntity progress) {
    return local.saveUserTopicProgress(UserTopicProgressModel.fromEntity(progress));
  }
}
