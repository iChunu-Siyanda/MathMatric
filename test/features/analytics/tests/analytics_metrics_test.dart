import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/calculator/analytics_calculator.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/shared/services/app_clock.dart';

// Testing: Repository → UseCase → Calculator → AnalyticsMetrics

class FakeClock implements AppClock {
  @override
  DateTime now() => DateTime(2026, 1, 1, 10, 30);
}

void main() {
  late AnalyticsCalculator calculator;
  late FakeClock clock;

  setUp(() {
    clock = FakeClock();
    calculator = AnalyticsCalculator(clock);
  });

  // Test 1: Empty analytics.
  test(
    'returns zero metrics when there is no data',
    () {
      final metrics = calculator.calculate(
        sessions: const [],
        questionAttempts: const [],
        levels: const [],
        topics: const [],
        timeframe: AnalyticsTimeframe.days7,
      );

      expect(metrics.totalEarnedXP, 0);
      expect(metrics.overallAccuracy, 0.0);
      expect(metrics.overallCompletionRate, 0.0);
      expect(metrics.avgTimePerQuestionSeconds, 0.0);
      expect(metrics.totalPracticeTimeSeconds, 0);

      expect(metrics.filteredAttempts, isEmpty);
      expect(metrics.filteredLevels, isEmpty);
      expect(metrics.topicProgressCards, isEmpty);
    },
  );

  // Test 2: Accuracy.
  test(
    'calculates overall accuracy correctly',
    () {
      final attempts = [
        ...List.generate(
          8,
          (index) => QuestionAttemptEntity(
            id: 'correct-$index',
            levelId: 'level-1',
            questionId: 'question-correct-$index',
            correct: true,
            timeTaken: 10,
            answeredAt: DateTime(2026, 1, 1),
          ),
        ),
        ...List.generate(
          2,
          (index) => QuestionAttemptEntity(
            id: 'incorrect-$index',
            levelId: 'level-1',
            questionId: 'question-incorrect-$index',
            correct: false,
            timeTaken: 10,
            answeredAt: DateTime(2026, 1, 1),
          ),
        ),
      ];

      final metrics = calculator.calculate(
        sessions: const [],
        questionAttempts: attempts,
        levels: const [],
        topics: const [],
        timeframe: AnalyticsTimeframe.days7,
      );

      expect(metrics.overallAccuracy, 80.0);
    },
  );

  // Test 3: Average Time.
  test(
    'calculates average time per question correctly',
    () {
      final attempts = [
        QuestionAttemptEntity(
          id: '1',
          levelId: 'level-1',
          questionId: 'q1',
          correct: true,
          timeTaken: 10,
          answeredAt: DateTime(2026, 1, 1),
        ),
        QuestionAttemptEntity(
          id: '2',
          levelId: 'level-1',
          questionId: 'q2',
          correct: true,
          timeTaken: 20,
          answeredAt: DateTime(2026, 1, 1),
        ),
        QuestionAttemptEntity(
          id: '3',
          levelId: 'level-1',
          questionId: 'q3',
          correct: false,
          timeTaken: 30,
          answeredAt: DateTime(2026, 1, 1),
        ),
      ];

      final metrics = calculator.calculate(
        sessions: const [],
        questionAttempts: attempts,
        levels: const [],
        topics: const [],
        timeframe: AnalyticsTimeframe.days7,
      );

      expect(metrics.totalPracticeTimeSeconds, 60);
      expect(metrics.avgTimePerQuestionSeconds, 20.0);
    },
  );
  
  // Test 4: XP.
  test(
    'calculates total earned XP from filtered levels',
    () {
      final levels = [
        UserLevelProgressEntity(
          id: 'progress-1',
          levelId: 'level-1',
          topicId: 'algebra',
          completed: true,
          earnedXP: 100,
          bestScore: 0.80,
          attempts: 1,
          completedAt: DateTime(2026, 1, 1),
          lastPlayed: DateTime(2026, 1, 1),
          bestTime: 30,
        ),
        UserLevelProgressEntity(
          id: 'progress-2',
          levelId: 'level-2',
          topicId: 'algebra',
          completed: true,
          earnedXP: 150,
          bestScore: 0.90,
          attempts: 2,
          completedAt: DateTime(2026, 1, 1),
          lastPlayed: DateTime(2026, 1, 1),
          bestTime: 40,
        ),
        UserLevelProgressEntity(
          id: 'progress-3',
          levelId: 'level-3',
          topicId: 'geometry',
          completed: false,
          earnedXP: 250,
          bestScore: 0.60,
          attempts: 3,
          completedAt: null,
          lastPlayed: DateTime(2026, 1, 1),
          bestTime: 50,
        ),
      ];

      final metrics = calculator.calculate(
        sessions: const [],
        questionAttempts: const [],
        levels: levels,
        topics: const [],
        timeframe: AnalyticsTimeframe.days7,
      );

      expect(metrics.totalEarnedXP, 500);
    },
  );

  // Test 5: Completion Rate.
  test(
    'calculates overall completion rate correctly',
    () {
      final levels = List.generate(
        10,
        (index) => UserLevelProgressEntity(
          id: 'progress-$index',
          levelId: 'level-$index',
          topicId: 'algebra',
          completed: index < 6,
          earnedXP: 100,
          bestScore: 0.80,
          attempts: 1,
          completedAt:
              index < 6 ? DateTime(2026, 1, 1) : null,
          lastPlayed: DateTime(2026, 1, 1),
          bestTime: 30,
        ),
      );

      final metrics = calculator.calculate(
        sessions: const [],
        questionAttempts: const [],
        levels: levels,
        topics: const [],
        timeframe: AnalyticsTimeframe.days7,
      );

      expect(metrics.overallCompletionRate, 60.0);
    },
  );

  // Test 6: 7-day filtering.
  test(
    'filters question attempts using the 7 day timeframe',
    () {
      final attempts = [
        QuestionAttemptEntity(
          id: 'old',
          levelId: 'level-1',
          questionId: 'old-question',
          correct: false,
          timeTaken: 100,
          answeredAt: DateTime(2025, 12, 20),
        ),
        QuestionAttemptEntity(
          id: 'recent',
          levelId: 'level-1',
          questionId: 'recent-question',
          correct: true,
          timeTaken: 20,
          answeredAt: DateTime(2025, 12, 30),
        ),
      ];

      final metrics = calculator.calculate(
        sessions: const [],
        questionAttempts: attempts,
        levels: const [],
        topics: const [],
        timeframe: AnalyticsTimeframe.days7,
      );

      expect(metrics.filteredAttempts, hasLength(1));
      expect(metrics.filteredAttempts.first.id, 'recent');

      expect(metrics.overallAccuracy, 100.0);
      expect(metrics.totalPracticeTimeSeconds, 20);
    },
  );

  // Test 7: 30-day filtering.
  test(
    'filters levels using the 30 day timeframe',
    () {
      final levels = [
        UserLevelProgressEntity(
          id: 'old',
          levelId: 'old-level',
          topicId: 'algebra',
          completed: true,
          earnedXP: 500,
          bestScore: 0.90,
          attempts: 1,
          completedAt: DateTime(2025, 11, 20),
          lastPlayed: DateTime(2025, 11, 20),
          bestTime: 30,
        ),
        UserLevelProgressEntity(
          id: 'recent',
          levelId: 'recent-level',
          topicId: 'algebra',
          completed: true,
          earnedXP: 200,
          bestScore: 0.80,
          attempts: 1,
          completedAt: DateTime(2025, 12, 20),
          lastPlayed: DateTime(2025, 12, 20),
          bestTime: 30,
        ),
      ];

      final metrics = calculator.calculate(
        sessions: const [],
        questionAttempts: const [],
        levels: levels,
        topics: const [],
        timeframe: AnalyticsTimeframe.days30,
      );

      expect(metrics.filteredLevels, hasLength(1));
      expect(metrics.filteredLevels.first.id, 'recent');

      expect(metrics.totalEarnedXP, 200);
    },
  );

  // Test 8: All time.
  test(
    'all time includes historical data',
    () {
      final levels = [
        UserLevelProgressEntity(
          id: 'old',
          levelId: 'old-level',
          topicId: 'algebra',
          completed: true,
          earnedXP: 500,
          bestScore: 0.90,
          attempts: 1,
          completedAt: DateTime(2020, 1, 1),
          lastPlayed: DateTime(2020, 1, 1),
          bestTime: 30,
        ),
        UserLevelProgressEntity(
          id: 'recent',
          levelId: 'recent-level',
          topicId: 'algebra',
          completed: true,
          earnedXP: 200,
          bestScore: 0.80,
          attempts: 1,
          completedAt: DateTime(2026, 1, 1),
          lastPlayed: DateTime(2026, 1, 1),
          bestTime: 30,
        ),
      ];

      final metrics = calculator.calculate(
        sessions: const [],
        questionAttempts: const [],
        levels: levels,
        topics: const [],
        timeframe: AnalyticsTimeframe.allTime,
      );

      expect(metrics.filteredLevels, hasLength(2));
      expect(metrics.totalEarnedXP, 700);
    },
  );
}