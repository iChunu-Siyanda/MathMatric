import 'package:math_matric/features/papers/papers/domain/entities/subject_topic_quiz.dart';

sealed class QuizEvent {
  const QuizEvent();
}

final class StartQuizEvent extends QuizEvent {
  final SubjectTopic subjectTopic;
  final String levelId;

  StartQuizEvent(this.levelId, this.subjectTopic);
}

final class SelectOptionEvent extends QuizEvent {
  final int index;
  SelectOptionEvent({required this.index});
}

final class SubmitAnswerEvent extends QuizEvent {
  SubmitAnswerEvent();
}
