import 'package:math_matric/features/curriculum/topics/data/models/topic_model.dart';

abstract class TopicRemoteDataSource {
  Future<List<TopicModel>> downloadTopics();
}
