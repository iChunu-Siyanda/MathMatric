import 'package:math_matric/features/progress/questionattempts/data/models/questions_attempt_model.dart';
import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/studysession/data/models/study_session_model.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/models/user_level_progresses_model.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/models/user_topic_progresses_model.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';
import 'package:math_matric/features/ui/analytics/data/datasource/analytics_local_data_source.dart';
import 'package:math_matric/features/ui/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsLocalDataSource local;
  AnalyticsRepositoryImpl(this.local);

  @override
  Future<List<StudySessionEntity>> getStudySessionsSince(
    DateTime? since,
  ) async {
    final models = await local.getStudySessionsSince(since);

    return models
        .map((m) => StudySessionModel.fromDrift(m).toEntity())
        .toList();
  }

  @override
  Future<List<UserLevelProgressEntity>> getLevelProgressSince(DateTime? since) async {
    final models = await local.getLevelProgressSince(since);

    return models
        .map((m) => UserLevelProgressModel.fromDrift(m).toEntity())
        .toList();
  }

  @override
  Future<List<QuestionAttemptEntity>> getQuestionAttemptsSince(DateTime? since) async {
    final models = await local.getQuestionAttemptsSince(since);

    return models
        .map((m) => QuestionAttemptModel.fromDrift(m).toEntity())
        .toList();
  }

  @override
  Future<List<UserTopicProgressEntity>> getTopicProgress() async {
    final models = await local.getTopicProgress();

    return models
        .map((m) => UserTopicProgressModel.fromDrift(m).toEntity())
        .toList();
  }
}
