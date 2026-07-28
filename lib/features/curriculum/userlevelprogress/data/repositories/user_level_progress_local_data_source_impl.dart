import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/user_level_progresses_queries.dart';
import 'package:math_matric/features/curriculum/userlevelprogress/data/datasource/local/user_level_progress_local_data_source.dart';
import 'package:math_matric/features/curriculum/userlevelprogress/data/models/user_level_progresses_model.dart';

class UserLevelProgressLocalDataSourceImpl implements UserLevelProgressLocalDataSource {
  final AppDatabase db;
  UserLevelProgressLocalDataSourceImpl(this.db);

  @override
  Future<List<UserLevelProgressModel>>
      getAllUserLevelProgresses() async {
    final rows = await db.getAllUserLevelProgresses();

    return rows
        .map(UserLevelProgressModel.fromDrift)
        .toList();
  }

  @override
  Future<UserLevelProgressModel?> getUserLevelProgress(
    String levelId,
  ) async {
    final row = await db.getUserLevelProgress(
      levelId,
    );

    if (row == null) return null;

    return UserLevelProgressModel.fromDrift(row);
  }

  @override
  Future<List<UserLevelProgressModel>> getProgressByTopic(
    String topicId,
  ) async {
    final rows = await db.getProgressByTopic(
      topicId,
    );

    return rows
        .map(UserLevelProgressModel.fromDrift)
        .toList();
  }

  @override
  Future<List<UserLevelProgressModel>>
      getCompletedLevels() async {
    final rows = await db.getCompletedLevels();

    return rows
        .map(UserLevelProgressModel.fromDrift)
        .toList();
  }

  @override
  Future<List<UserLevelProgressModel>>
      getIncompleteLevels() async {
    final rows = await db.getIncompleteLevels();

    return rows
        .map(UserLevelProgressModel.fromDrift)
        .toList();
  }

  @override
  Future<void> saveUserLevelProgresses(
    List<UserLevelProgressModel> progresses,
  ) async {
    await db.insertUserLevelProgresses(
      progresses
          .map((p) => p.toCompanion())
          .toList(),
    );
  }

  @override
  Future<void> clearUserLevelProgresses() async {
    await db.clearUserLevelProgresses();
  }

  @override
  Future<int> deleteUserLevelProgress(
    String levelId,
  ) {
    return db.deleteUserLevelProgress(
      levelId,
    );
  }
}
