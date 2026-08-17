import 'package:math_matric/features/progress/studysession/data/models/study_session_model.dart';

abstract class StudySessionRemoteDataSource {
  Future<List<StudySessionModel>> getAllStudySessions(
    String userId,
  );

  Future<StudySessionModel?> getStudySession(
    String userId,
    String sessionId,
  );

  Future<void> saveStudySession(
    String userId,
    StudySessionModel session,
  );

  Future<void> saveStudySessions(
    String userId,
    List<StudySessionModel> sessions,
  );

  Future<void> deleteStudySession(
    String userId,
    String sessionId,
  );
}
