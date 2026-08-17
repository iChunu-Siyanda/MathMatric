import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/core/constants/firestore_collections.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/datasource/remote/user_level_progress_remote_data_source.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/models/user_level_progresses_model.dart';

class UserLevelProgressRemoteDataSourceImpl implements UserLevelProgressRemoteDataSource {
  final FirebaseFirestore firestore;
  UserLevelProgressRemoteDataSourceImpl(this.firestore,);

  CollectionReference<Map<String, dynamic>> _progresses(
    String userId,
  ) {
    return firestore
        .collection(FirestoreCollections.userdata)
        .doc(userId)
        .collection('userLevelProgresses');
  }

  @override
  Future<List<UserLevelProgressModel>>
      getAllUserLevelProgresses(
    String userId,
  ) async {
    final snapshot = await _progresses(userId).get();

    return snapshot.docs
        .map(
          (doc) => UserLevelProgressModel.fromFirestore(
            doc.data(),
          ),
        )
        .toList();
  }

  @override
  Future<UserLevelProgressModel?> getUserLevelProgress(
    String userId,
    String levelId,
  ) async {
    final doc = await _progresses(userId)
        .doc(levelId)
        .get();

    if (!doc.exists) return null;

    return UserLevelProgressModel.fromFirestore(
      doc.data()!,
    );
  }

  @override
  Future<void> saveUserLevelProgress(
    String userId,
    UserLevelProgressModel progress,
  ) async {
    await _progresses(userId)
        .doc(progress.id)
        .set(
          progress.toFirestore(),
        );
  }

  @override
  Future<void> saveUserLevelProgresses(
    String userId,
    List<UserLevelProgressModel> progresses,
  ) async {
    final batch = firestore.batch();

    for (final progress in progresses) {
      final ref = _progresses(userId)
          .doc(progress.id);

      batch.set(
        ref,
        progress.toFirestore(),
      );
    }

    await batch.commit();
  }

  @override
  Future<void> deleteUserLevelProgress(
    String userId,
    String progressId,
  ) async {
    await _progresses(userId)
        .doc(progressId)
        .delete();
  }
}
