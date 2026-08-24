import 'package:equatable/equatable.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_metrics.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';

sealed class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

final class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

final class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

final class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsMetrics metrics;
  final AnalyticsTimeframe selectedTimeframe;
  final bool isRefreshing;

  const AnalyticsLoaded({
    required this.metrics,
    this.selectedTimeframe = AnalyticsTimeframe.days7,
    this.isRefreshing = false,
  });

  AnalyticsLoaded copyWith({
    AnalyticsMetrics? metrics,
    AnalyticsTimeframe? selectedTimeframe,
    bool? isRefreshing,
  }) {
    return AnalyticsLoaded(
      metrics: metrics ?? this.metrics,
      selectedTimeframe:
          selectedTimeframe ?? this.selectedTimeframe,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
        metrics,
        selectedTimeframe,
        isRefreshing,
      ];
}

final class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
