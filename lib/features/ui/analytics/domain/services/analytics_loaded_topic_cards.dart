import 'package:math_matric/features/ui/analytics/domain/entites/topic_progress_card_entity.dart';
import 'package:math_matric/features/ui/analytics/presentation/bloc/analytics_state.dart';

extension AnalyticsLoadedTopicCards on AnalyticsLoaded {
  List<TopicProgressCardEntity> get topicProgressCards {
    return topics.map((topic) {
      // Find all levels belonging to this topic
      final topicLevels = levels.where((l) => l.topicId == topic.id).toList();
      
      final completedCount = topicLevels.where((l) => l.completed).length;
      
      final avgScore = topicLevels.isEmpty
          ? 0.0
          : topicLevels.map((l) => l.bestScore).reduce((a, b) => a + b) /
              topicLevels.length;

      // Get the most recent play date
      DateTime? latestPlay;
      for (final l in topicLevels) {
        if (latestPlay == null || l.lastPlayed.isAfter(latestPlay)) {
          latestPlay = l.lastPlayed;
        }
      }

      return TopicProgressCardEntity(
        topic: topic,
        totalLevels: topicLevels.length,
        completedLevels: completedCount,
        averageBestScore: avgScore,
        lastPlayed: latestPlay,
      );
    }).toList()
      ..sort((a, b) => a.completionPercentage.compareTo(b.completionPercentage));
  }
}
