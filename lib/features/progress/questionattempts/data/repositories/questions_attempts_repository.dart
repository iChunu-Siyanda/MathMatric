import 'package:math_matric/features/progress/questionattempts/data/datasource/local/questions_attempt_local_data_source.dart';
import 'package:math_matric/features/progress/questionattempts/data/datasource/remote/question_attempt_remote_data_source.dart';
import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/questionattempts/domain/repositories/question_atempts_repository.dart';

class QuestionAttemptRepositoryImpl implements QuestionAttemptRepository {
  final QuestionAttemptLocalDataSource local;
  final QuestionAttemptRemoteDataSource remote;
  QuestionAttemptRepositoryImpl(
    this.local, 
    this.remote,
  );

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

  @override
  Future<void> sync(String userId) async {
    final unsynced = await local.getUnsyncedAttempts();
    if (unsynced.isEmpty) return;

    await remote.saveQuestionAttempts(
      userId,
      unsynced,
    );

    for (final attempt in unsynced) {
      await local.markAttemptSynced(attempt.id);
    }
  }
}
