import 'package:math_matric/features/curriculum/questions/data/repositories/questions_local_datasource_impl.dart';
import 'package:math_matric/features/curriculum/questions/domain/entities/questions_entity.dart';
import 'package:math_matric/features/curriculum/questions/domain/repositories/questions_repository.dart';

class QuestionsRepositoryImpl implements QuestionsRepository{
  final QuestionsLocalDatasourceImpl local;
  QuestionsRepositoryImpl(this.local);

  @override
  Future<List<QuestionsEntity>> getAllQuestions() async {
    final models = await local.getAllQuestions();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<QuestionsEntity?> getQuestion(String questionId) async {
    final model = await local.getQuestion(questionId);
    return model!.toEntity();
  }

  @override
  Future<int> getQuestionCount(String levelId) async {
    return await local.getQuestionCount(levelId);
  }

  @override
  Future<List<QuestionsEntity>> getQuestionsByLevel(String levelId) async {
    final models = await local.getQuestionsByLevel(levelId);
    return models.map((m) => m.toEntity()).toList();
  }
}
