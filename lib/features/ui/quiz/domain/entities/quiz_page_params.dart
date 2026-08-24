import 'package:math_matric/features/ui/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/ui/practice/presentation/bloc/practice_bloc.dart';
import 'package:math_matric/features/ui/quiz/presentation/bloc/quiz_bloc.dart';

class QuizPageParams {
  final String topicId;
  final String currentTopicId;
  final int xp;
  final String levelId;
  final SubjectTopic targetSubjectTopic;
  final QuizBloc quizBloc;
  final PracticeBloc practiceBloc;

  QuizPageParams({
    required this.topicId,
    required this.currentTopicId,
    required this.xp,
    required this.levelId,
    required this.quizBloc,
    required this.practiceBloc, 
    required this.targetSubjectTopic, 
  });
}

