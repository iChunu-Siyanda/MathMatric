import 'package:math_matric/features/papers/domain/entities/practice_topic_data.dart';
import 'package:math_matric/features/papers/domain/entities/quiz_question.dart';
import 'package:math_matric/features/papers/domain/entities/subject_topic_quiz.dart';

abstract class PracticeState {
  const PracticeState();
}

class PracticeInitial extends PracticeState {
  const PracticeInitial();
}

class PracticeLoading extends PracticeState {
  const PracticeLoading();
}

class PracticeLoaded extends PracticeState {
  final PracticeTopicData data;

  PracticeLoaded(this.data);
}

class PracticeQuestionsLoaded extends PracticeState {
  final Map<SubjectTopic, List<QuizQuestion>> quizQuestionData;

  PracticeQuestionsLoaded(this.quizQuestionData);
}

class PracticeError extends PracticeState {
  final String message;

  PracticeError(this.message);
}
