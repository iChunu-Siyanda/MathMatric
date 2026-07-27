import 'package:math_matric/features/curriculum/questions/data/models/questions_model.dart';

abstract class QuestionsLocalDatasource {
  Future<List<QuestionsModel>> getAllQuestions();
  Future<QuestionsModel?> getQuestion(String questionId);
  Future<List<QuestionsModel>> getQuestionsByLevel(String levelId);
  Future<int> getQuestionCount(String levelId);
}
