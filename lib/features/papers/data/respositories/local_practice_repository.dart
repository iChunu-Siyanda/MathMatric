import 'package:math_matric/features/papers/data/local/mock_level_data.dart';
import 'package:math_matric/features/papers/data/local/mock_topic_data.dart';
import 'package:math_matric/features/papers/domain/entities/pactice_level.dart';
import 'package:math_matric/features/papers/domain/respositories/practice_respository.dart';
import 'package:math_matric/features/papers/domain/entities/practice_topic.dart';

class LocalPracticeRepository implements PracticeRepository {
  @override
  Future<List<PracticeTopic>> getPracticeTopics() async {
    return mockTopics;
  }

  @override
  Future<PracticeTopic> getTopicById(String topicId) async {
    return mockTopics.firstWhere((t) => t.id == topicId);
  }

  @override
  Future<List<PracticeLevel>> getLevelsForTopic(String topicId) async {
    return mockLevels
        .where((level) => level.topicId == topicId)
        .toList();
  }
}
