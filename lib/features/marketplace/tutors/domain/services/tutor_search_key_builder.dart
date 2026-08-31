import '../entities/tutor_search_criteria.dart';

class TutorSearchKeyBuilder {
  const TutorSearchKeyBuilder();

  String? build(TutorSearchCriteria criteria) {
    if (criteria.curriculumKey == null ||
        criteria.teachingMode == null) {
      return null;
    }

    return '${criteria.curriculumKey}:${criteria.teachingMode!.name}';
  }
}

// mathematics_grade12:quadratic_functions
// +
// online
//         ↓
// mathematics_grade12:quadratic_functions:online
