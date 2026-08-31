import 'package:math_matric/features/marketplace/tutors/domain/entities/pagination_cursor.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_entity.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_page.dart';

abstract class TutorRepository {
  Future<TutorPage> getTutors({
    int limit = 20,
    PaginationCursor? startAfter,
  });

  Future<TutorEntity> getTutor(String tutorId);

  Future<TutorPage> searchTutors({
    required String searchKey,
    double? maxPrice,
    double? minRating,
    int limit = 20,
    PaginationCursor? startAfter,
  });
}
