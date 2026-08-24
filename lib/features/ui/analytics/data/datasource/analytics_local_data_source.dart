import 'package:math_matric/core/database/app_database.dart';

abstract class AnalyticsLocalDataSource {
  Future<List<StudySessionData>> getStudySessionsSince(DateTime? since);

  Future<List<QuestionAttempt>> getQuestionAttemptsSince(DateTime? since);

  Future<List<UserLevelProgressesData>> getLevelProgressSince(DateTime? since);

  Future<List<UserTopicProgressesData>> getTopicProgress();
}
