import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/features/marketplace/tutors/data/datasources/remote/tutor_remote_data_source.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_page.dart';
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
    DocumentSnapshot? startAfter,
  }) async {
    final result = await remoteDataSource.getTutors(
      limit: limit,
      startAfter: startAfter,
    );

    return TutorPage(
      tutors: result.tutors, 
      lastDocument: result.lastDocument, 
      hasMore: result.hasMore,
    );
  }

  @override
  Future<TutorEntity> getTutor(String tutorId) {
    return remoteDataSource.getTutor(tutorId);
  }
}
