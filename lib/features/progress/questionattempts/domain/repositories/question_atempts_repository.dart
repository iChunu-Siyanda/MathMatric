import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';

abstract class QuestionAttemptRepository {
  Future<void> sync();
  
  Future<List<QuestionAttemptEntity>> getAllQuestionAttempts();

  Future<QuestionAttemptEntity?> getQuestionAttempt(
    String attemptId,
  );

  Future<List<QuestionAttemptEntity>> getAttemptsByLevel(
    String levelId,
  );

  Future<List<QuestionAttemptEntity>> getAttemptsByQuestion(
    String questionId,
  );

  Future<List<QuestionAttemptEntity>> getCorrectAttempts();

  Future<List<QuestionAttemptEntity>> getIncorrectAttempts();
}
