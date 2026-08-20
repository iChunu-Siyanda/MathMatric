class LevelAttempt {
  final String levelId;
  final String topicId;

  final double score;
  final int timeTaken;
  final int correctAnswers;
  final int totalQuestions;

  // questionId -> whether the student answered correctly
  final Map<String, bool> answers;

  const LevelAttempt({
    required this.levelId,
    required this.topicId,
    required this.score,
    required this.timeTaken,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.answers,
  });
}
