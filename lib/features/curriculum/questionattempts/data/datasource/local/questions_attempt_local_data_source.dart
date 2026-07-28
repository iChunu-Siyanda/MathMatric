import 'package:math_matric/features/curriculum/questionattempts/data/models/questions_attempt_model.dart';

abstract class QuestionAttemptLocalDataSource {
  Future<List<QuestionAttemptModel>> getAllQuestionAttempts();

  Future<QuestionAttemptModel?> getQuestionAttempt(
    String attemptId,
  );

  Future<List<QuestionAttemptModel>> getAttemptsByLevel(
    String levelId,
  );

  Future<List<QuestionAttemptModel>> getAttemptsByQuestion(
    String questionId,
  );

  Future<List<QuestionAttemptModel>> getCorrectAttempts();

  Future<List<QuestionAttemptModel>> getIncorrectAttempts();

  Future<void> saveQuestionAttempts(
    List<QuestionAttemptModel> attempts,
  );

  Future<void> clearQuestionAttempts();

  Future<int> deleteQuestionAttempt(
    String attemptId,
  );
}
