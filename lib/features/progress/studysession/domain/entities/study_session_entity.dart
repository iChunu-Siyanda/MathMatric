class StudySessionEntity {
  final String id;
  final String topicId;

  final DateTime startedAt;
  final DateTime endedAt;

  final int questionsAnswered;
  final int correctAnswers;
  final int earnedXP;

  const StudySessionEntity({
    required this.id,
    required this.topicId,
    required this.startedAt,
    required this.endedAt,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.earnedXP,
  });
}
