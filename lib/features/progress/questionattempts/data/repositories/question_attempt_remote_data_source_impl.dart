import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/core/constants/firestore_collections.dart';
import 'package:math_matric/features/progress/questionattempts/data/datasource/remote/question_attempt_remote_data_source.dart';
import 'package:math_matric/features/progress/questionattempts/data/models/questions_attempt_model.dart';

class QuestionAttemptRemoteDataSourceImpl implements QuestionAttemptRemoteDataSource {
  final FirebaseFirestore firestore;
  QuestionAttemptRemoteDataSourceImpl(this.firestore,);

  CollectionReference<Map<String, dynamic>> _attempts(
    String userId,
  ) {
    return firestore
        .collection(FirestoreCollections.userdata)
        .doc(FirestoreCollections.mathUser)
        .collection('userId')
        .doc(userId)
        .collection(FirestoreCollections.questionAttempts);
  }

  @override
  Future<List<QuestionAttemptModel>> getAllQuestionAttempts(
    String userId,
  ) async {
    final snapshot = await _attempts(userId).get();

    return snapshot.docs
        .map((doc) => QuestionAttemptModel.fromFirestore(
            doc.data(),
          ),
        )
        .toList();
  }

  @override
  Future<QuestionAttemptModel?> getQuestionAttempt(
    String userId,
    String attemptId,
  ) async {
    final doc = await _attempts(userId)
        .doc(attemptId)
        .get();

    if (!doc.exists) return null;

    return QuestionAttemptModel.fromFirestore(
      doc.data()!,
    );
  }

  @override
  Future<void> saveQuestionAttempt(
    String userId,
    QuestionAttemptModel attempt,
  ) async {
    await _attempts(userId)
        .doc(attempt.id)
        .set(attempt.toFirestore(),);
  }

  @override
  Future<void> saveQuestionAttempts(
    String userId,
    List<QuestionAttemptModel> attempts,
  ) async {
    final batch = firestore.batch();

    for (final attempt in attempts) {
      final ref = _attempts(userId).doc(attempt.id);

      batch.set(
        ref,
        attempt.toFirestore(),
      );
    }

    await batch.commit();
  }

  @override
  Future<void> deleteQuestionAttempt(
    String userId,
    String attemptId,
  ) async {
    await _attempts(userId)
        .doc(attemptId)
        .delete();
  }
}
