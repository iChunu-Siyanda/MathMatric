import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';

abstract class StudySessionRepository {
  Future<List<StudySessionEntity>> getAllStudySessions();

  Future<StudySessionEntity?> getStudySession(
    String sessionId,
  );

  Future<List<StudySessionEntity>> getStudySessionsByTopic(
    String topicId,
  );

  Future<StudySessionEntity?> getLatestStudySession();
}
