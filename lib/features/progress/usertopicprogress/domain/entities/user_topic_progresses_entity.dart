class UserTopicProgressEntity {
  final String id;
  final String topicId;

  final int earnedXP;
  final double mastery;
  final DateTime lastPlayed;
  final bool favorite;

  const UserTopicProgressEntity({
    required this.id,
    required this.topicId,
    required this.earnedXP,
    required this.mastery,
    required this.lastPlayed,
    required this.favorite,
  });
}
