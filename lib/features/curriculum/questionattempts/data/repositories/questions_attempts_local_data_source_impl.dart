import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/questions_attempt_queries.dart';
import 'package:math_matric/features/curriculum/questionattempts/data/datasource/local/questions_attempt_local_data_source.dart';
import 'package:math_matric/features/curriculum/questionattempts/data/models/questions_attempt_model.dart';

class QuestionAttemptLocalDataSourceImpl implements QuestionAttemptLocalDataSource {
  final AppDatabase db;
  QuestionAttemptLocalDataSourceImpl(this.db);

  @override
  Future<List<QuestionAttemptModel>> getAllQuestionAttempts() async {
    final rows = await db.getAllQuestionAttempts();

    return rows
        .map(QuestionAttemptModel.fromDrift)
        .toList();
  }

  @override
  Future<QuestionAttemptModel?> getQuestionAttempt(
    String attemptId,
  ) async {
    final row = await db.getQuestionAttempt(
      attemptId,
    );

    if (row == null) return null;

    return QuestionAttemptModel.fromDrift(row);
  }

  @override
  Future<List<QuestionAttemptModel>> getAttemptsByLevel(
    String levelId,
  ) async {
    final rows = await db.getAttemptsByLevel(
      levelId,
    );

    return rows
        .map(QuestionAttemptModel.fromDrift)
        .toList();
  }

  @override
  Future<List<QuestionAttemptModel>> getAttemptsByQuestion(
    String questionId,
  ) async {
    final rows = await db.getAttemptsByQuestion(
      questionId,
    );

    return rows
        .map(QuestionAttemptModel.fromDrift)
        .toList();
  }

  @override
  Future<List<QuestionAttemptModel>> getCorrectAttempts() async {
    final rows = await db.getCorrectAttempts();

    return rows
        .map(QuestionAttemptModel.fromDrift)
        .toList();
  }

  @override
  Future<List<QuestionAttemptModel>> getIncorrectAttempts() async {
    final rows = await db.getIncorrectAttempts();

    return rows
        .map(QuestionAttemptModel.fromDrift)
        .toList();
  }

  @override
  Future<void> saveQuestionAttempts(
    List<QuestionAttemptModel> attempts,
  ) async {
    await db.insertQuestionAttempts(
      attempts
          .map((a) => a.toCompanion())
          .toList(),
    );
  }

  @override
  Future<void> clearQuestionAttempts() async {
    await db.clearQuestionAttempts();
  }

  @override
  Future<int> deleteQuestionAttempt(
    String attemptId,
  ) {
    return db.deleteQuestionAttempt(
      attemptId,
    );
  }
}
