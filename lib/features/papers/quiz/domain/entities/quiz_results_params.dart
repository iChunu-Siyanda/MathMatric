import 'package:math_matric/features/papers/papers/domain/entities/subject_topic_quiz.dart';

class QuizResultsParams {
  final int score;
  final int totalScore;
  final int selectedIndex;
  final Function getTotalQuestions;
  final Function getQuestionByIndex;
  final SubjectTopic topic;
  final List<int> userAnswers;
  final String topicId;
  final int xpEarned;
  final String levelId;

  QuizResultsParams({
    required this.score, 
    required this.totalScore, 
    required this.selectedIndex, 
    required this.getTotalQuestions, 
    required this.getQuestionByIndex, 
    required this.userAnswers, 
    required this.topicId, 
    required this.xpEarned, 
    required this.levelId, 
    required this.topic, 
  });
}
