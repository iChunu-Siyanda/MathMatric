import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/papers/presentation/bloc/practice/practice_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/practice/practice_event.dart';
import 'package:math_matric/features/papers/presentation/bloc/quiz/quiz_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/quiz/quiz_event.dart';
import 'package:math_matric/features/papers/presentation/bloc/quiz/quiz_state.dart';
import 'package:math_matric/features/papers/presentation/pages/practice/quiz_results.dart';

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
              //Log long-term progress using the PracticeBloc
              context.read<PracticeBloc>().add(
                    CompleteLevel(
                      topicId: topicId,
                      levelId: levelId,
                      xpEarned: state.xpEarned,
                    ),
                  );

              // 2. Direct user to the results presentation page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizResults(
                    score: state.score,
                    totalScore: state.totalScore,
                    getTotalQuestions: (_) => state.questions.length,
                    getQuestionByIndex: (index, _) => state.questions[index],
                    topic: currentTopic,
                    userAnswers: state.userAnswers,
                    selectedIndex: state.selectedIndex,
                    reset: (topic) {
                      context.read<QuizBloc>().add(
                            StartQuizEvent(levelId, topic),
                          );
                    },
                    topicId: topicId,
                    xpEarned: xpEarned,
                    levelId: levelId,
                  ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "$currentQuestionNum / $totalQuestions",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      /// Visual Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: currentQuestionNum / totalQuestions,
                          backgroundColor: Colors.grey.shade200,
                          color: Colors.blue,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 25),

                      /// Scrollable Content Area (Prevents Layout Overflow)
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Question Number Tag
                              Text(
                                "QUESTION $currentQuestionNum",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade500,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 10),

                              /// Question Body Text
                              Text(
                                question,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E293B),
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 25),

                              /// Animated Interactive Options
                              ...List.generate(options.length, (index) {
                                bool isSelected = state.selectedIndex == index;

                                return GestureDetector(
                                  onTap: () {
                                    context.read<QuizBloc>().add(
                                          SelectOptionEvent(index: index),
                                        );
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.blue.withValues(alpha: 0.08) : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected ? Colors.blue : Colors.grey.shade200,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.02),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        /// Container Index Bubble (A, B, C, D)
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected ? Colors.blue : Colors.grey.shade100,
                                          ),
                                          child: Center(
                                            child: Text(
                                              String.fromCharCode(65 + index),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected ? Colors.white : Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),

                                        /// Option Text
                                        Expanded(
                                          child: Text(
                                            options[index],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                              color: isSelected ? Colors.blue.shade900 : const Color(0xFF334155),
                                            ),
                                          ),
                                        ),

                                        /// Custom Check indicator
                                        Icon(
                                          isSelected ? Icons.check_circle : Icons.radio_button_off,
                                          color: isSelected ? Colors.blue : Colors.grey.shade400,
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isOptionSelected
                              ? () => context.read<QuizBloc>().add(SubmitAnswerEvent())
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            disabledBackgroundColor: Colors.grey.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            elevation: isOptionSelected ? 3 : 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            state.isLastQuestion ? "Finish Quiz" : "Next Question",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isOptionSelected ? Colors.white : Colors.black26,
                            ),
                          ),
                        ),
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