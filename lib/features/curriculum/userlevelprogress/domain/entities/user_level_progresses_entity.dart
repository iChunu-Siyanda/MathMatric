class UserLevelProgressEntity {
  final String id;
  final String levelId;
  final String topicId;

  final bool completed;
  final int earnedXP;
  final double bestScore;
  final int attempts;

  final DateTime? completedAt;
  final DateTime lastPlayed;

  const UserLevelProgressEntity({
    required this.id,
    required this.levelId,
    required this.topicId,
    required this.completed,
    required this.earnedXP,
    required this.bestScore,
    required this.attempts,
    required this.completedAt,
    required this.lastPlayed,
  });
}
