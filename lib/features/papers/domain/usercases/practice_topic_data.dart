import 'package:math_matric/features/papers/domain/entities/pactice_level.dart';
import 'package:math_matric/features/papers/domain/entities/practice_topic.dart';

class PracticeTopicData {
  final PracticeTopic topic;
  final List<PracticeLevel> levels;
  final int earnedXp;
  final int totalXp;
  final double progress;

  const PracticeTopicData({
    required this.topic,
    required this.levels,
    required this.earnedXp,
    required this.totalXp,
    required this.progress,
  });
}
