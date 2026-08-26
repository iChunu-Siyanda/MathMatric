import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/core/constants/firestore_collections.dart';
import 'package:math_matric/features/progress/studysession/data/datasource/remote/study_session_remote_data_source.dart';
import 'package:math_matric/features/progress/studysession/data/models/study_session_model.dart';

class StudySessionRemoteDataSourceImpl implements StudySessionRemoteDataSource {
  final FirebaseFirestore firestore;

  StudySessionRemoteDataSourceImpl(
    this.firestore,
  );

  CollectionReference<Map<String, dynamic>> _sessions(
    String userId,
  ) {
    return firestore
        .collection(FirestoreCollections.userdata)
        .doc(FirestoreCollections.mathUser)
        .collection('userId')
        .doc(userId)
        .collection(FirestoreCollections.studySessions);
  }

  @override
  Future<List<StudySessionModel>> getAllStudySessions(
    String userId,
  ) async {
    final snapshot = await _sessions(userId).get();

    return snapshot.docs
        .map(
          (doc) => StudySessionModel.fromFirestore(
            doc.data(),
          ),
        )
        .toList();
  }

  @override
  Future<StudySessionModel?> getStudySession(
    String userId,
    String sessionId,
  ) async {
    final doc = await _sessions(userId)
        .doc(sessionId)
        .get();

    if (!doc.exists) return null;

    return StudySessionModel.fromFirestore(
      doc.data()!,
    );
  }

  @override
  Future<void> saveStudySession(
    String userId,
    StudySessionModel session,
  ) async {
    await _sessions(userId)
        .doc(session.id)
        .set(
          session.toFirestore(),
        );
  }

  @override
  Future<void> saveStudySessions(
    String userId,
    List<StudySessionModel> sessions,
  ) async {
    final batch = firestore.batch();

    for (final session in sessions) {
      final ref = _sessions(userId)
          .doc(session.id);

      batch.set(
        ref,
        session.toFirestore(),
      );
    }

    await batch.commit();
  }

  @override
  Future<void> deleteStudySession(
    String userId,
    String sessionId,
  ) async {
    await _sessions(userId)
        .doc(sessionId)
        .delete();
  }
}
