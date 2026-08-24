import 'package:math_matric/features/ui/practice/domain/entities/practice_level.dart';
import 'package:math_matric/features/ui/practice/domain/entities/practice_topic.dart';
import 'package:math_matric/features/ui/practice/domain/repositories/practice_respository.dart';

class FakePracticeRepository implements PracticeRepository {
  PracticeTopic? topic;
  List<PracticeLevel> levels = [];

  @override
  Future<PracticeTopic> getPracticeTopicById(String topicId) async {
    return topic!;
  }

  @override
  Future<List<PracticeLevel>> getLevelsForTopic(String topicId) async {
    return levels;
  }

  @override
  Future<List<PracticeTopic>> getPracticeTopics() {
    throw UnimplementedError();
  }
}
