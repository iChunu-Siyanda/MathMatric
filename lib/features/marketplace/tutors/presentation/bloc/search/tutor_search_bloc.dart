import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_search_criteria.dart';
import 'package:math_matric/features/marketplace/tutors/domain/usecases/search_tutors_use_case.dart';
import 'tutor_search_event.dart';
import 'tutor_search_state.dart';

class TutorSearchBloc extends Bloc<TutorSearchEvent, TutorSearchState> {
  final SearchTutors searchTutors;

  TutorSearchCriteria? _criteria;

  TutorSearchBloc({
    required this.searchTutors,
  }) : super(const TutorSearchInitial()) {
    on<SearchTutorsRequested>(_onSearchRequested);
    on<SearchTutorsLoadMore>(_onLoadMore);
    on<SearchTutorsRefresh>(_onRefresh);
    on<TeachingModeFilterChanged>(_onTeachingModeChanged);
  }

  Future<void> _onSearchRequested(
    SearchTutorsRequested event,
    Emitter<TutorSearchState> emit,
  ) async {
    _criteria = event.criteria;

    emit(const TutorSearchLoading());

    try {
      final page = await searchTutors(
        criteria: event.criteria,
      );

      emit(
        TutorSearchLoaded(
          tutors: page.tutors,
          lastCursor: page.lastCursor,
          hasMore: page.hasMore,
        ),
      );
    } catch (e) {
      emit(
        TutorSearchError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    SearchTutorsLoadMore event,
    Emitter<TutorSearchState> emit,
  ) async {
    final currentState = state;

    if (currentState is! TutorSearchLoaded) return;
    if (!currentState.hasMore) return;
    if (currentState.isLoadingMore) return;
    if (_criteria == null) return;

    emit(
      TutorSearchLoaded(
        tutors: currentState.tutors,
        lastCursor: currentState.lastCursor,
        hasMore: currentState.hasMore,
        isLoadingMore: true,
        teachingMode: currentState.teachingMode,
      ),
    );

    try {
      final page = await searchTutors(
        criteria: _criteria!,
        startAfter: currentState.lastCursor,
      );

      emit(
        TutorSearchLoaded(
          tutors: [
            ...currentState.tutors,
            ...page.tutors,
          ],
          lastCursor: page.lastCursor,
          hasMore: page.hasMore,
          teachingMode: currentState.teachingMode,
        ),
      );
    } catch (e) {
      emit(
        TutorSearchError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefresh(
    SearchTutorsRefresh event,
    Emitter<TutorSearchState> emit,
  ) async {
    if (_criteria == null) return;

    emit(const TutorSearchLoading());

    try {
      final page = await searchTutors(
        criteria: _criteria!,
      );

      final currentMode = state is TutorSearchLoaded
          ? (state as TutorSearchLoaded).teachingMode
          : null;

      emit(
        TutorSearchLoaded(
          tutors: page.tutors,
          lastCursor: page.lastCursor,
          hasMore: page.hasMore,
          teachingMode: currentMode,
        ),
      );
    } catch (e) {
      emit(
        TutorSearchError(
          e.toString(),
        ),
      );
    }
  }

  void _onTeachingModeChanged(
    TeachingModeFilterChanged event,
    Emitter<TutorSearchState> emit,
  ) {
    final currentState = state;

    if (currentState is! TutorSearchLoaded) return;

    emit(
      TutorSearchLoaded(
        tutors: currentState.tutors,
        lastCursor: currentState.lastCursor,
        hasMore: currentState.hasMore,
        isLoadingMore: currentState.isLoadingMore,
        teachingMode: event.teachingMode,
      ),
    );
  }
}
