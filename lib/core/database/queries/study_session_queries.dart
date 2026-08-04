import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/streak/domain/entities/habit_entry.dart';
import 'package:math_matric/features/streak/domain/mapper/habit_entry_mapper.dart';

extension StudySessionQueries on AppDatabase {
  Future<List<HabitEntry>> getHabitEntries() async {
    final sessions = await (select(studySession)
          ..orderBy([
            (t) => OrderingTerm.asc(t.startedAt),
          ]))
        .get();

    return HabitEntryMapper.fromStudySessions(sessions);
  }

  Stream<List<StudySessionData>> watchStudySessions() {
    return (select(studySession)
          ..orderBy([
            (t) => OrderingTerm.desc(t.startedAt),
          ]))
        .watch();
  }
  
  Future<List<StudySessionData>> getAllStudySessions() {
    return (select(studySession)
          ..orderBy([
            (s) => OrderingTerm.desc(s.startedAt),
          ]))
        .get();
  }

  Future<StudySessionData?> getStudySession(
    String sessionId,
  ) {
    return (select(studySession)
          ..where((s) => s.id.equals(sessionId)))
        .getSingleOrNull();
  }

  Future<List<StudySessionData>> getStudySessionsByTopic(
    String topicId,
  ) {
    return (select(studySession)
          ..where((s) => s.topicId.equals(topicId))
          ..orderBy([
            (s) => OrderingTerm.desc(s.startedAt),
          ]))
        .get();
  }

  Future<StudySessionData?> getLatestStudySession() {
    return (select(studySession)
          ..orderBy([
            (s) => OrderingTerm.desc(s.startedAt),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> getStudySessionCount() async {
    final query = selectOnly(studySession)
      ..addColumns([studySession.id.count()]);

    final result = await query.getSingle();

    return result.read(studySession.id.count()) ?? 0;
  }

  Future<int> getTotalQuestionsAnswered() async {
    final query = selectOnly(studySession)
      ..addColumns([studySession.questionsAnswered.sum()]);

    final result = await query.getSingle();

    return result.read(studySession.questionsAnswered.sum()) ?? 0;
  }

  Future<int> getTotalCorrectAnswers() async {
    final query = selectOnly(studySession)
      ..addColumns([studySession.correctAnswers.sum()]);

    final result = await query.getSingle();

    return result.read(studySession.correctAnswers.sum()) ?? 0;
  }

  Future<int> getTotalStudyXP() async {
    final query = selectOnly(studySession)
      ..addColumns([studySession.earnedXP.sum()]);

    final result = await query.getSingle();

    return result.read(studySession.earnedXP.sum()) ?? 0;
  }

  Future<int> insertStudySession(
    StudySessionCompanion session,
  ) {
    return into(studySession).insert(session);
  }

  Future<void> insertStudySessions(
    List<StudySessionCompanion> sessions,
  ) {
    return batch((batch) {
      batch.insertAll(studySession, sessions);
    });
  }

  Future<bool> updateStudySession(
    StudySessionData session,
  ) {
    return update(studySession).replace(session);
  }

  Future<int> deleteStudySession(
    String sessionId,
  ) {
    return (delete(studySession)
          ..where((s) => s.id.equals(sessionId)))
        .go();
  }

  Future<int> clearStudySessions() {
    return delete(studySession).go();
  }

  Future<bool> hasStudySessions() async {
    final sessions = await getAllStudySessions();

    return sessions.isNotEmpty;
  }
}
