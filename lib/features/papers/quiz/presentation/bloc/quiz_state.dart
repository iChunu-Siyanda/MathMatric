import 'package:math_matric/features/curriculum/questions/domain/entities/questions_entity.dart';

sealed class QuizState {}

class QuizInitial extends QuizState {}
class QuizLoading extends QuizState {}

final class QuizQuestionsLoaded extends QuizState {
  final List<QuestionsEntity> questions;
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

  QuestionsEntity get currentQuestion => questions[currentIndex];
  bool get isLastQuestion => currentIndex == questions.length - 1;

  QuizQuestionsLoaded copyWith({
    List<QuestionsEntity>? questions,
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

final class QuizFinished extends QuizState {
  final int score;
  final int totalScore;
  final int xpEarned;
  final List<QuestionsEntity> questions;
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

final class QuizError extends QuizState{
  final String message;

  QuizError(this.message);
}
