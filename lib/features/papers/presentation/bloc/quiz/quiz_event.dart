import 'package:math_matric/features/papers/domain/entities/subject_topic_quiz.dart';

abstract class QuizEvent {
  const QuizEvent();
}

class StartQuizEvent extends QuizEvent {
  final SubjectTopic subjectTopic;
  final String levelId;

  StartQuizEvent(this.levelId, this.subjectTopic);
}

//Triggers when the user taps an A, B, C, or D options.
class SelectOptionEvent extends QuizEvent {
  final int index;
  SelectOptionEvent({required this.index});
}

class SubmitAnswerEvent extends QuizEvent {
  SubmitAnswerEvent();
}
