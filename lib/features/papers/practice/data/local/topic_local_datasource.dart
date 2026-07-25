import 'package:math_matric/features/papers/practice/data/models/topic_model.dart';

abstract class TopicLocalDataSource {
  Future<List<TopicModel>> getAllTopics();

  Future<TopicModel?> getTopic(String topicId);

  Future<void> insertTopic(TopicModel topic);

  Future<int> deleteTopic(String topicId);
}
