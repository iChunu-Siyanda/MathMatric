import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';

extension TopicQueries on AppDatabase {
  Future<bool> hasTopics() async {
    final count = await (selectOnly(topics)
          ..addColumns([topics.id.count()])).getSingle();

    return count.read(topics.id.count())! > 0;
  }

  Future<List<Topic>> getAllTopics() {
    return select(topics).get();
  }

  Future<Topic?> getTopic(String topicId) {
    return (select(topics)
      ..where((t) => t.topicId.equals(topicId)))
      .getSingleOrNull();
  }

  Future<List<Topic>> getTopicsBySubject(String subjectId) {
    return (select(topics)
      ..where((t) => t.subjectId.equals(subjectId))
      ..orderBy([(t) => OrderingTerm.asc(t.order)]))
      .get();
  }

  Future<void> insertTopic(TopicsCompanion topic) {
    return into(topics).insert(topic);
  }

  Future<void> insertTopics(List<TopicsCompanion> topicList) {
    return batch((batch) {
        batch.insertAll(topics, topicList,mode: InsertMode.insertOrReplace,);
      }
    );
  }

  Future<void> updateTopic(Topic topic) {
    return update(topics).replace(topic);
  }

  Future<int> deleteTopic(String topicId) {
    return (delete(topics)
      ..where((t) => t.topicId.equals(topicId)))
      .go();
  }

  Future<void> clearTopics() {
    return delete(topics).go();
  }
}
