import 'package:math_matric/features/marketplace/tutors/data/datasources/remote/firestore_pagination_cursor.dart';
import 'package:math_matric/features/marketplace/tutors/data/datasources/remote/tutor_remote_data_source.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_page.dart';

import '../../domain/entities/pagination_cursor.dart';
import '../../domain/entities/tutor_entity.dart';
import '../../domain/repositories/tutor_repository.dart';

class TutorRepositoryImpl implements TutorRepository {
  final TutorRemoteDataSource remoteDataSource;

  TutorRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<TutorPage> getTutors({
    int limit = 20,
    PaginationCursor? startAfter,
  }) async {
    final firestoreCursor = startAfter is FirestorePaginationCursor
        ? startAfter
        : null;

    final result = await remoteDataSource.getTutors(
      limit: limit,
      startAfter: firestoreCursor,
    );

    return TutorPage(
      tutors: result.tutors,
      lastCursor: result.lastCursor,
      hasMore: result.hasMore,
    );
  }

  @override
  Future<TutorEntity> getTutor(String tutorId) {
    return remoteDataSource.getTutor(tutorId);
  }
}
