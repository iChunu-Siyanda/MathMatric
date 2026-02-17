import 'package:math_matric/features/papers/domain/entities/pactice_level.dart';
import 'package:math_matric/features/papers/domain/entities/practice_topic.dart';

abstract class PracticeRepository {
  Future<List<PracticeTopic>> getPracticeTopics();
  Future<PracticeTopic> getTopicById(String topicId);
  Future<List<PracticeLevel>> getLevelsForTopic(String topicId);
}
