class QuestionsEntity {
  final String id;
  final String levelId;
  final String questionText;
  final List<String> options;
  final String explanation;
  final double difficulty;
  final int correctAnswerIndex;

  const QuestionsEntity({
    required this.id, 
    required this.levelId, 
    required this.questionText, 
    required this.options, 
    required this.explanation, 
    required this.difficulty, 
    required this.correctAnswerIndex,
  });
}
