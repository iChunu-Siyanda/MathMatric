import 'package:math_matric/features/marketplace/tutors/domain/entities/pagination_cursor.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_entity.dart';

class TutorPage {
  final List<TutorEntity> tutors;
  final PaginationCursor? lastCursor;
  final bool hasMore;

  const TutorPage({
    required this.tutors,
    required this.lastCursor,
    required this.hasMore,
  });
}

// It's the pagination result object.
