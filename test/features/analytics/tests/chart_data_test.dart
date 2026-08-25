import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';

import '../charts/chart_data_calculator.dart';
import '../charts/timeframe_chart_data.dart';

void main() {
  const calculator = ChartDataCalculator();
  const timeframeCalculator = ChartTimeFrameDataCalculator();

  test(
    'should produce one chart entry per day and aggregate sessions',
    () {
      final sessions = [
        StudySessionEntity(
          id: 'session-1',
          topicId: 'algebra',
          activity: StudyActivity.practice,
          startedAt: DateTime(2026, 1, 25, 10, 0),
          endedAt: DateTime(2026, 1, 25, 10, 30),
          questionsAnswered: 10,
          correctAnswers: 8,
          earnedXP: 100,
        ),

        // Same day — must be combined.
        StudySessionEntity(
          id: 'session-2',
          topicId: 'algebra',
          activity: StudyActivity.quiz,
          startedAt: DateTime(2026, 1, 25, 14, 0),
          endedAt: DateTime(2026, 1, 25, 14, 20),
          questionsAnswered: 5,
          correctAnswers: 4,
          earnedXP: 50,
        ),

        // Different day.
        StudySessionEntity(
          id: 'session-3',
          topicId: 'geometry',
          activity: StudyActivity.pastPapers,
          startedAt: DateTime(2026, 1, 27, 9, 0),
          endedAt: DateTime(2026, 1, 27, 10, 0),
          questionsAnswered: 20,
          correctAnswers: 15,
          earnedXP: 200,
        ),
      ];

      final data = calculator.calculate(
        sessions: sessions,
        today: DateTime(2026, 1, 31),
        days: 7,
      );

      expect(data.length, 7);

      final jan25 = data.firstWhere(
        (entry) => entry.date == DateTime(2026, 1, 25),
      );

      expect(jan25.minutes, 50);
      expect(jan25.totalQuestions, 15);
      expect(jan25.correctAnswers, 12);

      final jan27 = data.firstWhere(
        (entry) => entry.date == DateTime(2026, 1, 27),
      );

      expect(jan27.minutes, 60);
      expect(jan27.totalQuestions, 20);
      expect(jan27.correctAnswers, 15);
    },
  );


  test(
    'should ignore incomplete study sessions',
    () {
      final sessions = [
        StudySessionEntity(
          id: 'active-session',
          topicId: 'algebra',
          activity: StudyActivity.practice,
          startedAt: DateTime(2026, 1, 30, 10),
          endedAt: null,
          questionsAnswered: 10,
          correctAnswers: 8,
          earnedXP: 100,
        ),
      ];

      final data = calculator.calculate(
        sessions: sessions,
        today: DateTime(2026, 1, 31),
        days: 7,
      );

      final jan30 = data.firstWhere(
        (entry) => entry.date == DateTime(2026, 1, 30),
      );

      expect(jan30.minutes, 0);
      expect(jan30.totalQuestions, 0);
      expect(jan30.correctAnswers, 0);
    },
  );


  test(
    'should return zero values for days with no sessions',
    () {
      final data = calculator.calculate(
        sessions: const [],
        today: DateTime(2026, 1, 31),
        days: 7,
      );

      expect(data.length, 7);

      for (final day in data) {
        expect(day.minutes, 0);
        expect(day.correctAnswers, 0);
        expect(day.totalQuestions, 0);
      }
    },
  );

  
  test(
    'days30 should produce 30 chart entries',
    () {
      final data = timeframeCalculator.calculate(
        sessions: const [],
        today: DateTime(2026, 1, 31),
        timeframe: AnalyticsTimeframe.days30,
      );

      expect(data.length, 30);

      expect(
        data.first.date,
        DateTime(2026, 1, 2),
      );

      expect(
        data.last.date,
        DateTime(2026, 1, 31),
      );
    },
  );


  test(
    'days7 should produce 7 chart entries',
    () {
      final data = timeframeCalculator.calculate(
        sessions: const [],
        today: DateTime(2026, 1, 31),
        timeframe: AnalyticsTimeframe.days7,
      );

      expect(data.length, 7);

      expect(
        data.first.date,
        DateTime(2026, 1, 25),
      );

      expect(
        data.last.date,
        DateTime(2026, 1, 31),
      );
    },
  );


  test(
    'allTime should start from the earliest session',
    () {
      final sessions = [
        StudySessionEntity(
          id: 'old',
          topicId: 'algebra',
          activity: StudyActivity.practice,
          startedAt: DateTime(2025, 12, 25, 10),
          endedAt: DateTime(2025, 12, 25, 11),
          questionsAnswered: 10,
          correctAnswers: 8,
          earnedXP: 100,
        ),
        StudySessionEntity(
          id: 'recent',
          topicId: 'algebra',
          activity: StudyActivity.practice,
          startedAt: DateTime(2026, 1, 30, 10),
          endedAt: DateTime(2026, 1, 30, 11),
          questionsAnswered: 10,
          correctAnswers: 9,
          earnedXP: 100,
        ),
      ];

      final data = timeframeCalculator.calculate(
        sessions: sessions,
        today: DateTime(2026, 1, 31),
        timeframe: AnalyticsTimeframe.allTime,
      );

      expect(
        data.first.date,
        DateTime(2025, 12, 25),
      );

      expect(
        data.last.date,
        DateTime(2026, 1, 31),
      );
    },
  );
}
