import 'package:math_matric/features/curriculum/topics/data/models/topic_model.dart';

abstract class TopicLocalDataSource {
  Future<List<TopicModel>> getAllTopics();

  Future<TopicModel?> getTopic(String topicId);

  Future<List<TopicModel>> getTopicsBySubject(String subjectId,);

  Future<void> saveTopics(List<TopicModel> topics);

  Future<void> clearTopics();

  Future<int> deleteTopic(String topicId);
}
