class QuestionAttemptEntity {
  final String id;
  final String levelId;
  final String questionId;

  final bool correct;

  final int timeTaken;
  final DateTime answeredAt;

  const QuestionAttemptEntity({
    required this.id,
    required this.levelId,
    required this.questionId,
    required this.correct,
    required this.timeTaken,
    required this.answeredAt,
  });
}
