import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/streak/domain/entities/habit_entry.dart';
import 'package:math_matric/features/streak/domain/mapper/habit_entry_mapper.dart';

extension StudySessionQueries on AppDatabase {
  //STUDY SESSION LIFECYCLE:
  Future<StudySessionData?> getActiveStudySession() {
    return (select(studySession)
          ..where((s) => s.endedAt.isNull())
          ..orderBy([
            (s) => OrderingTerm.desc(s.startedAt),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<bool> updateStudySessionProgress({
    required String sessionId,
    required int questionsAnswered,
    required int correctAnswers,
    required int earnedXP,
  }) async {
    final count = await (update(studySession)
          ..where((s) => s.id.equals(sessionId)))
        .write(
      StudySessionCompanion(
        questionsAnswered: Value(questionsAnswered),
        correctAnswers: Value(correctAnswers),
        earnedXP: Value(earnedXP),
        synced: const Value(false),
      ),
    );

    return count > 0;
  }

  Future<bool> completeStudySession({
    required String sessionId,
    required DateTime endedAt,
  }) async {
    final count = await (update(studySession)
          ..where((s) => s.id.equals(sessionId)))
        .write(
      StudySessionCompanion(
        endedAt: Value(endedAt),
        synced: const Value(false),
      ),
    );

    return count > 0;
  }

  //Syncing
  Future<List<StudySessionData>> getUnsyncedStudySessions() {
    return (select(studySession)
          ..where((s) => s.synced.equals(false)))
        .get();
  }

  Future<void> markStudySessionSynced(
    String id,
  ) async {
    await (update(studySession)
          ..where((s) => s.id.equals(id)))
        .write(
      const StudySessionCompanion(
        synced: Value(true),
      ),
    );
  }

  //UI Data
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
  
  Future<bool> hasStudySessions() async {
    final sessions = await getAllStudySessions();

    return sessions.isNotEmpty;
  }

  //Stats
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

  //Updates and Insertions
  Future<int> insertStudySession(
    StudySessionCompanion session,
  ) {
    return into(studySession).insert(session);
  }

  Future<void> insertStudySessions(
    List<StudySessionCompanion> sessions,
  ) {
    return batch((batch) {
      batch.insertAll(studySession, sessions, mode: InsertMode.insertOrReplace,);
    });
  }

  Future<bool> updateStudySession(
    StudySessionData session,
  ) {
    return update(studySession).replace(session);
  }
  
  //Deletions
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
}
