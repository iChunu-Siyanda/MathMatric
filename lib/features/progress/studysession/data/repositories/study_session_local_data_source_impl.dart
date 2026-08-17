import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/userdata/study_session_queries.dart';
import 'package:math_matric/features/progress/studysession/data/datasource/local/study_session_local_data_source.dart';
import 'package:math_matric/features/progress/studysession/data/models/study_session_model.dart';

class StudySessionLocalDataSourceImpl implements StudySessionLocalDataSource {
  final AppDatabase db;
  StudySessionLocalDataSourceImpl(this.db);

  @override
  Future<List<StudySessionModel>> getAllStudySessions() async {
    final rows = await db.getAllStudySessions();

    return rows
        .map(StudySessionModel.fromDrift)
        .toList();
  }

  @override
  Future<StudySessionModel?> getStudySession(
    String sessionId,
  ) async {
    final row = await db.getStudySession(
      sessionId,
    );

    if (row == null) return null;

    return StudySessionModel.fromDrift(row);
  }

  @override
  Future<List<StudySessionModel>> getStudySessionsByTopic(
    String topicId,
  ) async {
    final rows = await db.getStudySessionsByTopic(
      topicId,
    );

    return rows
        .map(StudySessionModel.fromDrift)
        .toList();
  }

  @override
  Future<StudySessionModel?> getLatestStudySession() async {
    final row = await db.getLatestStudySession();

    if (row == null) return null;

    return StudySessionModel.fromDrift(row);
  }

  @override
  Future<void> saveStudySessions(
    List<StudySessionModel> sessions,
  ) async {
    await db.insertStudySessions(
      sessions
          .map((s) => s.toCompanion())
          .toList(),
    );
  }

  @override
  Future<void> clearStudySessions() async {
    await db.clearStudySessions();
  }

  @override
  Future<int> deleteStudySession(
    String sessionId,
  ) {
    return db.deleteStudySession(
      sessionId,
    );
  }
  
  @override
  Stream<List<StudySessionModel>> watchStudySessions() {
    final model = db.watchStudySessions(); 
    return model.map((rows) => rows.map((m) => StudySessionModel.fromDrift(m)).toList());
  }

  @override
  Future<List<StudySessionModel>> getUnsyncedAttempts() async {
    final rows = await db.getUnsyncedStudySessions();

    return rows
          .map(StudySessionModel.fromDrift)
          .toList();
  }

  @override
  Future<void> markAttemptSynced(String attemptId) {
    return db.markStudySessionSynced(attemptId);
  }
}
