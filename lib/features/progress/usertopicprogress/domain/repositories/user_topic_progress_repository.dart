import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';

abstract class UserTopicProgressRepository {
  // Study Session Lifecycle:
  Future<void> saveProgress(
    UserTopicProgressEntity progress,
  );

  // Queries:
  Future<List<UserTopicProgressEntity>> getAllUserTopicProgresses();

  Future<UserTopicProgressEntity?> getUserTopicProgress(
    String topicId,
  );

  Future<List<UserTopicProgressEntity>> getFavoriteTopics();

  Future<UserTopicProgressEntity?> getLastPlayedTopic();
 
  // Syncing:
  Future<void> sync(String userId);
}
