import 'package:equatable/equatable.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';

sealed class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

final class AnalyticsStarted extends AnalyticsEvent {
  const AnalyticsStarted();
}

final class AnalyticsRefreshed extends AnalyticsEvent {
  const AnalyticsRefreshed();
}

final class AnalyticsTimeframeChanged extends AnalyticsEvent {
  final AnalyticsTimeframe timeframe;

  const AnalyticsTimeframeChanged(this.timeframe);

  @override
  List<Object?> get props => [timeframe];
}
