import 'package:math_matric/features/progress/studysession/data/models/study_session_model.dart';

abstract class StudySessionLocalDataSource {
  Future<List<StudySessionModel>> getAllStudySessions();

  Stream<List<StudySessionModel>> watchStudySessions();

  Future<StudySessionModel?> getStudySession(
    String sessionId,
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
