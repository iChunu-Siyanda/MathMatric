import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:math_matric/features/analytics/presentation/bloc/analytics_state.dart';
import 'package:math_matric/features/papers/practice/domain/entities/practice_topic.dart';
import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState>{
  AnalyticsBloc():super(const AnalyticsInitial()){
    on<FetchAnalyticsData>(_onFetchAnalyticsData);
    on<RefreshAnalyticsData>(_onRefreshAnalyticsData);
    on<ChangeAnalyticsTimeframe>(_onChangeAnalyticsTimeframe);
  }

  Future<void> _onFetchAnalyticsData(
    FetchAnalyticsData event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    try {
      final topics = <PracticeTopic>[];
      final levels = <UserLevelProgressEntity>[];
      final questionAttempts = <QuestionAttemptEntity>[];
      final sessions = <StudySessionEntity>[];

      emit(
        AnalyticsLoaded(
          topics: topics,
          levels: levels,
          questionAttempts: questionAttempts,
          sessions: sessions,
          selectedTimeframe: AnalyticsTimeframe.days7,
        ),
      );
    } catch (e) {
      emit(AnalyticsError(message: 'Failed to load analytics: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshAnalyticsData(
    RefreshAnalyticsData event,
    Emitter<AnalyticsState> emit,
  ) async {
    final currentState = state;

    if (currentState is AnalyticsLoaded) {
      // 1. Set isRefreshing to true so RefreshIndicator / loading bar shows without wiping existing cards
      emit(currentState.copyWith(isRefreshing: true));

      try {
        final topics = <PracticeTopic>[];
        final levels = <UserLevelProgressEntity>[];
        final questionAttempts = <QuestionAttemptEntity>[];
        final sessions = <StudySessionEntity>[];

        emit(
          AnalyticsLoaded(
            topics: topics,
            levels: levels,
            questionAttempts: questionAttempts,
            sessions: sessions,
            selectedTimeframe: AnalyticsTimeframe.days7,
          ),
        );
      } catch (e) {
        // If refresh fails, turn off refreshing spinner but keep the existing data visible
        emit(currentState.copyWith(isRefreshing: false));
      }
    } else {
      add(const FetchAnalyticsData());
    }
  }
  
  //Filter/Timeframe Switching (7 Days / 30 Days / All Time)
  void _onChangeAnalyticsTimeframe(
    ChangeAnalyticsTimeframe event,
    Emitter<AnalyticsState> emit,
  ) {
    final currentState = state;
    if (currentState is AnalyticsLoaded) {
      if (currentState.selectedTimeframe == event.timeframe) return;

      emit(currentState.copyWith(selectedTimeframe: event.timeframe));
    }
  }
}
