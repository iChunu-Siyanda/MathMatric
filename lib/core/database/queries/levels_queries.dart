import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';

extension LevelsQueries on AppDatabase {
  Future<List<Level>> getAllLevels() {
    return select(levels).get();
  }

  Future<Level?> getLevel(String levelId) {
    return (select(levels)
          ..where((l) => l.id.equals(levelId)))
        .getSingleOrNull();
  }

  Future<List<Level>> getLevelsByTopic(String topicId) {
    return (select(levels)
          ..where((l) => l.topicId.equals(topicId))
          ..orderBy([
            (l) => OrderingTerm.asc(l.order),
          ]))
        .get();
  }

  Future<int> getLevelCount(String topicId) async {
    final query = selectOnly(levels)
      ..addColumns([levels.id.count()])
      ..where(levels.topicId.equals(topicId));

    final result = await query.getSingle();

    return result.read(levels.id.count()) ?? 0;
  }

  Future<int> insertLevel(LevelsCompanion level) {
    return into(levels).insert(level);
  }

  Future<void> insertLevels(
    List<LevelsCompanion> levelList,
  ) {
    return batch((batch) {
      batch.insertAll(levels, levelList);
    });
  }

  Future<bool> updateLevel(Level level) {
    return update(levels).replace(level);
  }

  Future<int> deleteLevel(String levelId) {
    return (delete(levels)
          ..where((l) => l.id.equals(levelId)))
        .go();
  }

  Future<int> deleteLevelsByTopic(String topicId) {
    return (delete(levels)
          ..where((l) => l.topicId.equals(topicId)))
        .go();
  }

  Future<int> clearLevels() {
    return delete(levels).go();
  }

  Future<bool> hasLevels() async {
    final levelsList = await getAllLevels();

    return levelsList.isNotEmpty;
  }
}
