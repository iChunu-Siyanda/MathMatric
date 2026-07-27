import 'package:math_matric/features/papers/practice/data/models/topic_model.dart';

abstract class TopicRemoteDataSource {
  Future<List<TopicModel>> downloadTopics();
}
