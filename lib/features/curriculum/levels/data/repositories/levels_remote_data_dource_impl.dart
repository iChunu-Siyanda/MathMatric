import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/features/curriculum/levels/data/datasource/remote/levels_remote_data_source.dart';
import 'package:math_matric/features/curriculum/levels/data/models/levels_model.dart';
import 'package:math_matric/core/constants/firestore_collections.dart';

class LevelsRemoteDataDourceImpl implements LevelsRemoteDataSource{
  final FirebaseFirestore firestore;
  LevelsRemoteDataDourceImpl(this.firestore);
  
  @override
  Future<List<LevelsModel>> getAllLevels() async {
    final snapshot = await firestore
        .collection(FirestoreCollections.levels)
        .get();

    return snapshot.docs
        .map((doc) => LevelsModel.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Future<LevelsModel?> getLevel(String levelId) async {
    final doc = await firestore
        .collection(FirestoreCollections.levels)
        .doc(levelId)
        .get();

    if (!doc.exists) return null;

    return LevelsModel.fromFirestore(doc.data()!);
  }

  @override
  Future<List<LevelsModel>> getLevelsByTopic(String topicId) async {
    final snapshot = await firestore
        .collection(FirestoreCollections.levels)
        .where(
          'topicId',
          isEqualTo: topicId,
        )
        .get();

    return snapshot.docs
        .map((doc) => LevelsModel.fromFirestore(doc.data()))
        .toList();
  }
}
