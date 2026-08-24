import 'package:math_matric/features/curriculum/questions/data/datasource/local/questions_local_datasource.dart';
import 'package:math_matric/features/curriculum/questions/domain/entities/questions_entity.dart';
import 'package:math_matric/features/ui/quiz/domain/repositories/quiz_questions_repository.dart';

class QuizQuestionsRepositoryImpl implements QuizQuestionsRepository {
  final QuestionsLocalDatasource local;
  QuizQuestionsRepositoryImpl(this.local);

  @override
  Future<List<QuestionsEntity>> getQuestionsForLevel(
    String levelId,
  ) async {
    final questions = await local.getQuestionsByLevel(levelId);

    return questions
        .map((question) => question.toEntity())
        .toList();
  }
}
