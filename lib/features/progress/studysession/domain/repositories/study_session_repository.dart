import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';

abstract class StudySessionRepository {
  // Queries:
  Future<List<StudySessionEntity>> getAllStudySessions();

  Stream<List<StudySessionEntity>> watchStudySessions();

  Future<StudySessionEntity?> getStudySession(
    String sessionId,
  );

  Future<List<StudySessionEntity>> getStudySessionsByTopic(
    String topicId,
  );

  Future<StudySessionEntity?> getLatestStudySession();

  // Study Session Lifecycle:
  Future<StudySessionEntity> startSession({
    required String topicId,
    required StudyActivity activity,
  });

  Future<StudySessionEntity?> getActiveStudySession();

  Future<void> updateSessionProgress({
    required String sessionId,
    required int questionsAnswered,
    required int correctAnswers,
    required int earnedXP,
  });

  Future<void> completeSession({
    required String sessionId,
  });
  
  // Sync:
  Future<void> sync(String userId);
}
