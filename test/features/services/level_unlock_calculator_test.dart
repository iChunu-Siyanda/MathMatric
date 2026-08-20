import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/progress/services/level_unlock_calculator.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';

void main() {
  const calculator = LevelUnlockCalculator();

  test('first level is always unlocked', () {
    final result = calculator.isUnlocked(
      index: 0,
      progresses: [],
      orderedLevelIds: [
        'level-1',
        'level-2',
        'level-3',
      ],
    );

    expect(result, true);
  });

  test('next level unlocks when prerequisite is completed', () {
    final progresses = [
      UserLevelProgressEntity(
        id: 'p1',
        levelId: 'level-1',
        topicId: 'topic-1',
        completed: true,
        earnedXP: 130,
        bestScore: 80,
        bestTime: 120,
        attempts: 1,
        completedAt: DateTime.now(),
        lastPlayed: DateTime.now(),
      ),
    ];

    final result = calculator.isUnlocked(
      index: 1,
      progresses: progresses,
      orderedLevelIds: [
        'level-1',
        'level-2',
        'level-3',
      ],
    );

    expect(result, true);
  });

  test('next level remains locked when prerequisite is incomplete', () {
    final progresses = [
      UserLevelProgressEntity(
        id: 'p1',
        levelId: 'level-1',
        topicId: 'topic-1',
        completed: false,
        earnedXP: 0,
        bestScore: 60,
        bestTime: null,
        attempts: 1,
        completedAt: null,
        lastPlayed: DateTime.now(),
      ),
    ];

    final result = calculator.isUnlocked(
      index: 1,
      progresses: progresses,
      orderedLevelIds: [
        'level-1',
        'level-2',
        'level-3',
      ],
    );

    expect(result, false);
  });
}
