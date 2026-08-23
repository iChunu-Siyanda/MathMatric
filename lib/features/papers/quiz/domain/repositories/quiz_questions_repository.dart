import 'package:math_matric/features/curriculum/questions/domain/entities/questions_entity.dart';

abstract class QuizQuestionsRepository {
  Future<List<QuestionsEntity>> getQuestionsForLevel(
    String levelId,
  );
}
