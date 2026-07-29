import 'package:math_matric/features/curriculum/topics/data/repositories/topic_local_datasource_impl.dart';
import 'package:math_matric/features/curriculum/topics/domain/repositories/topic_repository.dart';
import 'package:math_matric/features/papers/practice/domain/entities/practice_topic.dart';

class TopicRepositoryImpl implements TopicRepository{
  final TopicLocalDataSourceImpl local;
  TopicRepositoryImpl(this.local);

  @override
  Future<List<PracticeTopic>> getAllTopics() async {
    final models = await local.getAllTopics();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<PracticeTopic?> getTopic(String topicId) async {
    final model = await local.getTopic(topicId);
    return model!.toEntity();
  }

  @override
  Future<List<PracticeTopic>> getTopicsBySubject(String subjectId) async {
    final models = await local.getTopicsBySubject(subjectId);
    return models.map((m) => m.toEntity()).toList();
  }
}
