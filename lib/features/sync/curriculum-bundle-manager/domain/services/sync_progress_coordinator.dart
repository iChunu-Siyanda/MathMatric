import 'package:math_matric/features/progress/questionattempts/domain/repositories/question_atempts_repository.dart';
import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/repositories/user_topic_progress_repository.dart';

class SyncProgressCoordinator {
  final QuestionAttemptRepository questionAttempts;
  final UserTopicProgressRepository topicProgress;
  final UserLevelProgressRepository levelProgress;
  final StudySessionRepository studySessions;

  SyncProgressCoordinator({
    required this.questionAttempts,
    required this.topicProgress,
    required this.levelProgress,
    required this.studySessions,
  });

  Future<void> syncAll() async {
    await Future.wait([
      questionAttempts.sync(),
      topicProgress.sync(),
      levelProgress.sync(),
      studySessions.sync(),
    ]);
  }
}
