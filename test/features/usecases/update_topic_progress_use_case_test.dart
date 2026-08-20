import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/usecases/update_topic_progress_use_case.dart';

import '../user-topic-progress/fake_level_progress_repository.dart';
import '../user-topic-progress/fake_topic_progress_repository.dart';

void main() {
  late FakeTopicProgressRepository topicRepository;
  late FakeLevelProgressRepository levelRepository;
  late UpdateTopicProgressUseCase useCase;

  setUp(() {
    topicRepository = FakeTopicProgressRepository();
    levelRepository = FakeLevelProgressRepository();

    useCase = UpdateTopicProgressUseCase(
      topicProgressRepository: topicRepository,
      levelProgressRepository: levelRepository,
    );
  });
  
  // 130 + 180 + 0 = 310 XP:
  test('aggregates XP from all levels in the topic', () async {
    levelRepository.levels = [
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
      UserLevelProgressEntity(
        id: 'p2',
        levelId: 'level-2',
        topicId: 'topic-1',
        completed: true,
        earnedXP: 180,
        bestScore: 100,
        bestTime: 100,
        attempts: 1,
        completedAt: DateTime.now(),
        lastPlayed: DateTime.now(),
      ),
      UserLevelProgressEntity(
        id: 'p3',
        levelId: 'level-3',
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

    await useCase(
      topicId: 'topic-1',
    );

    expect(
      topicRepository.savedProgress!.earnedXP,
      310,
    );
  });

  // Still Fav After Attept:
  test('preserves existing favorite state', () async {
    topicRepository.progress = UserTopicProgressEntity(
      id: 'topic-progress-1',
      topicId: 'topic-1',
      earnedXP: 50,
      mastery: 0.75,
      lastPlayed: DateTime.now(),
      favorite: true,
    );

    levelRepository.levels = [
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

    await useCase(
      topicId: 'topic-1',
    );

    expect(
      topicRepository.savedProgress!.favorite,
      true,
    );
  });

  // Recalculate previous xp instead of adding to it:
  test('recalculates topic XP instead of adding to previous XP', () async {
    topicRepository.progress = UserTopicProgressEntity(
      id: 'topic-progress-1',
      topicId: 'topic-1',
      earnedXP: 310,
      mastery: 0.0,
      lastPlayed: DateTime.now(),
      favorite: false,
    );

    levelRepository.levels = [
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
      UserLevelProgressEntity(
        id: 'p2',
        levelId: 'level-2',
        topicId: 'topic-1',
        completed: true,
        earnedXP: 180,
        bestScore: 100,
        bestTime: 100,
        attempts: 1,
        completedAt: DateTime.now(),
        lastPlayed: DateTime.now(),
      ),
    ];

    await useCase(
      topicId: 'topic-1',
    );

    expect(
      topicRepository.savedProgress!.earnedXP,
      310,
    );
  });


}
