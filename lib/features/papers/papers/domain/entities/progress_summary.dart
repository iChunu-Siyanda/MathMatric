class ProgressSummary {
  final int completedTopics;
  final int totalTopics;
  final int currentStreak;
  final int bestStreak;

  const ProgressSummary({
    required this.completedTopics,
    required this.totalTopics,
    required this.currentStreak,
    required this.bestStreak,
  });

  double get progress {
    if (totalTopics == 0) return 0;
    return (completedTopics / totalTopics).clamp(0.0, 1.0);
  }
}
