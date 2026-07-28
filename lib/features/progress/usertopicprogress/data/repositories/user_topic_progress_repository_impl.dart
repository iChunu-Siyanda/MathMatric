import 'package:math_matric/features/progress/usertopicprogress/data/datasource/local/user_topic_progress_local_data_source.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/repositories/user_topic_progress_repository.dart';

class UserTopicProgressRepositoryImpl implements UserTopicProgressRepository {
  final UserTopicProgressLocalDataSource local;

  UserTopicProgressRepositoryImpl(this.local);

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
}
