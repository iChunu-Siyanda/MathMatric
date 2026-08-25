import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/ui/analytics/domain/calculator/analytics_calculator.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/domain/usecases/get_analytics_use_case.dart';
import 'package:math_matric/shared/services/app_clock.dart';

import '../repos/timeframe_fake_analytics_repository.dart';

class FakeClock implements AppClock {
  DateTime currentTime;

  FakeClock(this.currentTime);

  @override
  DateTime now() => currentTime;

  void advance(Duration duration) {
    currentTime = currentTime.add(duration);
  }
}

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

  group('GetAnalyticsUseCase timeframe', () {
    test(
      'days7 should request data from exactly 7 days ago',
      () async {
        await useCase(
          timeframe: AnalyticsTimeframe.days7,
        );

        expect(
          repository.lastStudySessionsSince,
          DateTime(2026, 1, 24, 12, 0),
        );

        expect(
          repository.lastQuestionAttemptsSince,
          DateTime(2026, 1, 24, 12, 0),
        );

        expect(
          repository.lastLevelProgressSince,
          DateTime(2026, 1, 24, 12, 0),
        );
      },
    );

    test(
      'days30 should request data from exactly 30 days ago',
      () async {
        await useCase(
          timeframe: AnalyticsTimeframe.days30,
        );

        expect(
          repository.lastStudySessionsSince,
          DateTime(2026, 1, 1, 12, 0),
        );

        expect(
          repository.lastQuestionAttemptsSince,
          DateTime(2026, 1, 1, 12, 0),
        );

        expect(
          repository.lastLevelProgressSince,
          DateTime(2026, 1, 1, 12, 0),
        );
      },
    );

    test(
      'allTime should request null cutoff',
      () async {
        await useCase(
          timeframe: AnalyticsTimeframe.allTime,
        );

        expect(
          repository.lastStudySessionsSince,
          isNull,
        );

        expect(
          repository.lastQuestionAttemptsSince,
          isNull,
        );

        expect(
          repository.lastLevelProgressSince,
          isNull,
        );
      },
    );
  });

}
