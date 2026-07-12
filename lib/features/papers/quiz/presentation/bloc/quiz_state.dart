import 'package:math_matric/features/papers/quiz/domain/entities/quiz_question.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}
class QuizLoading extends QuizState {}

class QuizQuestionsLoaded extends QuizState {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int score;
  final int totalScore;
  final int selectedIndex; 
  final List<int> userAnswers;

  QuizQuestionsLoaded({
    required this.questions,
    this.currentIndex = 0,
    this.score = 0,
    this.totalScore = 0,
    this.selectedIndex = -1,
    this.userAnswers = const [],
  });

  // Helper getters on the state make UI incredibly clean
  QuizQuestion get currentQuestion => questions[currentIndex];
  bool get isLastQuestion => currentIndex == questions.length - 1;

  QuizQuestionsLoaded copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? score,
    int? totalScore,
    int? selectedIndex,
    List<int>? userAnswers,
  }) {
    return QuizQuestionsLoaded(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      totalScore: totalScore ?? this.totalScore,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      userAnswers: userAnswers ?? this.userAnswers,
    );
  }
}

class QuizFinished extends QuizState {
  final int score;
  final int totalScore;
  final int xpEarned;
  final List<QuizQuestion> questions;
  final List<int> userAnswers;
  final int selectedIndex;

  QuizFinished({
    required this.score,
    required this.totalScore,
    required this.xpEarned,
    required this.questions,
    required this.userAnswers,
    required this.selectedIndex,
  });
}

class QuizError extends QuizState{
  final String message;

  QuizError(this.message);
}
