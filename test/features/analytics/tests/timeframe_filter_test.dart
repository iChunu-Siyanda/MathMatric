import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/calculator/analytics_calculator.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/domain/usecases/get_analytics_use_case.dart';
import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';

import '../repos/filter_timeframe_analytics_repo.dart';
import 'analytics_timeframe_test.dart';

void main() {
  late FakeAnalyticsRepository repository;
  late AnalyticsCalculator calculator;
  late FakeClock clock;
  late GetAnalyticsUseCase useCase;

  setUp(() {
    repository = FakeAnalyticsRepository();
    clock = FakeClock(
      DateTime(2026, 1, 31, 12, 0),
    );
    calculator = AnalyticsCalculator(clock);

    useCase = GetAnalyticsUseCase(
      repository: repository,
      calculator: calculator,
      clock: clock,
    );
  });

  // Timeframe: 7 DAYS.
  test(
    'days7 should only calculate metrics from data inside the timeframe',
    () async {
      repository.studySessions = [
        StudySessionEntity(
          id: 'session-inside',
          topicId: 'algebra',
          activity: StudyActivity.practice,
          startedAt: DateTime(2026, 1, 25, 10, 0),
          endedAt: DateTime(2026, 1, 25, 10, 30),
          questionsAnswered: 10,
          correctAnswers: 8,
          earnedXP: 100,
        ),
        StudySessionEntity(
          id: 'session-outside',
          topicId: 'algebra',
          activity: StudyActivity.practice,
          startedAt: DateTime(2026, 1, 20, 10, 0),
          endedAt: DateTime(2026, 1, 20, 11, 0),
          questionsAnswered: 10,
          correctAnswers: 2,
          earnedXP: 500,
        ),
      ];

      repository.questionAttempts = [
        QuestionAttemptEntity(
          id: 'attempt-inside',
          levelId: 'level-1',
          questionId: 'question-1',
          correct: true,
          timeTaken: 10,
          answeredAt: DateTime(2026, 1, 25, 10, 15),
        ),
        QuestionAttemptEntity(
          id: 'attempt-outside',
          levelId: 'level-1',
          questionId: 'question-2',
          correct: false,
          timeTaken: 100,
          answeredAt: DateTime(2026, 1, 20, 10, 15),
        ),
      ];

      final metrics = await useCase(
        timeframe: AnalyticsTimeframe.days7,
      );

      expect(metrics.filteredAttempts.length, 1);

      expect(
        metrics.filteredAttempts.first.id,
        'attempt-inside',
      );

      expect(metrics.overallAccuracy, 100);

      expect(metrics.avgTimePerQuestionSeconds, 10);
    },
  );

  test(
    'days7 should exclude data exactly on the cutoff',
    () async {
      repository.questionAttempts = [
        QuestionAttemptEntity(
          id: 'exact-cutoff',
          levelId: 'level-1',
          questionId: 'question-1',
          correct: true,
          timeTaken: 10,
          answeredAt: DateTime(2026, 1, 24, 12, 0),
        ),
        QuestionAttemptEntity(
          id: 'inside',
          levelId: 'level-1',
          questionId: 'question-2',
          correct: false,
          timeTaken: 20,
          answeredAt: DateTime(2026, 1, 24, 12, 0, 1),
        ),
      ];

      final metrics = await useCase(
        timeframe: AnalyticsTimeframe.days7,
      );

      expect(
        metrics.filteredAttempts.length,
        1,
      );

      expect(
        metrics.filteredAttempts.first.id,
        'inside',
      );
    },
  );

  test(
    'days7 should include data one instant after the cutoff',
    () async {
      repository.questionAttempts = [
        QuestionAttemptEntity(
          id: 'inside',
          levelId: 'level-1',
          questionId: 'question-1',
          correct: true,
          timeTaken: 10,
          answeredAt: DateTime(2026, 1, 24, 12, 0, 1),
        ),
      ];

      final metrics = await useCase(
        timeframe: AnalyticsTimeframe.days7,
      );

      expect(metrics.filteredAttempts.length, 1);
      expect(
        metrics.filteredAttempts.first.id,
        'inside',
      );
    },
  );

  // Timeframe: 30 DAYS.
    group('Analytics timeframe filtering', () {
    test(
      'days30 should include data inside 30 days and exclude older data',
      () async {
        repository.studySessions = [
          StudySessionEntity(
            id: 'inside-30',
            topicId: 'algebra',
            activity: StudyActivity.practice,
            startedAt: DateTime(2026, 1, 10, 10),
            endedAt: DateTime(2026, 1, 10, 10, 30),
            questionsAnswered: 10,
            correctAnswers: 8,
            earnedXP: 100,
          ),
          StudySessionEntity(
            id: 'outside-30',
            topicId: 'algebra',
            activity: StudyActivity.practice,
            startedAt: DateTime(2025, 12, 20, 10),
            endedAt: DateTime(2025, 12, 20, 11),
            questionsAnswered: 10,
            correctAnswers: 2,
            earnedXP: 500,
          ),
        ];

        repository.questionAttempts = [
          QuestionAttemptEntity(
            id: 'attempt-inside',
            levelId: 'level-1',
            questionId: 'question-1',
            correct: true,
            timeTaken: 20,
            answeredAt: DateTime(2026, 1, 10, 10),
          ),
          QuestionAttemptEntity(
            id: 'attempt-outside',
            levelId: 'level-1',
            questionId: 'question-2',
            correct: false,
            timeTaken: 100,
            answeredAt: DateTime(2025, 12, 20, 10),
          ),
        ];

        final metrics = await useCase(
          timeframe: AnalyticsTimeframe.days30,
        );

        expect(metrics.filteredAttempts.length, 1);
        expect(
          metrics.filteredAttempts.first.id,
          'attempt-inside',
        );

        expect(metrics.overallAccuracy, 100);
        expect(metrics.avgTimePerQuestionSeconds, 20);
      },
    );

    test(
      'allTime should include all available data',
      () async {
        repository.studySessions = [
          StudySessionEntity(
            id: 'old-session',
            topicId: 'algebra',
            activity: StudyActivity.practice,
            startedAt: DateTime(2020, 1, 1, 10),
            endedAt: DateTime(2020, 1, 1, 11),
            questionsAnswered: 10,
            correctAnswers: 5,
            earnedXP: 100,
          ),
          StudySessionEntity(
            id: 'recent-session',
            topicId: 'algebra',
            activity: StudyActivity.practice,
            startedAt: DateTime(2026, 1, 25, 10),
            endedAt: DateTime(2026, 1, 25, 10, 30),
            questionsAnswered: 10,
            correctAnswers: 10,
            earnedXP: 200,
          ),
        ];

        repository.questionAttempts = [
          QuestionAttemptEntity(
            id: 'old-attempt',
            levelId: 'level-1',
            questionId: 'question-1',
            correct: false,
            timeTaken: 100,
            answeredAt: DateTime(2020, 1, 1, 10),
          ),
          QuestionAttemptEntity(
            id: 'recent-attempt',
            levelId: 'level-1',
            questionId: 'question-2',
            correct: true,
            timeTaken: 20,
            answeredAt: DateTime(2026, 1, 25, 10),
          ),
        ];

        final metrics = await useCase(
          timeframe: AnalyticsTimeframe.allTime,
        );

        expect(metrics.filteredAttempts.length, 2);

        expect(
          metrics.filteredAttempts.map((e) => e.id),
          containsAll([
            'old-attempt',
            'recent-attempt',
          ]),
        );

        expect(metrics.overallAccuracy, 50);

        expect(
          metrics.avgTimePerQuestionSeconds,
          60,
        );
      },
    );
  });


  test(
    'calculator should produce correct analytics metrics from real data',
    () async {
      repository.questionAttempts = [
        QuestionAttemptEntity(
          id: 'q1',
          levelId: 'level-1',
          questionId: 'question-1',
          correct: true,
          timeTaken: 10,
          answeredAt: DateTime(2026, 1, 25, 10),
        ),
        QuestionAttemptEntity(
          id: 'q2',
          levelId: 'level-1',
          questionId: 'question-2',
          correct: true,
          timeTaken: 20,
          answeredAt: DateTime(2026, 1, 25, 10),
        ),
        QuestionAttemptEntity(
          id: 'q3',
          levelId: 'level-1',
          questionId: 'question-3',
          correct: false,
          timeTaken: 30,
          answeredAt: DateTime(2026, 1, 25, 10),
        ),
        QuestionAttemptEntity(
          id: 'q4',
          levelId: 'level-2',
          questionId: 'question-4',
          correct: true,
          timeTaken: 40,
          answeredAt: DateTime(2026, 1, 26, 10),
        ),
      ];

      repository.levels = [
        UserLevelProgressEntity(
          id: 'progress-1',
          levelId: 'level-1',
          topicId: 'algebra',
          completed: true,
          earnedXP: 100,
          bestScore: 0.8,
          attempts: 2,
          completedAt: DateTime(2026, 1, 25),
          lastPlayed: DateTime(2026, 1, 25),
          bestTime: 20,
        ),
        UserLevelProgressEntity(
          id: 'progress-2',
          levelId: 'level-2',
          topicId: 'algebra',
          completed: false,
          earnedXP: 50,
          bestScore: 0.5,
          attempts: 3,
          completedAt: null,
          lastPlayed: DateTime(2026, 1, 26),
          bestTime: null,
        ),
      ];

      final metrics = await useCase(
        timeframe: AnalyticsTimeframe.days7,
      );

      // 3 correct out of 4.
      expect(
        metrics.overallAccuracy,
        75,
      );

      // 10 + 20 + 30 + 40 = 100 seconds.
      expect(
        metrics.totalPracticeTimeSeconds,
        100,
      );

      // 100 / 4 = 25 seconds.
      expect(
        metrics.avgTimePerQuestionSeconds,
        25,
      );

      // Both levels are inside the timeframe.
      expect(
        metrics.filteredLevels.length,
        2,
      );

      // 100 + 50 XP.
      expect(
        metrics.totalEarnedXP,
        150,
      );

      // 1 completed out of 2 = 50%.
      expect(
        metrics.overallCompletionRate,
        50,
      );
    },
  );

}
