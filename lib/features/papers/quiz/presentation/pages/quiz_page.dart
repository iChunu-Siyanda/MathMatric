import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/papers/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/papers/practice/presentation/bloc/practice_bloc.dart';
import 'package:math_matric/features/papers/practice/presentation/bloc/practice_event.dart';
import 'package:math_matric/features/papers/quiz/domain/entities/quiz_results_params.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_state.dart';
import 'package:math_matric/features/papers/quiz/presentation/widgets/quiz_content_area.dart';
import 'package:math_matric/features/papers/quiz/presentation/widgets/quiz_next_btn.dart';
import 'package:math_matric/features/papers/quiz/presentation/widgets/quiz_page_back_btn.dart';
import 'package:math_matric/features/papers/quiz/presentation/widgets/visual_progress_bar.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class QuizPage extends StatelessWidget {
  final String topicId;
  final int xpEarned;
  final String levelId;

  const QuizPage({
    super.key,
    required this.topicId,
    required this.xpEarned,
    required this.levelId,
  });

  @override
  Widget build(BuildContext context) {
    final currentTopic = SubjectTopic.values.byName(topicId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: BlocListener<QuizBloc, QuizState>(
          listener: (context, state) {
            if (state is QuizFinished) {
              context.read<PracticeBloc>().add(
                CompleteLevel(
                  topicId: topicId,
                  levelId: levelId,
                  xpEarned: state.xpEarned,
                ),
              );

              // debugPrint("Questions Length: ${state.questions.length}");
              // debugPrint("Answers Length: ${state.userAnswers.length}");

              // debugPrint("Answers: ${state.userAnswers}");
              // for (int i = 0; i < state.questions.length; i++) {
              //   debugPrint(
              //     "Q$i: correct=${state.questions[i].correctAnswerIndex}, "
              //     "user=${state.userAnswers[i]}",
              //   );
              // }    

              context.pushReplacement(
                Routes.quizResults,
                extra: QuizResultsParams(
                  score: state.score, 
                  totalScore: state.totalScore, 
                  selectedIndex: state.selectedIndex, 
                  getTotalQuestions: (_) => state.questions.length, 
                  getQuestionByIndex: (index, _) => state.questions[index],  
                  userAnswers: state.userAnswers, 
                  topicId: topicId, 
                  xpEarned: xpEarned, 
                  levelId: levelId,
                  topic: currentTopic, 
                ),
              ); 
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: BlocBuilder<QuizBloc, QuizState>(
              builder: (context, state) {
                if (state is QuizLoading || state is QuizInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is QuizQuestionsLoaded) {
                  final question = state.currentQuestion.questionText;
                  final options = state.currentQuestion.options;
                  final totalQuestions = state.questions.length;
                  final currentQuestionNum = state.currentIndex + 1;
                  final isOptionSelected = state.selectedIndex != -1;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Action Bar (Back button + Progress tracking text)
                      QuizPageBackBtn(
                        currentQuestionNum: currentQuestionNum, 
                        totalQuestions: totalQuestions,
                      ),
                      const SizedBox(height: 15),

                      // Visual Progress Bar
                      VisualProgressBar(
                        currentQuestionNum: currentQuestionNum, 
                        totalQuestions: totalQuestions,
                      ),
                      const SizedBox(height: 25),

                      // Scrollable Content Area (Prevents Layout Overflow)
                      Expanded(
                        child: QuizContentArea(
                          currentQuestionNum: currentQuestionNum, 
                          question: question, 
                          options: options, 
                          selectedIndex: state.selectedIndex,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      //Quiz next & submit btn
                      QuizNextBtn(
                        isOptionSelected: isOptionSelected, 
                        isLastQuestion: state.isLastQuestion,
                      ),
                    ],
                  );
                }

                if (state is QuizError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
