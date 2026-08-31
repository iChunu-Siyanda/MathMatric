import 'package:equatable/equatable.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/pagination_cursor.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_entity.dart';

sealed class TutorSearchState extends Equatable {
  const TutorSearchState();

  @override
  List<Object?> get props => [];
}

final class TutorSearchInitial extends TutorSearchState {
  const TutorSearchInitial();
}

final class TutorSearchLoading extends TutorSearchState {
  const TutorSearchLoading();
}

final class TutorSearchLoaded extends TutorSearchState {
  final List<TutorEntity> tutors;
  final PaginationCursor? lastCursor;
  final bool hasMore;
  final bool isLoadingMore;
  final TeachingMode? teachingMode;

  const TutorSearchLoaded({
    required this.tutors,
    required this.lastCursor,
    required this.hasMore,
    this.isLoadingMore = false,
    this.teachingMode,
  });

  List<TutorEntity> get filteredTutors {
    if (teachingMode == null) {
      return tutors;
    }

    return tutors.where((tutor) {
      return tutor.teachingModes.contains(teachingMode);
    }).toList();
  }

  @override
  List<Object?> get props => [
    tutors,
    lastCursor,
    hasMore,
    isLoadingMore,
    teachingMode,
  ];
}

final class TutorSearchError extends TutorSearchState {
  final String message;

  const TutorSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
