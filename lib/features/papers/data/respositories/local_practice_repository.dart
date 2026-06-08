import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/data/local/mock_level_data.dart';
import 'package:math_matric/features/papers/data/local/mock_topic_data.dart';
import 'package:math_matric/features/papers/domain/entities/pactice_level.dart';
import 'package:math_matric/features/papers/domain/repositories/practice_respository.dart';
import 'package:math_matric/features/papers/domain/entities/practice_topic.dart';

class LocalPracticeRepository implements PracticeRepository {
  @override
  Future<List<PracticeTopic>> getPracticeTopics() async {
    return mockTopics;
  }

  @override
  Future<PracticeTopic> getPracticeTopicById(String topicId) async {
    debugPrint("🔍 Repo looking for: '$topicId'");
    debugPrint("📋 Available IDs: ${mockTopics.map((t) => t.id).toList()}");
    return mockTopics.firstWhere((t) {
        final cleanMockId = t.id.toLowerCase().replaceAll('_', '');
        final cleanRequestId = topicId.toLowerCase().replaceAll('_', '');
        return cleanMockId == cleanRequestId;
      },
      orElse: () => throw Exception("Could not find topic for ID: $topicId"),
    );
  }

  @override
  Future<List<PracticeLevel>> getLevelsForTopic(String topicId) async {
    return mockLevels.where((level) {
      // Clean both IDs before comparing them
      debugPrint("🔍 getLevelsForTopic Repo looking for: '$topicId'");
      final cleanMockTopicId = level.topicId.toLowerCase().replaceAll('_', '');
      final cleanRequestTopicId = topicId.toLowerCase().replaceAll('_', '');
      
      return cleanMockTopicId == cleanRequestTopicId;
    }).toList();
  }
}
