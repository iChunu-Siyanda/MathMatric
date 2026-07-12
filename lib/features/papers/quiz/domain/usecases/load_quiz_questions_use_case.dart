import 'package:math_matric/features/papers/quiz/domain/entities/quiz_question.dart';
import 'package:math_matric/features/papers/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/papers/quiz/domain/repositories/quiz_questions_repository.dart';

class LoadQuizQuestionsUseCase{
  final QuizQuestionsRepository quizRepository;
  LoadQuizQuestionsUseCase(this.quizRepository);

  Future<List<QuizQuestion>> call({
    required SubjectTopic subjectTopic,
    required String levelId,
  }) async {
    return await quizRepository.getQuizQuestionsForLevel(subjectTopic, levelId);
  }
}


