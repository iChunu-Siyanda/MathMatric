import 'package:math_matric/core/database/dao/topic_dao.dart';
import 'package:math_matric/features/papers/practice/data/local/topic_local_datasource.dart';
import 'package:math_matric/features/papers/practice/data/models/topic_model.dart';

class TopicLocalDataSourceImpl implements TopicLocalDataSource {
  final TopicDao dao;

  TopicLocalDataSourceImpl(this.dao);

  @override
  Future<List<TopicModel>> getAllTopics() async {
    final rows = await dao.getAllTopics();
    return rows.map(TopicModel.fromDrift).toList();
  }

  @override
  Future<TopicModel?> getTopic(String topicId) async {
    final row = await dao.getTopic(topicId);
    return TopicModel.fromDrift(row!);
  }

  @override
  Future<void> insertTopic(TopicModel topic) async {
    await dao.insertTopic(topic);
  }

  @override
  Future<int> deleteTopic(String topicId) {
    return dao.deleteTopic(topicId);
  }
}
