enum SheetVariant {
  topics,
  streak,
}

class StreakContent {
  final String topicTitle;
  final int currentStreak;
  final int bestStreak;

  const StreakContent({
    required this.topicTitle,
    required this.currentStreak,
    required this.bestStreak,
  });
}
