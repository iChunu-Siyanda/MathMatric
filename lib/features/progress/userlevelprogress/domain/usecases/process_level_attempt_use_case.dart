import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/questionattempts/domain/repositories/question_atempts_repository.dart';
import 'package:math_matric/features/progress/services/user_progress_calculator.dart';
import 'package:math_matric/features/progress/services/xp_calculator.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/models/user_level_progresses_model.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/level_attempt.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';
import 'package:uuid/uuid.dart';

class ProcessLevelAttemptUseCase {
  final UserLevelProgressRepository levelProgressRepository;
  final QuestionAttemptRepository questionAttemptRepository;
  final UserProgressCalculator progressCalculator;
  final XPCalculator xpCalculator;

  const ProcessLevelAttemptUseCase({
    required this.levelProgressRepository,
    required this.questionAttemptRepository,
    required this.progressCalculator,
    required this.xpCalculator,
  });

  Future<void> call({
    required LevelAttempt attempt,
    required List<QuestionAttemptEntity> questionAttempts,
  }) async {
    // 1. Read the state BEFORE this attempt.
    final previousProgress = await levelProgressRepository.getUserLevelProgress(attempt.levelId,);

    final previouslyCorrect = await questionAttemptRepository.getCorrectQuestionIdsByLevel(attempt.levelId,);

    // 2. Determine which questions are newly answered correctly.
    final newCorrectAnswers = progressCalculator.calculateNewCorrectAnswers(
      previouslyCorrectQuestionIds: previouslyCorrect,
      currentAnswers: attempt.answers,
    );

    // 3. Determine completion.
    final completed = progressCalculator.isLevelCompleted(accuracy: attempt.score,);

    // 4. Determine whether this is a new best.
    final isNewBest = progressCalculator.isNewBest(
      currentBestScore: previousProgress?.bestScore ?? 0.0,
      currentBestTime: previousProgress?.bestTime,
      newScore: attempt.score,
      newTime: attempt.timeTaken,
    );

    // 5. Calculate XP.
    final xpResult = xpCalculator.calculate(
      firstPass: previousProgress == null,
      correctAnswers: attempt.correctAnswers,
      newCorrectAnswers: newCorrectAnswers,
      newBestTime: previousProgress?.bestTime != null && isNewBest,
      perfect: attempt.score == 100.0,
    );

    // 6. Build updated progress.
    final now = DateTime.now();

    final updatedProgress = UserLevelProgressModel(
      id: previousProgress?.id ?? const Uuid().v4(),
      levelId: attempt.levelId,
      topicId: attempt.topicId,
      completed:previousProgress?.completed == true || completed,
      earnedXP: (previousProgress?.earnedXP ?? 0) + xpResult.xp,
      bestScore: isNewBest
          ? attempt.score
          : previousProgress?.bestScore ?? 0.0,
      bestTime: isNewBest
          ? attempt.timeTaken
          : previousProgress?.bestTime,
      attempts: (previousProgress?.attempts ?? 0) + 1,
      completedAt: previousProgress?.completedAt ?? (completed ? now : null),
      lastPlayed: now, 
      synced: false, 
      updatedAt: DateTime.now(),
    );

    // 7. Persist the current attempt.
    await questionAttemptRepository.saveQuestionAttempts(questionAttempts,);

    // 8. Persist updated level progress.
    await levelProgressRepository.saveProgress(updatedProgress,);
  }
}
