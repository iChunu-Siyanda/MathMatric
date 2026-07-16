import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_event.dart';
import 'package:math_matric/features/papers/quiz/presentation/pages/quiz_page.dart';
import 'package:math_matric/shared/registrations/register_quiz_module.dart';

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
              create: (context) => getIt<QuizBloc>()..add(StartQuizEvent(levelId,topic)),
              
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
