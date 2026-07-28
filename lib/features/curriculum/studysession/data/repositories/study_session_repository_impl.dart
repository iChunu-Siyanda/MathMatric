import 'package:math_matric/features/curriculum/studysession/data/datasource/local/study_session_local_data_source.dart';
import 'package:math_matric/features/curriculum/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/curriculum/studysession/domain/repositories/study_session_repository.dart';

class StudySessionRepositoryImpl implements StudySessionRepository {
  final StudySessionLocalDataSource local;
  StudySessionRepositoryImpl(this.local);

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
}
