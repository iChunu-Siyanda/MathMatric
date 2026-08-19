import 'package:firebase_auth/firebase_auth.dart';
import 'package:math_matric/features/progress/questionattempts/domain/repositories/question_atempts_repository.dart';
import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/repositories/user_topic_progress_repository.dart';

class SyncProgressCoordinator {
  final FirebaseAuth auth;
  final QuestionAttemptRepository questionAttempts;
  final UserTopicProgressRepository topicProgress;
  final UserLevelProgressRepository levelProgress;
  final StudySessionRepository studySessions;

  SyncProgressCoordinator({
    required this.auth,
    required this.questionAttempts,
    required this.topicProgress,
    required this.levelProgress,
    required this.studySessions,
  });

  Future<void> syncAll() async {
    final user = auth.currentUser;
    if (user == null) return;
    final userId = user.uid;

    await Future.wait([
      questionAttempts.sync(userId),
      topicProgress.sync(userId),
      levelProgress.sync(userId),
      studySessions.sync(userId),
    ]);
  }
}
