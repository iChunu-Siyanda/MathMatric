import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';

extension UserLevelProgressesQueries on AppDatabase {
  Future<List<UserLevelProgressesData>> getUnsyncedUserLevelProgresses() {
    return (select(userLevelProgresses)
          ..where((p) => p.synced.equals(false)))
        .get();
  }

  Future<void> markUserLevelProgressSynced(
    String id,
  ) async {
    await (update(userLevelProgresses)
          ..where((p) => p.id.equals(id)))
        .write(
      const UserLevelProgressesCompanion(
        synced: Value(true),
      ),
    );
  }

  Future<List<UserLevelProgressesData>> getAllUserLevelProgresses() {
    return (select(userLevelProgresses)
          ..orderBy([
            (l) => OrderingTerm.desc(l.lastPlayed),
          ]))
        .get();
  }

  Future<UserLevelProgressesData?> getUserLevelProgress(
    String levelId,
  ) {
    return (select(userLevelProgresses)
          ..where((l) => l.levelId.equals(levelId)))
        .getSingleOrNull();
  }

  Future<List<UserLevelProgressesData>> getProgressByTopic(
    String topicId,
  ) {
    return (select(userLevelProgresses)
          ..where((l) => l.topicId.equals(topicId)))
        .get();
  }

  Future<List<UserLevelProgressesData>> getCompletedLevels() {
    return (select(userLevelProgresses)
          ..where((l) => l.completed.equals(true))
          ..orderBy([
            (l) => OrderingTerm.desc(l.completedAt),
          ]))
        .get();
  }

  Future<List<UserLevelProgressesData>> getIncompleteLevels() {
    return (select(userLevelProgresses)
          ..where((l) => l.completed.equals(false))
          ..orderBy([
            (l) => OrderingTerm.desc(l.lastPlayed),
          ]))
        .get();
  }

  Future<int> getCompletedLevelCount() async {
    final query = selectOnly(userLevelProgresses)
      ..addColumns([userLevelProgresses.id.count()])
      ..where(userLevelProgresses.completed.equals(true));

    final result = await query.getSingle();

    return result.read(userLevelProgresses.id.count()) ?? 0;
  }

  Future<int> getLevelProgressCountByTopic(
    String topicId,
  ) async {
    final query = selectOnly(userLevelProgresses)
      ..addColumns([userLevelProgresses.id.count()])
      ..where(userLevelProgresses.topicId.equals(topicId));

    final result = await query.getSingle();

    return result.read(userLevelProgresses.id.count()) ?? 0;
  }

  Future<int> insertUserLevelProgress(
    UserLevelProgressesCompanion progress,
  ) {
    return into(userLevelProgresses).insert(progress);
  }

  Future<void> insertUserLevelProgresses(
    List<UserLevelProgressesCompanion> progresses,
  ) {
    return batch((batch) {
      batch.insertAll(userLevelProgresses, progresses, mode: InsertMode.insertOrReplace,);
    });
  }

  Future<bool> updateUserLevelProgress(
    UserLevelProgressesData progress,
  ) {
    return update(userLevelProgresses).replace(progress);
  }

  Future<int> deleteUserLevelProgress(
    String levelId,
  ) {
    return (delete(userLevelProgresses)
          ..where((l) => l.levelId.equals(levelId)))
        .go();
  }

  Future<int> deleteUserLevelProgressesByTopic(
    String topicId,
  ) {
    return (delete(userLevelProgresses)
          ..where((l) => l.topicId.equals(topicId)))
        .go();
  }

  Future<int> clearUserLevelProgresses() {
    return delete(userLevelProgresses).go();
  }

  Future<bool> hasUserLevelProgresses() async {
    final progresses = await getAllUserLevelProgresses();

    return progresses.isNotEmpty;
  }

  Future<int> getTotalEarnedXP() async {
    final query = selectOnly(userLevelProgresses)
      ..addColumns([userLevelProgresses.earnedXP.sum()]);

    final result = await query.getSingle();

    return result.read(userLevelProgresses.earnedXP.sum()) ?? 0;
  }

  Future<double> getAverageBestScore() async {
    final query = selectOnly(userLevelProgresses)
      ..addColumns([userLevelProgresses.bestScore.avg()]);

    final result = await query.getSingle();

    return result.read(userLevelProgresses.bestScore.avg()) ?? 0.0;
  }

  Future<int> getTotalAttempts() async {
    final query = selectOnly(userLevelProgresses)
      ..addColumns([userLevelProgresses.attempts.sum()]);

    final result = await query.getSingle();

    return result.read(userLevelProgresses.attempts.sum()) ?? 0;
  }

  Future<UserLevelProgressesData?> getLastPlayedLevel() {
    return (select(userLevelProgresses)
          ..orderBy([
            (l) => OrderingTerm.desc(l.lastPlayed),
          ])
          ..limit(1))
        .getSingleOrNull();
  }
}
