import 'package:equatable/equatable.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';

class TutorSearchCriteria extends Equatable {
  final String? curriculumKey;
  final TeachingMode? teachingMode;
  final double? minRating;

  const TutorSearchCriteria({
    this.curriculumKey,
    this.teachingMode,
    this.minRating,
  });

  bool get isEmpty =>
      curriculumKey == null &&
      teachingMode == null &&
      minRating == null;

  @override
  List<Object?> get props => [
    curriculumKey,
    teachingMode,
    minRating,
  ];
}
