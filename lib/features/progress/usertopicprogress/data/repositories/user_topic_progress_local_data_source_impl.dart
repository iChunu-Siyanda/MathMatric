import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/userdata/user_topic_progesses_queries.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/datasource/local/user_topic_progress_local_data_source.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/models/user_topic_progresses_model.dart';

class UserTopicProgressLocalDataSourceImpl implements UserTopicProgressLocalDataSource {
  final AppDatabase db;
  UserTopicProgressLocalDataSourceImpl(this.db);

  @override
  Future<List<UserTopicProgressModel>>
      getAllUserTopicProgresses() async {
    final rows = await db.getAllUserTopicProgresses();

    return rows
        .map(UserTopicProgressModel.fromDrift)
        .toList();
  }

  @override
  Future<UserTopicProgressModel?>
      getUserTopicProgress(
    String topicId,
  ) async {
    final row = await db.getUserTopicProgress(
      topicId,
    );

    if (row == null) return null;

    return UserTopicProgressModel.fromDrift(row);
  }

  @override
  Future<List<UserTopicProgressModel>>
      getFavoriteTopics() async {
    final rows = await db.getFavoriteTopics();

    return rows
        .map(UserTopicProgressModel.fromDrift)
        .toList();
  }

  @override
  Future<UserTopicProgressModel?>
      getLastPlayedTopic() async {
    final row = await db.getLastPlayedTopic();

    if (row == null) return null;

    return UserTopicProgressModel.fromDrift(row);
  }

  @override
  Future<void> saveUserTopicProgresses(
    List<UserTopicProgressModel> progresses,
  ) async {
    await db.insertUserTopicProgresses(
      progresses
          .map((p) => p.toCompanion())
          .toList(),
    );
  }

  @override
  Future<void> clearUserTopicProgresses() async {
    await db.clearUserTopicProgresses();
  }

  @override
  Future<int> deleteUserTopicProgress(
    String topicId,
  ) {
    return db.deleteUserTopicProgress(
      topicId,
    );
  }

  @override
  Future<List<UserTopicProgressModel>> getUnsyncedAttempts() async {
    final rows = await db.getUnsyncedUserTopicProgresses();

    return rows
          .map(UserTopicProgressModel.fromDrift)
          .toList();
  }

  @override
  Future<void> markAttemptSynced(String attemptId) {
    return db.markUserTopicProgressSynced(attemptId);
  }
}
