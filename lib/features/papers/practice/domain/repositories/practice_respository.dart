import 'package:math_matric/features/papers/practice/domain/entities/practice_level.dart';
import 'package:math_matric/features/papers/practice/domain/entities/practice_topic.dart';

abstract class PracticeRepository {
  Future<List<PracticeTopic>> getPracticeTopics();
  Future<PracticeTopic> getPracticeTopicById(String topicId);
  Future<List<PracticeLevel>> getLevelsForTopic(String topicId);
}

abstract class TopicRepository {
  Future<List<PracticeTopic>> getAllTopics();

  Future<List<PracticeTopic>> getTopicsBySubject(String subjectId,);

  Future<PracticeTopic?> getTopic(String topicId,);
}
