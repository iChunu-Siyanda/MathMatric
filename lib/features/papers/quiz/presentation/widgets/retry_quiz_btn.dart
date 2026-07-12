import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/papers/quiz/domain/usecases/load_quiz_questions_use_case.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_event.dart';
import 'package:math_matric/features/papers/practice/presentation/pages/quiz_page.dart';

class RetryQuizBtn extends StatelessWidget {
  final SubjectTopic topic;
  final String topicId;
  final int xpEarned;
  final String levelId;

  const RetryQuizBtn({
    super.key,
    required this.topic,
    required this.topicId,
    required this.xpEarned,
    required this.levelId,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => QuizBloc(
                context.read<LoadQuizQuestionsUseCase>(),
              )..add(StartQuizEvent(levelId,topic)), // 2. Immediately fire start event
              
              child: QuizPage(
                topicId: topicId,
                xpEarned: xpEarned,
                levelId: levelId,
              ),
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text(
        "Retry Quiz",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}