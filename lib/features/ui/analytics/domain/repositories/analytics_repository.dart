import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';

abstract class AnalyticsRepository {
  Future<List<StudySessionEntity>> getStudySessionsSince(
    DateTime? since,
  );

  Future<List<QuestionAttemptEntity>> getQuestionAttemptsSince(
    DateTime? since,
  );

  Future<List<UserLevelProgressEntity>> getLevelProgressSince(
    DateTime? since,
  );

  Future<List<UserTopicProgressEntity>> getTopicProgress();
}
