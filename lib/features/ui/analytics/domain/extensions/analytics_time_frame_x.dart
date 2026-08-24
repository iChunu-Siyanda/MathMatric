import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';

extension AnalyticsTimeframeX on AnalyticsTimeframe {
  DateTime? get since {
    final now = DateTime.now();

    switch (this) {
      case AnalyticsTimeframe.days7:
        return now.subtract(const Duration(days: 7));

      case AnalyticsTimeframe.days30:
        return now.subtract(const Duration(days: 30));

      case AnalyticsTimeframe.allTime:
        return null;
    }
  }
}
