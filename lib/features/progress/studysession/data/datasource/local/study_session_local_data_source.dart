import 'package:math_matric/features/progress/studysession/data/models/study_session_model.dart';

abstract class StudySessionLocalDataSource {
  Future<StudySessionModel?> getActiveStudySession();

  Future<void> saveStudySession(
    StudySessionModel session,
  );

  Future<bool> updateStudySessionProgress({
    required String sessionId,
    required int questionsAnswered,
    required int correctAnswers,
    required int earnedXP,
  });

  Future<bool> completeStudySession({
    required String sessionId,
    required DateTime endedAt,
  });

  Future<List<StudySessionModel>> getAllStudySessions();

  Stream<List<StudySessionModel>> watchStudySessions();

  Future<StudySessionModel?> getStudySession(
    String sessionId,
  );

  Future<List<StudySessionModel>> getUnsyncedAttempts();

  Future<void> markAttemptSynced(
    String attemptId,
  );

  Future<List<StudySessionModel>> getStudySessionsByTopic(
    String topicId,
  );

  Future<StudySessionModel?> getLatestStudySession();

  Future<void> saveStudySessions(
    List<StudySessionModel> sessions,
  );

  Future<void> clearStudySessions();

  Future<int> deleteStudySession(
    String sessionId,
  );
}
