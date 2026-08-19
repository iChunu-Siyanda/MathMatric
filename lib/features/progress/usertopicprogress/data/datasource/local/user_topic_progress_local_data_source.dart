import 'package:math_matric/features/progress/usertopicprogress/data/models/user_topic_progresses_model.dart';

abstract class UserTopicProgressLocalDataSource {
  Future<List<UserTopicProgressModel>> getAllUserTopicProgresses();

  Future<UserTopicProgressModel?> getUserTopicProgress(
    String topicId,
  );

  Future<List<UserTopicProgressModel>> getUnsyncedAttempts();

  Future<void> markAttemptSynced(
    String attemptId,
  );

  Future<List<UserTopicProgressModel>> getFavoriteTopics();

  Future<UserTopicProgressModel?> getLastPlayedTopic();

  Future<void> saveUserTopicProgresses(
    List<UserTopicProgressModel> progresses,
  );

    Future<void> saveUserTopicProgress(
    UserTopicProgressModel progress,
  );

  Future<void> clearUserTopicProgresses();

  Future<int> deleteUserTopicProgress(
    String topicId,
  );
}
