import 'package:math_matric/features/ui/analytics/domain/calculator/analytics_calculator.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_metrics.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/domain/repositories/analytics_repository.dart';

class GetAnalyticsUseCase {
  final AnalyticsRepository repository;
  final AnalyticsCalculator calculator;

  GetAnalyticsUseCase({
    required this.repository,
    required this.calculator,
  });

  Future<AnalyticsMetrics> call({
    required AnalyticsTimeframe timeframe,
  }) async {
    final since = _getSince(timeframe);

    final sessions = await repository.getStudySessionsSince(since);

    final attempts = await repository.getQuestionAttemptsSince(since);

    final levels = await repository.getLevelProgressSince(since);

    final topics = await repository.getTopicProgress();

    return calculator.calculate(
      sessions: sessions,
      questionAttempts: attempts,
      levels: levels,
      topics: topics,
      timeframe: timeframe,
    );
  }

  DateTime? _getSince(AnalyticsTimeframe timeframe) {
    final now = DateTime.now();

    switch (timeframe) {
      case AnalyticsTimeframe.days7:
        return now.subtract(const Duration(days: 7));

      case AnalyticsTimeframe.days30:
        return now.subtract(const Duration(days: 30));

      case AnalyticsTimeframe.allTime:
        return null;
    }
  }
}
