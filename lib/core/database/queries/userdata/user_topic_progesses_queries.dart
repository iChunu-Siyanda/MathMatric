import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';

extension UserTopicProgressesQueries on AppDatabase {

  Future<List<UserTopicProgressesData>> getUnsyncedUserTopicProgresses() {
    return (select(userTopicProgresses)
          ..where((p) => p.synced.equals(false)))
        .get();
  }

  Future<void> markUserTopicProgressSynced(
    String id,
  ) async {
    await (update(userTopicProgresses)
          ..where((p) => p.id.equals(id)))
        .write(
      const UserTopicProgressesCompanion(
        synced: Value(true),
      ),
    );
  }

  Future<List<UserTopicProgressesData>> getAllUserTopicProgresses() {
    return (select(userTopicProgresses)
          ..orderBy([
            (t) => OrderingTerm.desc(t.lastPlayed),
          ]))
        .get();
  }

  Future<UserTopicProgressesData?> getUserTopicProgress(
    String topicId,
  ) {
    return (select(userTopicProgresses)
          ..where((t) => t.topicId.equals(topicId)))
        .getSingleOrNull();
  }

  Future<List<UserTopicProgressesData>> getFavoriteTopics() {
    return (select(userTopicProgresses)
          ..where((t) => t.favorite.equals(true))
          ..orderBy([
            (t) => OrderingTerm.desc(t.lastPlayed),
          ]))
        .get();
  }

  Future<List<UserTopicProgressesData>> getRecentlyPlayedTopics() {
    return (select(userTopicProgresses)
          ..orderBy([
            (t) => OrderingTerm.desc(t.lastPlayed),
          ]))
        .get();
  }

  Future<int> getTopicProgressCount() async {
    final query = selectOnly(userTopicProgresses)
      ..addColumns([userTopicProgresses.id.count()]);

    final result = await query.getSingle();

    return result.read(userTopicProgresses.id.count()) ?? 0;
  }

  Future<int> insertUserTopicProgress(
    UserTopicProgressesCompanion progress,
  ) {
    return into(userTopicProgresses).insert(progress);
  }

  Future<void> insertUserTopicProgresses(
    List<UserTopicProgressesCompanion> progresses,
  ) {
    return batch((batch) {
      batch.insertAll(userTopicProgresses, progresses,mode: InsertMode.insertOrReplace,);
    });
  }

  Future<bool> updateUserTopicProgress(
    UserTopicProgressesData progress,
  ) {
    return update(userTopicProgresses).replace(progress);
  }

  Future<int> deleteUserTopicProgress(
    String topicId,
  ) {
    return (delete(userTopicProgresses)
          ..where((t) => t.topicId.equals(topicId)))
        .go();
  }

  Future<int> clearUserTopicProgresses() {
    return delete(userTopicProgresses).go();
  }

  Future<bool> hasUserTopicProgresses() async {
    final progresses = await getAllUserTopicProgresses();

    return progresses.isNotEmpty;
  }

  Future<UserTopicProgressesData?> getLastPlayedTopic() {
    return (select(userTopicProgresses)
          ..orderBy([
            (t) => OrderingTerm.desc(t.lastPlayed),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  
  Future<double> getAverageMastery() async {
    final query = selectOnly(userTopicProgresses)
      ..addColumns([userTopicProgresses.mastery.avg()]);

    final result = await query.getSingle();

    return result.read(userTopicProgresses.mastery.avg()) ?? 0.0;
  }
}
