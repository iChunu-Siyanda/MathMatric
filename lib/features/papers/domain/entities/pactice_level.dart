import 'dart:ui';

class PracticeLevel {
  final String id;
  final String topicId;
  final String title;
  final String subtitle;
  //final IconData icon;
  final Color color;
  final int xpReward;
  final bool isCompleted;
  final bool isUnlocked;
  final double progress;

  PracticeLevel({
    required this.id,
    required this.topicId,
    required this.title,
    required this.subtitle,
   // required this.icon,
    required this.color,
    required this.xpReward,
    this.isCompleted = false,
    this.isUnlocked = false,
    this.progress = 0.0,
  });

  PracticeLevel copyWith({
    String? id,
    String? topicId,
    String? title,
    String? subtitle,
   // IconData? icon,
    Color? color,
    int? xpReward,
    bool? isCompleted,
    bool? isUnlocked,
    double? progress,
  }) {
    return PracticeLevel(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
    //  icon: icon ?? this.icon,
      color: color ?? this.color,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      progress: progress ?? this.progress,
    );
  }
}
