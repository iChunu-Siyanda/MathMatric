import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';

import '../charts/fake_daily_chart_builder.dart';

void main() {  
  test(
    'days30 should produce 30 chart entries',
    () {
      final data = FakeDailyChartDataBuilder.build(
        sessions: const [],
        now: DateTime(2026, 1, 31),
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
      final data = FakeDailyChartDataBuilder.build(
        sessions: const [],
        now: DateTime(2026, 1, 31),
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

      final data = FakeDailyChartDataBuilder.build(
        sessions: sessions,
        now: DateTime(2026, 1, 31),
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
