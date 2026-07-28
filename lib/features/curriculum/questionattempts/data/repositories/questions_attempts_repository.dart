import 'package:math_matric/features/curriculum/questionattempts/data/datasource/local/questions_attempt_local_data_source.dart';
import 'package:math_matric/features/curriculum/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/curriculum/questionattempts/domain/repositories/question_atempts_repository.dart';

class QuestionAttemptRepositoryImpl implements QuestionAttemptRepository {
  final QuestionAttemptLocalDataSource local;
  QuestionAttemptRepositoryImpl(this.local);

  @override
  Future<List<QuestionAttemptEntity>> getAllQuestionAttempts() async {
    final models = await local.getAllQuestionAttempts();

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<QuestionAttemptEntity?> getQuestionAttempt(
    String attemptId,
  ) async {
    final model = await local.getQuestionAttempt(
      attemptId,
    );

    return model?.toEntity();
  }

  @override
  Future<List<QuestionAttemptEntity>> getAttemptsByLevel(
    String levelId,
  ) async {
    final models = await local.getAttemptsByLevel(
      levelId,
    );

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<List<QuestionAttemptEntity>> getAttemptsByQuestion(
    String questionId,
  ) async {
    final models = await local.getAttemptsByQuestion(
      questionId,
    );

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<List<QuestionAttemptEntity>> getCorrectAttempts() async {
    final models = await local.getCorrectAttempts();

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<List<QuestionAttemptEntity>> getIncorrectAttempts() async {
    final models = await local.getIncorrectAttempts();

    return models
        .map((m) => m.toEntity())
        .toList();
  }
}
