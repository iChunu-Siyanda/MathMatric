import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/features/curriculum/topics/data/datasource/remote/topic_remote_datasource.dart';
import 'package:math_matric/features/curriculum/topics/data/models/topic_model.dart';
import 'package:math_matric/core/constants/firestore_collections.dart';

class TopicRemoteDataSourceImpl implements TopicRemoteDataSource {
  final FirebaseFirestore firestore;
  TopicRemoteDataSourceImpl(this.firestore,);

  DocumentReference<Map<String, dynamic>> get firestoreRef => firestore.collection(FirestoreCollections.curriculum).doc(FirestoreCollections.mathmatric);

  @override
  Future<List<TopicModel>> getAllTopics() async {
    final snapshot = await firestoreRef
        .collection(FirestoreCollections.topics)
        .get();

    return snapshot.docs
        .map((doc) => TopicModel.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Future<TopicModel?> getTopic(
    String topicId,
  ) async {
    final doc = await firestoreRef
        .collection(FirestoreCollections.topics)
        .doc(topicId)
        .get();

    if (!doc.exists) return null;

    return TopicModel.fromFirestore(doc.data()!);
  }

  @override
  Future<List<TopicModel>> getTopicsBySubject(
    String subjectId,
  ) async {
    final snapshot = await firestoreRef
        .collection(FirestoreCollections.topics)
        .where(
          'subjectId',
          isEqualTo: subjectId,
        )
        .get();

    return snapshot.docs
        .map((doc) => TopicModel.fromFirestore(doc.data()))
        .toList();
  }
}
