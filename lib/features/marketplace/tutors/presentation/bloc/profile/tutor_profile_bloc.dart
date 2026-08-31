import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/marketplace/tutors/domain/usecases/get_tutor_profile_use_case.dart';
import 'tutor_profile_event.dart';
import 'tutor_profile_state.dart';

class TutorProfileBloc
    extends Bloc<TutorProfileEvent, TutorProfileState> {
  final GetTutorProfileUseCase getTutorProfile;

  TutorProfileBloc({
    required this.getTutorProfile,
  }) : super(const TutorProfileInitial()) {
    on<TutorProfileRequested>(_onTutorProfileRequested);
  }

  Future<void> _onTutorProfileRequested(
    TutorProfileRequested event,
    Emitter<TutorProfileState> emit,
  ) async {
    emit(const TutorProfileLoading());

    try {
      final tutor = await getTutorProfile(event.tutorId);

      emit(
        TutorProfileLoaded(tutor),
      );
    } catch (e) {
      emit(
        TutorProfileError(
          e.toString(),
        ),
      );
    }
  }
}

// UI Example:
// ┌───────────────────────────────┐
// │          Tutor Photo          │
// │                               │
// │ Hlengiwe Hadebe         ✓     │
// │ ★ 4.8  (124 reviews)          │
// │                               │
// │ Grade 12 Mathematics Tutor    │
// │                               │
// │ ───────────────────────────── │
// │                               │
// │ About                         │
// │ Experienced mathematics...    │
// │                               │
// │ Qualifications               │
// │ BSc Mathematics               │
// │                               │
// │ Experience                   │
// │ 6 years                       │
// │                               │
// │ Teaching                      │
// │ ● Online       R180/hr        │
// │ ● In-person    R250/hr        │
// │                               │
// │ [ View Reviews ]              │
// │                               │
// │       [ Book Tutor ]          │
// └───────────────────────────────┘
