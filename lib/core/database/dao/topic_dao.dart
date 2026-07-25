import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/tables/topics.dart';
import 'package:math_matric/features/papers/practice/data/models/topic_model.dart';

part 'topic_dao.g.dart';

@DriftAccessor(tables: [Topics])
class TopicDao extends DatabaseAccessor<AppDatabase>with _$TopicDaoMixin {

  TopicDao(super.db);

  Future<List<Topic>> getAllTopics() {
    return select(topics).get();
  }

  Future<Topic?> getTopic(String topicId) {
    return (select(topics)
          ..where((t) => t.topicId.equals(topicId)))
        .getSingleOrNull();
  }

  Future<void> insertTopic(TopicModel topic) {
    return into(topics).insert(topic.toCompanion(version: 1, updatedAt: DateTime.now()));
  }
  
  Future<int> deleteTopic(String topicId) {
    return (delete(topics)
          ..where((t) => t.topicId.equals(topicId)))
        .go();
  }
}
