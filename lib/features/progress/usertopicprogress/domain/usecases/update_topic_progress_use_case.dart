import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/repositories/user_topic_progress_repository.dart';
import 'package:uuid/uuid.dart';

class UpdateTopicProgressUseCase {
  final UserTopicProgressRepository topicProgressRepository;
  final UserLevelProgressRepository levelProgressRepository;

  const UpdateTopicProgressUseCase({
    required this.topicProgressRepository,
    required this.levelProgressRepository,
  });

  Future<void> call({
    required String topicId,
  }) async {
    final levels = await levelProgressRepository.getProgressByTopic(topicId);

    final previous = await topicProgressRepository.getUserTopicProgress(topicId);

    final earnedXP = levels.fold<int>( 0, (total, level) => total + level.earnedXP,);

    final now = DateTime.now();

    final progress = UserTopicProgressEntity(
      id: previous?.id ?? const Uuid().v4(),
      topicId: topicId,
      earnedXP: earnedXP,
      mastery: previous?.mastery ?? 0.0,
      lastPlayed: now,
      favorite: previous?.favorite ?? false,
    );

    await topicProgressRepository.saveProgress(progress);
  }
}
