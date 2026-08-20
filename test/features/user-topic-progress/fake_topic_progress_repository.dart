import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/repositories/user_topic_progress_repository.dart';

class FakeTopicProgressRepository implements UserTopicProgressRepository {
  UserTopicProgressEntity? progress;
  UserTopicProgressEntity? savedProgress;

  @override
  Future<UserTopicProgressEntity?> getUserTopicProgress(
    String topicId,
  ) async {
    return progress;
  }

  @override
  Future<void> saveProgress(
    UserTopicProgressEntity progress,
  ) async {
    savedProgress = progress;
  }

  @override
  Future<List<UserTopicProgressEntity>>
      getAllUserTopicProgresses() async {
    return [];
  }

  @override
  Future<List<UserTopicProgressEntity>> getFavoriteTopics() async {
    return [];
  }

  @override
  Future<UserTopicProgressEntity?> getLastPlayedTopic() async {
    return null;
  }

  @override
  Future<void> sync(String userId) async {}
}
