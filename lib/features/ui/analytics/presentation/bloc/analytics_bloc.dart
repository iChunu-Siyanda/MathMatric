import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/domain/usecases/get_analytics_use_case.dart';
import 'package:math_matric/features/ui/analytics/presentation/bloc/analytics_event.dart';
import 'package:math_matric/features/ui/analytics/presentation/bloc/analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetAnalyticsUseCase getAnalytics;

  AnalyticsBloc({
    required this.getAnalytics,
  }) : super(const AnalyticsInitial()) {
    on<AnalyticsStarted>(_onStarted);
    on<AnalyticsRefreshed>(_onRefreshed);
    on<AnalyticsTimeframeChanged>(_onTimeframeChanged);
  }

  Future<void> _onStarted(
    AnalyticsStarted event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    try {
      const timeframe = AnalyticsTimeframe.days7;

      final metrics = await getAnalytics(timeframe: timeframe);

      emit(
        AnalyticsLoaded(
          metrics: metrics,
          selectedTimeframe: timeframe,
        ),
      );
    } catch (e) {
      emit(AnalyticsError(message:'Failed to load analytics: $e',),);
    }
  }

  Future<void> _onRefreshed(
    AnalyticsRefreshed event,
    Emitter<AnalyticsState> emit,
  ) async {
    final current = state;

    if (current is! AnalyticsLoaded) {
      add(const AnalyticsStarted());
      return;
    }

    emit(current.copyWith(isRefreshing: true,),);

    try {
      final metrics = await getAnalytics(timeframe:current.selectedTimeframe,);

      emit(
        AnalyticsLoaded(
          metrics: metrics,
          selectedTimeframe: current.selectedTimeframe,
        ),
      );
    } catch (e) {
      emit(current.copyWith(isRefreshing: false,),);
    }
  }

  Future<void> _onTimeframeChanged(
    AnalyticsTimeframeChanged event,
    Emitter<AnalyticsState> emit,
  ) async {
    final current = state;

    if (current is! AnalyticsLoaded) return;

    if (current.selectedTimeframe == event.timeframe) return;

    emit(const AnalyticsLoading());

    try {
      final data = await getAnalytics(timeframe: event.timeframe,);

      emit(
        AnalyticsLoaded(
          metrics: data,
          selectedTimeframe: event.timeframe,
        ),
      );
    } catch (e) {
      emit(
        AnalyticsError(message:'Failed to change analytics timeframe: $e',),
      );
    }
  }
}
