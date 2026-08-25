import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/repositories/analytics_repository.dart';

class FakeAnalyticsRepository implements AnalyticsRepository {

  DateTime? lastStudySessionsSince;
  DateTime? lastQuestionAttemptsSince;
  DateTime? lastLevelProgressSince;

  @override
  Future<List<StudySessionEntity>> getStudySessionsSince(
    DateTime? since,
  ) async {
    lastStudySessionsSince = since;
    return [];
  }

  @override
  Future<List<QuestionAttemptEntity>> getQuestionAttemptsSince(
    DateTime? since,
  ) async {
    lastQuestionAttemptsSince = since;
    return [];
  }

  @override
  Future<List<UserLevelProgressEntity>> getLevelProgressSince(
    DateTime? since,
  ) async {
    lastLevelProgressSince = since;
    return [];
  }

  @override
  Future<List<UserTopicProgressEntity>> getTopicProgress() async {
    return [];
  }
}
