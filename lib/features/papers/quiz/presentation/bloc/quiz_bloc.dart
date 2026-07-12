import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/quiz/domain/usecases/load_quiz_questions_use_case.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_event.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final LoadQuizQuestionsUseCase loadQuizQuestionsUseCase;

  QuizBloc(this.loadQuizQuestionsUseCase) : super(QuizInitial()) {
    on<StartQuizEvent>(_onStartQuiz);
    on<SelectOptionEvent>(_onSelectOption);
    on<SubmitAnswerEvent>(_onSubmitAnswer);
  }

  Future<void> _onStartQuiz(StartQuizEvent event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    try {
      // Use case handles fetching from the repository, NOT the UI querying QuizDataSource
      final questions = await loadQuizQuestionsUseCase(
        subjectTopic: event.subjectTopic, 
        levelId: event.levelId,
      );
      emit(QuizQuestionsLoaded(questions: questions));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  void _onSelectOption(SelectOptionEvent event, Emitter<QuizState> emit) {
    if (state is QuizQuestionsLoaded) {
      final currentState = state as QuizQuestionsLoaded;
      emit(currentState.copyWith(selectedIndex: event.index));
    }
  }

  void _onSubmitAnswer(SubmitAnswerEvent event, Emitter<QuizState> emit) {
    if (state is QuizQuestionsLoaded) {
      final currentState = state as QuizQuestionsLoaded;
      
      // Don't advance if no answer was selected\
      if (currentState.selectedIndex == -1) return;

      final currentQuestion = currentState.currentQuestion;
      
      // Calculate updated score metrics
      int nextScore = currentState.score;
      if (currentState.selectedIndex == currentQuestion.correctAnswerIndex) {
        nextScore++;
      }

      int nextTotalScore = currentState.totalScore + currentQuestion.scoreValue;

      // Inside your QuizBloc's _onSubmitAnswer handler:
      if (currentState.isLastQuestion) {
        final int calculatedXp = nextScore * 10;
        
        // Create the final tracking history list
        final finalAnswers = List<int>.from(currentState.userAnswers)..add(currentState.selectedIndex);

          emit(QuizFinished(
            score: nextScore,
            totalScore: nextTotalScore,
            xpEarned: calculatedXp,
            questions: currentState.questions,
            userAnswers: finalAnswers,
            selectedIndex: currentState.selectedIndex,
          ));
        } else {
        emit(currentState.copyWith(
          currentIndex: currentState.currentIndex + 1,
          score: nextScore,
          totalScore: nextTotalScore,
          selectedIndex: -1, 
        ));
      }
    }
  }
}