import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/ui/practice/domain/entities/practice_level.dart';
import 'package:math_matric/features/ui/practice/domain/entities/practice_topic.dart';
import 'package:math_matric/features/ui/practice/domain/usecases/load_practice_topic.dart';
import 'package:math_matric/features/progress/services/level_unlock_calculator.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';

import '../repos/fake_practice_repository.dart';
import '../repos/fake_practice_user_level_repository.dart';

void main() {
  late FakePracticeRepository practiceRepository;
  late FakePracticeLevelProgressRepository progressRepository;
  late LoadPracticeTopicUseCase useCase;

  setUp(() {
    practiceRepository = FakePracticeRepository();
    progressRepository = FakePracticeLevelProgressRepository();

    useCase = LoadPracticeTopicUseCase(
      practiceRepository: practiceRepository,
      levelProgressRepository: progressRepository,
      unlockCalculator: const LevelUnlockCalculator(),
    );
  });

  test('loads topic with calculated progression state', () async {
    practiceRepository.topic = PracticeTopic(
      id: 'topic-1',
      title: 'Algebra',
      subjectId: 'mathematics',
      description: 'Introduction to algebraic concepts',
      order: 1,
      totalLevels: 3,
      totalXp: 300,
      colorHex: '#4CAF50',
    );

    practiceRepository.levels = [
      PracticeLevel(
        levelId: 'level-1',
        topicId: 'topic-1',
        title: 'Basics',
        subtitle: 'Introduction',
        color: Colors.blue,
        xpReward: 100,
      ),
      PracticeLevel(
        levelId: 'level-2',
        topicId: 'topic-1',
        title: 'Equations',
        subtitle: 'Solve equations',
        color: Colors.red,
        xpReward: 100,
      ),
      PracticeLevel(
        levelId: 'level-3',
        topicId: 'topic-1',
        title: 'Quadratics',
        subtitle: 'Quadratic equations',
        color: Colors.green,
        xpReward: 100,
      ),
    ];

    progressRepository.progresses = [
      UserLevelProgressEntity(
        id: 'p1',
        levelId: 'level-1',
        topicId: 'topic-1',
        completed: true,
        earnedXP: 80,
        bestScore: 80,
        bestTime: 120,
        attempts: 1,
        completedAt: DateTime.now(),
        lastPlayed: DateTime.now(),
      ),
      UserLevelProgressEntity(
        id: 'p2',
        levelId: 'level-2',
        topicId: 'topic-1',
        completed: false,
        earnedXP: 30,
        bestScore: 60,
        bestTime: 150,
        attempts: 1,
        completedAt: null,
        lastPlayed: DateTime.now(),
      ),
    ];

    final result = await useCase('topic-1');

    expect(result.earnedXp, 110);
    expect(result.totalXp, 300);
    expect(result.progress, closeTo(110 / 300, 0.0001));

    expect(result.levels[0].isCompleted, true);
    expect(result.levels[0].isUnlocked, true);
    expect(result.levels[0].progress, 0.8);

    expect(result.levels[1].isCompleted, false);
    expect(result.levels[1].isUnlocked, true);
    expect(result.levels[1].progress, 0.3);

    expect(result.levels[2].isCompleted, false);
    expect(result.levels[2].isUnlocked, false);
    expect(result.levels[2].progress, 0.0);
  });

  test(
    'gets levels for topic from local datasource',
    () async {
      // arrange datasource fake
      

      // act
      final levels = await practiceRepository.getLevelsForTopic(
        'algebra',
      );

      // assert
      expect(levels.length, 2);
      expect(levels.first.levelId, 'algebra_level1');
      expect(levels.first.topicId, 'algebra');
      expect(levels.first.xpReward, 20);
    },
  );
}
