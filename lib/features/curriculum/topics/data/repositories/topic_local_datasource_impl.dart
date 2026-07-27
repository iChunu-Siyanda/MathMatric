import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/topic_queries.dart';
import 'package:math_matric/features/curriculum/topics/data/datasource/local/topic_local_datasource.dart';
import 'package:math_matric/features/curriculum/topics/data/models/topic_model.dart';

class TopicLocalDataSourceImpl implements TopicLocalDataSource {
  final AppDatabase db;
  TopicLocalDataSourceImpl(this.db);

  @override
  Future<List<TopicModel>> getAllTopics() async {
    final rows = await db.getAllTopics();
    return rows.map(TopicModel.fromDrift).toList();
  }

  @override
  Future<List<TopicModel>> getTopicsBySubject(
    String subjectId,
  ) async {
    final rows = await db.getTopicsBySubject(subjectId);
    return rows.map(TopicModel.fromDrift).toList();
  }

  @override
  Future<TopicModel?> getTopic(
    String topicId,
  ) async {
    final row = await db.getTopic(topicId);
    if (row == null) return null;
    return TopicModel.fromDrift(row);
  }

  @override
  Future<void> saveTopics(
    List<TopicModel> topics,
  ) async {
    for (final topic in topics) {
      await db.insertTopic(topic.toCompanion(version: 1, updatedAt: DateTime.now()),);
    }
  }

  @override
  Future<void> clearTopics() async {
    await db.clearTopics();
  }
  
  @override
  Future<int> deleteTopic(String topicId) {
    return db.deleteTopic(topicId);
  }
}
