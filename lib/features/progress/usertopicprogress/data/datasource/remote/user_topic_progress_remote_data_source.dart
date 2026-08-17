import 'package:math_matric/features/progress/usertopicprogress/data/models/user_topic_progresses_model.dart';

abstract class UserTopicProgressRemoteDataSource {
  Future<List<UserTopicProgressModel>> getAllUserTopicProgresses(
    String userId,
  );

  Future<UserTopicProgressModel?> getUserTopicProgress(
    String userId,
    String topicId,
  );

  Future<void> saveUserTopicProgress(
    String userId,
    UserTopicProgressModel progress,
  );

  Future<void> saveUserTopicProgresses(
    String userId,
    List<UserTopicProgressModel> progresses,
  );

  Future<void> deleteUserTopicProgress(
    String userId,
    String progressId,
  );
}
