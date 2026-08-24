import 'dart:ui';

import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/ui/practice/domain/entities/practice_topic.dart';

class TopicProgressCardEntity {
  final PracticeTopic topic;
  final int totalLevels;
  final int completedLevels;
  final double averageBestScore; // 0.0 to 1.0
  final DateTime? lastPlayed;

  const TopicProgressCardEntity({
    required this.topic,
    required this.totalLevels,
    required this.completedLevels,
    required this.averageBestScore,
    this.lastPlayed,
  });

  //Calculate completion rate (0-100%)
  double get completionPercentage => totalLevels == 0 ? 0.0 : (completedLevels / totalLevels) * 100;

  Color get accentColor {
    if (averageBestScore >= 0.80) return AppColours.correctGreen;
    if (averageBestScore >= 0.50) return AppColours.warningAmber;
    //return AppColours.neonCoral/red
    return AppColours.electricViolet;
  }
}
