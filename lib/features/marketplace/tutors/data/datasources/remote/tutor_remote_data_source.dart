import 'package:math_matric/features/marketplace/tutors/data/datasources/remote/firestore_pagination_cursor.dart';
import 'package:math_matric/features/marketplace/tutors/data/models/tutor_model.dart';
import 'package:math_matric/features/marketplace/tutors/data/models/tutor_page_model.dart';

abstract class TutorRemoteDataSource {
  Future<TutorPageModel> getTutors({
    int limit = 20,
    FirestorePaginationCursor? startAfter,
  });

  Future<TutorModel> getTutor(String tutorId);
}
