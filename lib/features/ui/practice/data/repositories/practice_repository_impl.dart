import 'package:flutter/material.dart';
import 'package:math_matric/features/curriculum/levels/data/datasource/local/levels_local_datasource.dart';
import 'package:math_matric/features/curriculum/levels/data/models/levels_model.dart';
import 'package:math_matric/features/curriculum/topics/data/datasource/local/topic_local_datasource.dart';
import 'package:math_matric/features/ui/practice/domain/entities/practice_level.dart';
import 'package:math_matric/features/ui/practice/domain/entities/practice_topic.dart';
import 'package:math_matric/features/ui/practice/domain/repositories/practice_respository.dart';

class PracticeRepositoryImpl implements PracticeRepository {
  final TopicLocalDataSource topicLocal;
  final LevelsLocalDatasource levelLocal;

  PracticeRepositoryImpl({
    required this.topicLocal,
    required this.levelLocal,
  });

  @override
  Future<List<PracticeTopic>> getPracticeTopics() async {
    final topics = await topicLocal.getAllTopics();

    return topics
        .map((topic) => topic.toEntity())
        .toList();
  }

  @override
  Future<PracticeTopic> getPracticeTopicById(
    String topicId,
  ) async {
    final topic = await topicLocal.getTopic(topicId);

    if (topic == null) {
      throw Exception(
        'Practice topic not found: $topicId',
      );
    }

    return topic.toEntity();
  }

  @override
  Future<List<PracticeLevel>> getLevelsForTopic(
    String topicId,
  ) async {
    final levels = await levelLocal.getLevelsByTopic(
      topicId,
    );

    return levels.map(_toPracticeLevel).toList();
  }

  PracticeLevel _toPracticeLevel(
    LevelsModel level,
  ) {
    return PracticeLevel(
      levelId: level.id,
      topicId: level.topicId,
      title: level.title,
      subtitle: level.subtitle,
      color: Colors.deepPurple,
      xpReward: level.xpReward,
    );
  }
}
