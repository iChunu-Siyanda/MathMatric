import 'package:equatable/equatable.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_search_criteria.dart';

sealed class TutorSearchEvent extends Equatable {
  const TutorSearchEvent();

  @override
  List<Object?> get props => [];
}

final class SearchTutorsRequested extends TutorSearchEvent {
  final TutorSearchCriteria criteria;

  const SearchTutorsRequested(this.criteria);

  @override
  List<Object?> get props => [criteria];
}

final class SearchTutorsLoadMore extends TutorSearchEvent {
  const SearchTutorsLoadMore();
}

final class SearchTutorsRefresh extends TutorSearchEvent {
  const SearchTutorsRefresh();
}

final class TeachingModeFilterChanged extends TutorSearchEvent {
  final TeachingMode? teachingMode;

  const TeachingModeFilterChanged(this.teachingMode);

  @override
  List<Object?> get props => [teachingMode];
}
