import 'package:math_matric/features/ui/practice/domain/entities/practice_topic.dart';

abstract class TopicRepository {
  Future<List<PracticeTopic>> getAllTopics();
  Future<List<PracticeTopic>> getTopicsBySubject(String subjectId,);
  Future<PracticeTopic?> getTopic(String topicId,);
}
