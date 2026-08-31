import 'package:equatable/equatable.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/pagination_cursor.dart';
import '../../domain/entities/tutor_entity.dart';

sealed class TutorState extends Equatable{
  const TutorState();

  @override
  List<Object?> get props => [];
}

final class TutorInitial extends TutorState {
  const TutorInitial();
}

final class TutorLoading extends TutorState {
  const TutorLoading();
}

final class TutorLoaded extends TutorState {
  final List<TutorEntity> tutors;
  final PaginationCursor? lastCursor;
  final bool hasMore;
  final bool isLoadingMore;

  const TutorLoaded({
    required this.tutors,
    required this.lastCursor,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
    tutors,
    lastCursor,
    hasMore,
    isLoadingMore,
  ];
}

final class TutorError extends TutorState {
  final String message;

  const TutorError(this.message);

  @override
  List<Object?> get props => [message];
}
