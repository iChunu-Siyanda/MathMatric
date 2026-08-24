import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';

extension QuestionAttemptsQueries on AppDatabase {
  Future<List<QuestionAttempt>> getAllQuestionAttempts() {
    return (select(questionAttempts)
          ..orderBy([
            (a) => OrderingTerm.desc(a.answeredAt),
          ]))
        .get();
  }

  Future<QuestionAttempt?> getQuestionAttempt(
    String attemptId,
  ) {
    return (select(questionAttempts)
          ..where((a) => a.id.equals(attemptId)))
        .getSingleOrNull();
  }

  Future<List<String>> getCorrectQuestionIdsByLevel(
    String levelId,
  ) async {
    final rows = await (select(questionAttempts)
          ..where(
            (a) =>
                a.levelId.equals(levelId) &
                a.correct.equals(true),
          ))
        .get();

    return rows
        .map((row) => row.questionId)
        .toList();
  }

  //Syncing
  Future<List<QuestionAttempt>> getUnsyncedQuestionAttempts() {
    return (select(questionAttempts)
          ..where((a) => a.synced.equals(false)))
        .get();
  }

  Future<void> markQuestionAttemptSynced(
    String attemptId,
  ) async {
    await (update(questionAttempts)
          ..where((a) => a.id.equals(attemptId)))
        .write(
      const QuestionAttemptsCompanion(
        synced: Value(true),
      ),
    );
  }

  // Stats
  Future<List<QuestionAttempt>> getQuestionAttemptsSince(
    DateTime? since,
  ) {
    final query = select(questionAttempts);

    if (since != null) {
      query.where(
        (q) => q.answeredAt.isBiggerOrEqualValue(since),
      );
    }

    query.orderBy([
      (q) => OrderingTerm.desc(q.answeredAt),
    ]);

    return query.get();
  }

  Future<List<QuestionAttempt>> getAttemptsByLevel(
    String levelId,
  ) {
    return (select(questionAttempts)
          ..where((a) => a.levelId.equals(levelId))
          ..orderBy([
            (a) => OrderingTerm.desc(a.answeredAt),
          ]))
        .get();
  }

  Future<List<QuestionAttempt>> getAttemptsByQuestion(
    String questionId,
  ) {
    return (select(questionAttempts)
          ..where((a) => a.questionId.equals(questionId))
          ..orderBy([
            (a) => OrderingTerm.desc(a.answeredAt),
          ]))
        .get();
  }

  Future<List<QuestionAttempt>> getCorrectAttempts() {
    return (select(questionAttempts)
          ..where((a) => a.correct.equals(true))
          ..orderBy([
            (a) => OrderingTerm.desc(a.answeredAt),
          ]))
        .get();
  }

  Future<List<QuestionAttempt>> getIncorrectAttempts() {
    return (select(questionAttempts)
          ..where((a) => a.correct.equals(false))
          ..orderBy([
            (a) => OrderingTerm.desc(a.answeredAt),
          ]))
        .get();
  }

  Future<bool> hasQuestionAttempts() async {
    final attempts = await getAllQuestionAttempts();

    return attempts.isNotEmpty;
  }

  Future<int> getAttemptCount() async {
    final query = selectOnly(questionAttempts)
      ..addColumns([questionAttempts.id.count()]);

    final result = await query.getSingle();

    return result.read(questionAttempts.id.count()) ?? 0;
  }

  Future<int> getAttemptCountByLevel(
    String levelId,
  ) async {
    final query = selectOnly(questionAttempts)
      ..addColumns([questionAttempts.id.count()])
      ..where(questionAttempts.levelId.equals(levelId));

    final result = await query.getSingle();

    return result.read(questionAttempts.id.count()) ?? 0;
  }

  Future<int> getCorrectAttemptCount(
    String levelId,
  ) async {
    final query = selectOnly(questionAttempts)
      ..addColumns([questionAttempts.id.count()])
      ..where(
        questionAttempts.levelId.equals(levelId) &
            questionAttempts.correct.equals(true),
      );

    final result = await query.getSingle();

    return result.read(questionAttempts.id.count()) ?? 0;
  }

  Future<double> getAverageTimeForLevel(
    String levelId,
  ) async {
    final query = selectOnly(questionAttempts)
      ..addColumns([questionAttempts.timeTaken.avg()])
      ..where(questionAttempts.levelId.equals(levelId));

    final result = await query.getSingle();

    return result.read(questionAttempts.timeTaken.avg()) ?? 0.0;
  }

  // Upadates and insertions
  Future<int> insertQuestionAttempt(
    QuestionAttemptsCompanion attempt,
  ) {
    return into(questionAttempts).insert(attempt);
  }

  Future<void> insertQuestionAttempts(
    List<QuestionAttemptsCompanion> attempts,
  ) {
    return batch((batch) {
      batch.insertAll(questionAttempts, attempts, mode: InsertMode.insertOrReplace,);
    });
  }

  Future<bool> updateQuestionAttempt(
    QuestionAttempt attempt,
  ) {
    return update(questionAttempts).replace(attempt);
  }

  //Deletion
  Future<int> deleteQuestionAttempt(
    String attemptId,
  ) {
    return (delete(questionAttempts)
          ..where((a) => a.id.equals(attemptId)))
        .go();
  }

  Future<int> deleteAttemptsByLevel(
    String levelId,
  ) {
    return (delete(questionAttempts)
          ..where((a) => a.levelId.equals(levelId)))
        .go();
  }

  Future<int> deleteAttemptsByQuestion(
    String questionId,
  ) {
    return (delete(questionAttempts)
          ..where((a) => a.questionId.equals(questionId)))
        .go();
  }

  Future<int> clearQuestionAttempts() {
    return delete(questionAttempts).go();
  }
}
