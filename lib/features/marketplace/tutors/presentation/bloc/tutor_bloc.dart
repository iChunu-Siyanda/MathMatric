import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/marketplace/tutors/domain/usecases/get_tutors_use_case.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/tutor_event.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/tutor_states.dart';

class TutorBloc extends Bloc<TutorEvent, TutorState> {
  final GetTutorsUseCase getTutors;

  TutorBloc({
    required this.getTutors,
  }) : super(const TutorInitial()) {
    on<LoadTutors>(_onLoadTutors);
    on<LoadMoreTutors>(_onLoadMoreTutors);
    on<RefreshTutors>(_onRefreshTutors);
  }

  Future<void> _onLoadTutors(
    LoadTutors event,
    Emitter<TutorState> emit,
  ) async {
    emit(const TutorLoading());

    try {
      final page = await getTutors();

      emit(
        TutorLoaded(
          tutors: page.tutors,
          lastCursor: page.lastCursor,
          hasMore: page.hasMore,
        ),
      );
    } catch (e) {
      emit(TutorError(e.toString()));
    }
  }

  Future<void> _onLoadMoreTutors(
    LoadMoreTutors event,
    Emitter<TutorState> emit,
  ) async {
    final currentState = state;

    if (currentState is! TutorLoaded ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    emit(
      TutorLoaded(
        tutors: currentState.tutors,
        lastCursor: currentState.lastCursor,
        hasMore: currentState.hasMore,
        isLoadingMore: true,
      ),
    );

    try {
      final page = await getTutors(
        startAfter: currentState.lastCursor,
      );

      emit(
        TutorLoaded(
          tutors: [
            ...currentState.tutors,
            ...page.tutors,
          ],
          lastCursor: page.lastCursor,
          hasMore: page.hasMore,
        ),
      );
    } catch (e) {
      // Keep already loaded tutors visible if pagination fails.
      emit(
        TutorLoaded(
          tutors: currentState.tutors,
          lastCursor: currentState.lastCursor,
          hasMore: currentState.hasMore,
        ),
      );
    }
  }

  Future<void> _onRefreshTutors(
    RefreshTutors event,
    Emitter<TutorState> emit,
  ) async {
    try {
      final page = await getTutors();

      emit(
        TutorLoaded(
          tutors: page.tutors,
          lastCursor: page.lastCursor,
          hasMore: page.hasMore,
        ),
      );
    } catch (e) {
      emit(TutorError(e.toString()));
    }
  }
}


// Nothing is listening continuously, which cuts cost:
// LoadTutors
//     ↓
// TutorLoading
//     ↓
// Firestore: 20 tutors
//     ↓
// TutorLoaded
//     │
//     ├── hasMore = true
//     │
//     ↓
// LoadMoreTutors
//     ↓
// Firestore: next 20
//     ↓
// TutorLoaded
//     │
//     └── append to existing list

// Each page causes one Firestore read operation for the returned documents, 
//and pagination only happens when needed.
