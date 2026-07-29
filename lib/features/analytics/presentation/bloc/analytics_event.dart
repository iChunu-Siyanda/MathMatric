import 'package:equatable/equatable.dart';
import 'package:math_matric/features/analytics/domain/entites/analytics_time_frame.dart';

sealed class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class FetchAnalyticsData extends AnalyticsEvent {
  const FetchAnalyticsData();
}

class RefreshAnalyticsData extends AnalyticsEvent {
  const RefreshAnalyticsData();
}

//When the user taps on '7 Days', '30 Days', or 'All Time'
class ChangeAnalyticsTimeframe extends AnalyticsEvent {
  final AnalyticsTimeframe timeframe;

  const ChangeAnalyticsTimeframe(this.timeframe);

  @override
  List<Object?> get props => [timeframe];
}
