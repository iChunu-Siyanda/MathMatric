import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/progress/services/user_progress_calculator.dart';
import 'package:math_matric/features/progress/services/xp_calculator.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/level_attempt.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/usecases/process_level_attempt_use_case.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/usecases/update_topic_progress_use_case.dart';

import '../question-attempt/fake_question_attempt_repo.dart';
import '../user-level-progress/fake_user_level_progress_repository.dart';
import '../user-topic-progress/fake_topic_progress_repository.dart';

void main() {
  late FakeQuestionAttemptRepository questionAttempts;
  late FakeUserLevelProgressRepository levelProgress;
  late FakeTopicProgressRepository topicProgress;
  late ProcessLevelAttemptUseCase useCase;
  late UpdateTopicProgressUseCase updateUseCase;

  setUp(() {
    questionAttempts = FakeQuestionAttemptRepository();
    levelProgress = FakeUserLevelProgressRepository();
    topicProgress = FakeTopicProgressRepository();
    updateUseCase = UpdateTopicProgressUseCase(
      topicProgressRepository: topicProgress, 
      levelProgressRepository: levelProgress,
    );
    useCase = ProcessLevelAttemptUseCase(
      levelProgressRepository: levelProgress,
      questionAttemptRepository: questionAttempts,
      progressCalculator: const UserProgressCalculator(),
      xpCalculator: const XPCalculator(), 
      updateTopicProgress: updateUseCase,
    );
  });

  // First Test 80%:
  // test('first attempt at 80% completes level and awards 130 XP', () async {
  //   //Attange:
  //   final attempt = LevelAttempt(
  //     levelId: 'level-1',
  //     topicId: 'topic-1',
  //     score: 80,
  //     timeTaken: 120,
  //     correctAnswers: 8,
  //     totalQuestions: 10,
  //     answers: {
  //       'q1': true,
  //       'q2': true,
  //       'q3': true,
  //       'q4': true,
  //       'q5': true,
  //       'q6': true,
  //       'q7': true,
  //       'q8': true,
  //       'q9': false,
  //       'q10': false,
  //     },
  //   );

  //   // Act:
  //   await useCase(
  //     attempt: attempt,
  //     questionAttempts: [],
  //   );

  //   // Assert:
  //   expect(levelProgress.savedProgress, isNotNull);
  //   expect(levelProgress.savedProgress!.completed, true);
  //   expect(levelProgress.savedProgress!.earnedXP, 130);
  //   expect(levelProgress.savedProgress!.bestScore, 80);
  //   expect(levelProgress.savedProgress!.attempts, 1);
  // });

  // // Perfect Attempt:
  // test('first perfect attempt awards 200 XP', () async {
  //   final attempt = LevelAttempt(
  //     levelId: 'level-1',
  //     topicId: 'topic-1',
  //     score: 100,
  //     timeTaken: 100,
  //     correctAnswers: 10,
  //     totalQuestions: 10,
  //     answers: {
  //       for (var i = 1; i <= 10; i++) 'q$i': true,
  //     },
  //   );

  //   await useCase(
  //     attempt: attempt,
  //     questionAttempts: [],
  //   );

  //   expect(levelProgress.savedProgress!.earnedXP, 200);
  //   expect(levelProgress.savedProgress!.bestScore, 100);
  // });

  test('replay with no improvement awards zero XP', () async {
    levelProgress.progress = UserLevelProgressEntity(
      id: 'progress-1',
      levelId: 'level-1',
      topicId: 'topic-1',
      completed: true,
      earnedXP: 130,
      bestScore: 80,
      attempts: 1,
      completedAt: DateTime.now(),
      lastPlayed: DateTime.now(),
    );

    questionAttempts.previouslyCorrect = [
      'q1',
      'q2',
      'q3',
      'q4',
      'q5',
      'q6',
      'q7',
      'q8',
    ];

    final attempt = LevelAttempt(
      levelId: 'level-1',
      topicId: 'topic-1',
      score: 80,
      timeTaken: 120,
      correctAnswers: 8,
      totalQuestions: 10,
      answers: {
        'q1': true,
        'q2': true,
        'q3': true,
        'q4': true,
        'q5': true,
        'q6': true,
        'q7': true,
        'q8': true,
        'q9': false,
        'q10': false,
      },
    );

    await useCase(
      attempt: attempt,
      questionAttempts: [],
    );

    expect(levelProgress.savedProgress!.earnedXP, 130);
  });

  test('replay with higher score updates best score and awards replay XP',
    () async {
    levelProgress.progress = UserLevelProgressEntity(
      id: 'progress-1',
      levelId: 'level-1',
      topicId: 'topic-1',
      completed: true,
      earnedXP: 130,
      bestScore: 80,
      attempts: 1,
      completedAt: DateTime.now(),
      lastPlayed: DateTime.now(),
    );

    questionAttempts.previouslyCorrect = [
      'q1',
      'q2',
      'q3',
      'q4',
      'q5',
      'q6',
      'q7',
      'q8',
    ];

    final attempt = LevelAttempt(
      levelId: 'level-1',
      topicId: 'topic-1',
      score: 90,
      timeTaken: 110,
      correctAnswers: 9,
      totalQuestions: 10,
      answers: {
        'q1': true,
        'q2': true,
        'q3': true,
        'q4': true,
        'q5': true,
        'q6': true,
        'q7': true,
        'q8': true,
        'q9': true, // new correct
        'q10': false,
      },
    );

    await useCase(
      attempt: attempt,
      questionAttempts: [],
    );

    expect(
      levelProgress.savedProgress!.bestScore,
      90,
    );

    // 1 new correct = +5
    expect(
      levelProgress.savedProgress!.earnedXP,
      135,
    );
  });

  test('faster replay awards 5 XP', () async {
    levelProgress.progress = UserLevelProgressEntity(
      id: 'progress-1',
      levelId: 'level-1',
      topicId: 'topic-1',
      completed: true,
      earnedXP: 130,
      bestScore: 80,
      bestTime: 120,
      attempts: 1,
      completedAt: DateTime.now(),
      lastPlayed: DateTime.now(),
    );

    questionAttempts.previouslyCorrect = [
      'q1',
      'q2',
      'q3',
      'q4',
      'q5',
      'q6',
      'q7',
      'q8',
    ];

    final attempt = LevelAttempt(
      levelId: 'level-1',
      topicId: 'topic-1',
      score: 80,
      timeTaken: 100, // faster than 120
      correctAnswers: 8,
      totalQuestions: 10,
      answers: {
        'q1': true,
        'q2': true,
        'q3': true,
        'q4': true,
        'q5': true,
        'q6': true,
        'q7': true,
        'q8': true,
        'q9': false,
        'q10': false,
      },
    );

    await useCase(
      attempt: attempt,
      questionAttempts: [],
    );

    expect(
      levelProgress.savedProgress!.earnedXP,
      135,
    );

    expect(
      levelProgress.savedProgress!.bestTime,
      100,
    );
  });

  test('slower replay does not award speed XP', () async {
    levelProgress.progress = UserLevelProgressEntity(
      id: 'progress-1',
      levelId: 'level-1',
      topicId: 'topic-1',
      completed: true,
      earnedXP: 130,
      bestScore: 80,
      bestTime: 120,
      attempts: 1,
      completedAt: DateTime.now(),
      lastPlayed: DateTime.now(),
    );

    questionAttempts.previouslyCorrect = [
      'q1',
      'q2',
      'q3',
      'q4',
      'q5',
      'q6',
      'q7',
      'q8',
    ];

    final attempt = LevelAttempt(
      levelId: 'level-1',
      topicId: 'topic-1',
      score: 80,
      timeTaken: 140,
      correctAnswers: 8,
      totalQuestions: 10,
      answers: {
        'q1': true,
        'q2': true,
        'q3': true,
        'q4': true,
        'q5': true,
        'q6': true,
        'q7': true,
        'q8': true,
        'q9': false,
        'q10': false,
      },
    );

    await useCase(
      attempt: attempt,
      questionAttempts: [],
    );

    expect(
      levelProgress.savedProgress!.earnedXP,
      130,
    );

    expect(
      levelProgress.savedProgress!.bestTime,
      120,
    );
  });
}
