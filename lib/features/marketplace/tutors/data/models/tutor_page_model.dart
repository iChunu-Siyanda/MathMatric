import 'package:math_matric/features/marketplace/tutors/data/datasources/remote/firestore_pagination_cursor.dart';
import 'package:math_matric/features/marketplace/tutors/data/models/tutor_model.dart';

class TutorPageModel {
  final List<TutorModel> tutors;
  final FirestorePaginationCursor? lastCursor;
  final bool hasMore;

  const TutorPageModel({
    required this.tutors,
    required this.lastCursor,
    required this.hasMore,
  });
}
