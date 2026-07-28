import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/questions_queries.dart';
import 'package:math_matric/features/curriculum/questions/data/datasource/local/questions_local_datasource.dart';
import 'package:math_matric/features/curriculum/questions/data/models/questions_model.dart';

class QuestionsLocalDatasourceImpl implements QuestionsLocalDatasource{
  final AppDatabase db;
  QuestionsLocalDatasourceImpl(this.db);

  @override
  Future<List<QuestionsModel>> getAllQuestions() async {
    final models = await db.getAllQuestions();
    return models.map((m) => QuestionsModel.fromDrift(m)).toList();
  }

  @override
  Future<QuestionsModel?> getQuestion(String questionId) async {
    final model = await db.getQuestion(questionId);
    return QuestionsModel.fromDrift(model!);
  }

  @override
  Future<int> getQuestionCount(String levelId) async {
    return await db.getQuestionCount(levelId);
  }

  @override
  Future<List<QuestionsModel>> getQuestionsByLevel(String levelId) async {
    final models = await db.getQuestionsByLevel(levelId);
    return models.map((m)=>QuestionsModel.fromDrift(m)).toList();
  }
  
  @override
  Future<int> clearQuestions() {
    return db.clearQuestions();
  }
  
  @override
  Future<void> saveQuestions(List<QuestionsModel> questions) async {
    await db.insertQuestions(
      questions.map(
        (q) => q.toCompanion(1,DateTime.now()),
      )
      .toList(),
    );
  }
}
