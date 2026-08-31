import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/core/constants/firestore_collections.dart';
import 'package:math_matric/features/marketplace/tutors/data/datasources/remote/firestore_pagination_cursor.dart';
import 'package:math_matric/features/marketplace/tutors/data/datasources/remote/tutor_remote_data_source.dart';
import 'package:math_matric/features/marketplace/tutors/data/models/tutor_page_model.dart';
import '../models/tutor_model.dart';

class TutorRemoteDataSourceImpl implements TutorRemoteDataSource {
  final FirebaseFirestore firestore;

  TutorRemoteDataSourceImpl({
    required this.firestore,
  });

  CollectionReference<Map<String, dynamic>> get _tutors => firestore.collection(FirestoreCollections.tutors);

  TutorPageModel _toPage(QuerySnapshot<Map<String, dynamic>> snapshot, int limit) {
    return TutorPageModel(
      tutors: snapshot.docs
          .map(
            (doc) => TutorModel.fromFirestore({
              ...doc.data(),
              'id': doc.id,
            }),
          )
          .toList(),
      lastCursor: snapshot.docs.isEmpty
          ? null
          : FirestorePaginationCursor(
              document: snapshot.docs.last,
            ),
      hasMore: snapshot.docs.length == limit,
    );
  }
    @override
  Future<TutorModel> getTutor(String tutorId) async {
    final doc = await _tutors.doc(tutorId).get();

    if (!doc.exists) {
      throw Exception('Tutor not found');
    }

    return TutorModel.fromFirestore({
      ...doc.data()!,
      'id': doc.id,
    });
  }

  @override
  Future<TutorPageModel> getTutors({
    int limit = 20,
    FirestorePaginationCursor? startAfter,
  }) async {
    Query<Map<String, dynamic>> query = _tutors
        .where('profileStatus', isEqualTo: 'published')
        .orderBy('displayName')
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter.document);
    }

    final snapshot = await query.get();

    return _toPage(snapshot, limit);
  }

  @override
  Future<TutorPageModel> searchTutors({
    required String searchKey,
    double? minRating,
    int limit = 20,
    FirestorePaginationCursor? startAfter,
  }) async {
    Query<Map<String, dynamic>> query = _tutors.where(
      'profileStatus',
      isEqualTo: 'published',
    );

    query = query.where(
      'searchKeys',
      arrayContains: searchKey,
    );

    if (minRating != null) {
      query = query.where(
        'rating',
        isGreaterThanOrEqualTo: minRating,
      );
    }

    query = query.orderBy(
          'rating',
          descending: true,
        )
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(
        startAfter.document,
      );
    }

    final snapshot = await query.get();

    return _toPage(snapshot, limit);
  }
}
