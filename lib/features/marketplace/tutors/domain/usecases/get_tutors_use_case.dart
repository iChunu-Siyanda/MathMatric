import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_page.dart';

import '../entities/pagination_cursor.dart';
import '../repositories/tutor_repository.dart';

class GetTutorsUseCase {
  final TutorRepository repository;
  GetTutorsUseCase(this.repository);

  Future<TutorPage> call({
    int limit = 20,
    PaginationCursor? startAfter,
  }) {
    return repository.getTutors(
      limit: limit,
      startAfter: startAfter,
    );
  }
}
