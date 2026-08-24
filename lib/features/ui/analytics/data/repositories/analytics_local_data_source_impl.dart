import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/userdata/questions_attempt_queries.dart';
import 'package:math_matric/core/database/queries/userdata/study_session_queries.dart';
import 'package:math_matric/core/database/queries/userdata/user_level_progresses_queries.dart';
import 'package:math_matric/core/database/queries/userdata/user_topic_progesses_queries.dart';
import 'package:math_matric/features/ui/analytics/data/datasource/analytics_local_data_source.dart';

class AnalyticsLocalDataSourceImpl implements AnalyticsLocalDataSource {
  final AppDatabase db;
  AnalyticsLocalDataSourceImpl(this.db);

  @override
  Future<List<StudySessionData>> getStudySessionsSince(
    DateTime? since,
  ) {
    return db.getStudySessionsSince(since);
  }

  @override
  Future<List<QuestionAttempt>> getQuestionAttemptsSince(
    DateTime? since,
  ) {
    return db.getQuestionAttemptsSince(since);
  }

  @override
  Future<List<UserLevelProgressesData>> getLevelProgressSince(
    DateTime? since,
  ) {
    return db.getLevelProgressSince(since);
  }

  @override
  Future<List<UserTopicProgressesData>> getTopicProgress() {
    return db.getAllUserTopicProgresses();
  }
}
