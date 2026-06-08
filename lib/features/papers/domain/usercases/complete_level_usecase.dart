// features/papers/domain/usecases/complete_level_use_case.dart
import 'package:math_matric/features/papers/domain/repositories/user_progress_repository.dart';

class CompleteLevelUseCase {
  final UserProgressRepository progressRepository;

  CompleteLevelUseCase({required this.progressRepository});

  Future<void> call({
    required String topicId,
    required String levelId,
    required int xpEarned,
  }) async {
    await progressRepository.markLevelCompleted(
      topicId: topicId,
      levelId: levelId,
      xpEarned: xpEarned,
    );
  }
}