import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/core/constants/firestore_collections.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/datasource/remote/user_topic_progress_remote_data_source.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/models/user_topic_progresses_model.dart';

class UserTopicProgressRemoteDataSourceImpl implements UserTopicProgressRemoteDataSource {
  final FirebaseFirestore firestore;
  UserTopicProgressRemoteDataSourceImpl(this.firestore,);

  CollectionReference<Map<String, dynamic>> _progresses(
    String userId,
  ) {
    return firestore
        .collection(FirestoreCollections.userdata)
        .doc(FirestoreCollections.mathUser)
        .collection('userId')
        .doc(userId)
        .collection(FirestoreCollections.userTopicProgress);
  }

  @override
  Future<List<UserTopicProgressModel>>
      getAllUserTopicProgresses(
    String userId,
  ) async {
    final snapshot = await _progresses(userId).get();

    return snapshot.docs
        .map(
          (doc) => UserTopicProgressModel.fromFirestore(
            doc.data(),
          ),
        )
        .toList();
  }

  @override
  Future<UserTopicProgressModel?> getUserTopicProgress(
    String userId,
    String topicId,
  ) async {
    final doc = await _progresses(userId)
        .doc(topicId)
        .get();

    if (!doc.exists) return null;

    return UserTopicProgressModel.fromFirestore(
      doc.data()!,
    );
  }

  @override
  Future<void> saveUserTopicProgress(
    String userId,
    UserTopicProgressModel progress,
  ) async {
    await _progresses(userId)
        .doc(progress.id)
        .set(
          progress.toFirestore(),
        );
  }

  @override
  Future<void> saveUserTopicProgresses(
    String userId,
    List<UserTopicProgressModel> progresses,
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
  Future<void> deleteUserTopicProgress(
    String userId,
    String progressId,
  ) async {
    await _progresses(userId)
        .doc(progressId)
        .delete();
  }
}
