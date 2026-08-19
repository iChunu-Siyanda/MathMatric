import 'package:firebase_auth/firebase_auth.dart';
import 'package:math_matric/features/progress/questionattempts/domain/repositories/question_atempts_repository.dart';
import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/repositories/user_topic_progress_repository.dart';
import 'package:math_matric/features/sync/user-data-progress/services/sync_progress_coordinator.dart';

class FakeSyncCoordinator implements SyncProgressCoordinator {
  int syncCount = 0;

  @override
  Future<void> syncAll() async {
    syncCount++;
  }

  @override
  UserLevelProgressRepository get levelProgress => throw UnimplementedError();

  @override
  QuestionAttemptRepository get questionAttempts => throw UnimplementedError();

  @override
  StudySessionRepository get studySessions => throw UnimplementedError();

  @override
  UserTopicProgressRepository get topicProgress => throw UnimplementedError();

  @override
  FirebaseAuth get auth => throw UnimplementedError();
}
