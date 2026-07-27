import 'package:math_matric/features/curriculum/questions/domain/entities/questions_entity.dart';

abstract class QuestionsRepository {
  Future<List<QuestionsEntity>> getAllQuestions();
  Future<QuestionsEntity?> getQuestion(String questionId);
  Future<List<QuestionsEntity>> getQuestionsByLevel(String levelId);
  Future<int> getQuestionCount(String levelId);
}
