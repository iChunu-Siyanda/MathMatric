import 'package:math_matric/features/progress/studysession/data/datasource/local/study_session_local_data_source.dart';
import 'package:math_matric/features/progress/studysession/data/datasource/remote/study_session_remote_data_source.dart';
import 'package:math_matric/features/progress/studysession/data/models/study_session_model.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';
import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';
import 'package:math_matric/shared/services/app_clock.dart';
import 'package:math_matric/shared/services/id_generator.dart';

class StudySessionRepositoryImpl implements StudySessionRepository {
  final StudySessionLocalDataSource local;
  final StudySessionRemoteDataSource remote;
  final AppClock clock;
  final IdGenerator idGenerator;
  
  StudySessionRepositoryImpl(
    this.local,
    this.remote, 
    this.clock, 
    this.idGenerator,
  );


  // QUERIES:
  @override
  Future<List<StudySessionEntity>> getAllStudySessions() async {
    final models = await local.getAllStudySessions();

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<StudySessionEntity?> getStudySession(
    String sessionId,
  ) async {
    final model = await local.getStudySession(
      sessionId,
    );

    return model?.toEntity();
  }

  @override
  Future<List<StudySessionEntity>> getStudySessionsByTopic(
    String topicId,
  ) async {
    final models = await local.getStudySessionsByTopic(
      topicId,
    );

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<StudySessionEntity?> getLatestStudySession() async {
    final model = await local.getLatestStudySession();

    return model?.toEntity();
  }
  
  @override
  Stream<List<StudySessionEntity>> watchStudySessions() {
    final model = local.watchStudySessions();
    return model.map((rows) => rows.map((m) => m.toEntity()).toList());
  }

  // SYNC:
  @override
  Future<void> sync(String userId) async {
    final unsynced = await local.getUnsyncedAttempts();
    if (unsynced.isEmpty) return;

    await remote.saveStudySessions(
      userId,
      unsynced,
    ); 
    for (final session in unsynced) {
      await local.markAttemptSynced(
        session.id,
      );
    }
  }

  // STUDY SESSION LIFECYCLE:
  @override
  Future<StudySessionEntity?> getActiveStudySession() async {
    final model = await local.getActiveStudySession();

    return model?.toEntity();
  }

  @override
  Future<StudySessionEntity> startSession({
    required String topicId,
    required StudyActivity activity,
  }) async {
    final session = StudySessionModel(
      id: idGenerator.generate(),
      topicId: topicId,
      activity: activity,
      startedAt: clock.now(),
      endedAt: null,
      questionsAnswered: 0,
      correctAnswers: 0,
      earnedXP: 0,
      synced: false, 
      updatedAt: clock.now(),
    );

    await local.saveStudySession(session);

    return session.toEntity();
  }

  @override
  Future<void> updateSessionProgress({
    required String sessionId,
    required int questionsAnswered,
    required int correctAnswers,
    required int earnedXP,
  }) async {
    final updated = await local.updateStudySessionProgress(
      sessionId: sessionId,
      questionsAnswered: questionsAnswered,
      correctAnswers: correctAnswers,
      earnedXP: earnedXP,
    );

    if (!updated) {
      throw Exception(
        'Study session $sessionId could not be updated.',
      );
    }
  }

  @override
  Future<void> completeSession({
    required String sessionId,
  }) async {
    final updated = await local.completeStudySession(
      sessionId: sessionId,
      endedAt: clock.now(),
    );

    if (!updated) {
      throw Exception(
        'Study session $sessionId could not be completed.',
      );
    }
  }     
}
