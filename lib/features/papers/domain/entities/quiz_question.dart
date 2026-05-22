class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String levelId;
  final int scoreValue;

  QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.levelId,
    required this.scoreValue,
  });
}