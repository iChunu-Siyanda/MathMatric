import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_metrics.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:math_matric/features/ui/analytics/presentation/bloc/analytics_event.dart';

import '../usecases/fake_get_analytics_data_use_case.dart';

void main() {
  late FakeGetAnalyticsUseCase useCase;
  late AnalyticsBloc bloc;
  late AnalyticsMetrics metrics;

  setUp(() {
    metrics = AnalyticsMetrics(
      topics: const [],
      levels: const [],
      questionAttempts: const [],
      sessions: const [],
      filteredAttempts: const [],
      filteredLevels: const [],
      topicProgressCards: const [],
      totalEarnedXP: 100,
      overallAccuracy: 80,
      overallCompletionRate: 60,
      avgTimePerQuestionSeconds: 15,
      totalPracticeTimeSeconds: 900, 
      studyVolume: [], 
      accuracyTrend: [], 
      totalStudyMinutes: 0, 
      totalQuestionsAnswered: 0, 
      activityBreakdown: [],
    );

    useCase = FakeGetAnalyticsUseCase(
      metrics: metrics,
    );

    bloc = AnalyticsBloc(getAnalytics: useCase);
  });

  tearDown(() async {
    await bloc.close();
  });

  test(
    'changing timeframe should request the selected timeframe',
    () async {
      bloc.add(const FetchAnalyticsData());

      await Future<void>.delayed(Duration.zero);

      expect(
        useCase.lastTimeframe,
        AnalyticsTimeframe.days7,
      );

      bloc.add(
        const AnalyticsTimeframeChanged(
          AnalyticsTimeframe.days30,
        ),
      );

      await Future<void>.delayed(Duration.zero);

      expect(
        useCase.lastTimeframe,
        AnalyticsTimeframe.days30,
      );

      bloc.add(
        const AnalyticsTimeframeChanged(
          AnalyticsTimeframe.allTime,
        ),
      );

      await Future<void>.delayed(Duration.zero);

      expect(
        useCase.lastTimeframe,
        AnalyticsTimeframe.allTime,
      );
    },
  );
}
