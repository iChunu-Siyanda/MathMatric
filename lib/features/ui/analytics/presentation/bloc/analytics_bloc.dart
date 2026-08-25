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
    on<FetchAnalyticsData>(_onFetchAnalyticsData);
    on<AnalyticsRefreshed>(_onRefreshed);
    on<AnalyticsTimeframeChanged>(_onTimeframeChanged);
  }

  Future<void> _onFetchAnalyticsData(
    FetchAnalyticsData event,
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
    final currentState = state;

    if (currentState is AnalyticsLoaded) {
      emit(
        currentState.copyWith(
          isRefreshing: true,
        ),
      );

      try {
        final metrics = await getAnalytics(
          timeframe: currentState.selectedTimeframe,
        );

        emit(
          AnalyticsLoaded(
            metrics: metrics,
            selectedTimeframe: currentState.selectedTimeframe,
          ),
        );
      } catch (e) {
        emit(
          currentState.copyWith(
            isRefreshing: false,
          ),
        );
      }
    } else {
      add(const FetchAnalyticsData());
    }
  }

  Future<void> _onTimeframeChanged(
    AnalyticsTimeframeChanged event,
    Emitter<AnalyticsState> emit,
  ) async {
    final current = state;

    if (current is! AnalyticsLoaded) return;

    if (current.selectedTimeframe == event.timeframe) return;

    emit(
      current.copyWith(
        selectedTimeframe: event.timeframe,
        isRefreshing: true,
      ),
    );

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
        current.copyWith(
          isRefreshing: false,
        ),
      );
    }
  }
}
