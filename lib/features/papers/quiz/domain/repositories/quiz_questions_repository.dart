import 'package:math_matric/features/papers/quiz/domain/entities/quiz_question.dart';
import 'package:math_matric/features/papers/papers/domain/entities/subject_topic_quiz.dart';

abstract class QuizQuestionsRepository {
    Future<List<QuizQuestion>> getQuizQuestionsForLevel(SubjectTopic subject, String levelId);
}