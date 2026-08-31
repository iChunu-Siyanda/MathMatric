import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_page.dart';

import '../entities/pagination_cursor.dart';
import '../entities/tutor_search_criteria.dart';
import '../repositories/tutor_repository.dart';
import '../services/tutor_search_key_builder.dart';

class SearchTutors {
  final TutorRepository repository;
  final TutorSearchKeyBuilder keyBuilder;

  SearchTutors({
    required this.repository,
    required this.keyBuilder,
  });

  Future<TutorPage> call({
    required TutorSearchCriteria criteria,
    int limit = 20,
    PaginationCursor? startAfter,
  }) {
    final searchKey = keyBuilder.build(criteria);

    if (searchKey == null) {
      throw ArgumentError(
        'curriculumKey and teachingMode are required for tutor search.',
      );
    }

    return repository.searchTutors(
      searchKey: searchKey,
      minRating: criteria.minRating,
      limit: limit,
      startAfter: startAfter,
    );
  }
}
