import 'package:math_matric/features/curriculum/topics/data/models/topic_model.dart';

abstract class TopicRemoteDataSource {
  Future<List<TopicModel>> getAllTopics();

  Future<TopicModel?> getTopic(
    String topicId,
  );

  Future<List<TopicModel>> getTopicsBySubject(
    String subjectId,
  );
}
