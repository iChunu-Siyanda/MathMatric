import 'package:math_matric/features/papers/data/local/quiz_data_source.dart';
import 'package:math_matric/features/papers/domain/entities/quiz_question.dart';
import 'package:math_matric/features/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/papers/domain/repositories/quiz_questions_repository.dart';

class QuizQuestionsRepositoryImpl implements QuizQuestionsRepository{
  final QuizDataSource quizDataSource;
  QuizQuestionsRepositoryImpl(this.quizDataSource);

  @override
  Future<List<QuizQuestion>> getQuizQuestionsForLevel(SubjectTopic subject, String levelId) async {
    final questions = QuizDataSource.questionBanksP1[subject] ?? [];
    
    return questions.where((q) => q.levelId == levelId).toList();
  }
}