class HabitSummary {
  final int currentStreak;
  final int longestStreak;
  final int weeklyProgressScore;

  const HabitSummary({
    required this.currentStreak,
    required this.longestStreak,
    required this.weeklyProgressScore,
  });

  factory HabitSummary.initial() {
    return const HabitSummary(
      currentStreak: 0,
      longestStreak: 0,
      weeklyProgressScore: 0,
    );
  }

  HabitSummary copyWith({
    int? currentStreak,
    int? longestStreak,
    int? weeklyProgressScore,
  }) {
    return HabitSummary(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      weeklyProgressScore: weeklyProgressScore ?? this.weeklyProgressScore,
    );
  }
}
