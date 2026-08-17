import 'package:math_matric/features/progress/questionattempts/data/models/questions_attempt_model.dart';

abstract class QuestionAttemptRemoteDataSource {
  Future<List<QuestionAttemptModel>> getAllQuestionAttempts(
    String userId,
  );

  Future<QuestionAttemptModel?> getQuestionAttempt(
    String userId,
    String attemptId,
  );

  Future<void> saveQuestionAttempt(
    String userId,
    QuestionAttemptModel attempt,
  );

  Future<void> saveQuestionAttempts(
    String userId,
    List<QuestionAttemptModel> attempts,
  );

  Future<void> deleteQuestionAttempt(
    String userId,
    String attemptId,
  );
}
