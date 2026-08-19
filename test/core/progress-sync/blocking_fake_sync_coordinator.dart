import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:math_matric/features/progress/questionattempts/domain/repositories/question_atempts_repository.dart';
import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/repositories/user_topic_progress_repository.dart';
import 'package:math_matric/features/sync/user-data-progress/services/sync_progress_coordinator.dart';

class BlockingFakeSyncCoordinator implements SyncProgressCoordinator {
  int syncCount = 0;
  final Completer<void> syncStarted = Completer<void>();
  final Completer<void> allowSyncToFinish = Completer<void>();

  @override
  Future<void> syncAll() async {
    syncCount++;

    syncStarted.complete();

    await allowSyncToFinish.future;
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
  // TODO: implement auth
  FirebaseAuth get auth => throw UnimplementedError();
}
