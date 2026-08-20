import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/questionattempts/domain/repositories/question_atempts_repository.dart';

class FakeQuestionAttemptRepository implements QuestionAttemptRepository {
  List<String> previouslyCorrect = [];
  List<QuestionAttemptEntity> savedAttempts = [];

  @override
  Future<List<String>> getCorrectQuestionIdsByLevel(
    String levelId,
  ) async {
    return previouslyCorrect;
  }

  @override
  Future<void> saveQuestionAttempts(
    List<QuestionAttemptEntity> attempts,
  ) async {
    savedAttempts.addAll(attempts);
  }

  @override
  Future<void> sync(String userId) async {}

  @override
  Future<List<QuestionAttemptEntity>> getAllQuestionAttempts() async {
    return [];
  }

  @override
  Future<QuestionAttemptEntity?> getQuestionAttempt(
    String attemptId,
  ) async {
    return null;
  }

  @override
  Future<List<QuestionAttemptEntity>> getAttemptsByLevel(
    String levelId,
  ) async {
    return [];
  }

  @override
  Future<List<QuestionAttemptEntity>> getAttemptsByQuestion(
    String questionId,
  ) async {
    return [];
  }

  @override
  Future<List<QuestionAttemptEntity>> getCorrectAttempts() async {
    return [];
  }

  @override
  Future<List<QuestionAttemptEntity>> getIncorrectAttempts() async {
    return [];
  }

  @override
  Future<void> saveQuestionAttempt(QuestionAttemptEntity attempt) {
    throw UnimplementedError();
  }
}
