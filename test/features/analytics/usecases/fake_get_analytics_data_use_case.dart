import 'package:math_matric/features/ui/analytics/domain/calculator/analytics_calculator.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_metrics.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/domain/repositories/analytics_repository.dart';
import 'package:math_matric/features/ui/analytics/domain/usecases/get_analytics_use_case.dart';
import 'package:math_matric/shared/services/app_clock.dart';

class FakeGetAnalyticsUseCase implements GetAnalyticsUseCase {
  AnalyticsTimeframe? lastTimeframe;

  AnalyticsMetrics metrics;

  FakeGetAnalyticsUseCase({
    required this.metrics,
  });

  @override
  Future<AnalyticsMetrics> call({
    required AnalyticsTimeframe timeframe,
  }) async {
    lastTimeframe = timeframe;
    return metrics;
  }

  @override
  AnalyticsCalculator get calculator => throw UnimplementedError();

  @override
  AppClock get clock => throw UnimplementedError();

  @override
  AnalyticsRepository get repository => throw UnimplementedError();
}
