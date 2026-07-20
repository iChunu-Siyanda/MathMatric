import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/papers/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/papers/practice/presentation/bloc/practice_bloc.dart';
import 'package:math_matric/features/papers/quiz/domain/entities/quiz_page_params.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_event.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class RetryQuizBtn extends StatelessWidget {
  final SubjectTopic topic;
  final String topicId;
  final int xpEarned;
  final String levelId;
  final SubjectTopic targetSubjectTopic;

  const RetryQuizBtn({
    super.key,
    required this.topic,
    required this.topicId,
    required this.xpEarned,
    required this.levelId, 
    required this.targetSubjectTopic,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.pushReplacement(
          Routes.quizPage,
          extra: QuizPageParams(
            topicId: topicId, 
            currentTopicId: SubjectTopic.values.byName(topicId).name, 
            xp: xpEarned, 
            levelId: levelId, 
            quizBloc: context.read<QuizBloc>()..add(StartQuizEvent(levelId,topic)), 
            practiceBloc: context.read<PracticeBloc>(), 
            targetSubjectTopic: targetSubjectTopic,
          )
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
