import 'package:math_matric/features/curriculum/subjects/data/datasource/remote/subjects_remote_datasource.dart';
import 'package:math_matric/features/curriculum/subjects/data/models/subjects_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/core/constants/firestore_collections.dart';

class SubjectsRemoteDataSourceImpl implements SubjectsRemoteDataSource {
  final FirebaseFirestore firestore;
  SubjectsRemoteDataSourceImpl(this.firestore,);

  DocumentReference<Map<String, dynamic>> get firestoreRef => firestore.collection(FirestoreCollections.curriculum).doc(FirestoreCollections.mathmatric);

  @override
  Future<List<SubjectsModel>> getAllSubjects() async {
    final snapshot = await firestoreRef
        .collection(FirestoreCollections.subjects)
        .get();

    return snapshot.docs
        .map((doc) => SubjectsModel.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Future<SubjectsModel?> getSubject(
    String subjectId,
  ) async {
    final doc = await firestoreRef
        .collection(FirestoreCollections.subjects)
        .doc(subjectId)
        .get();

    if (!doc.exists) return null;

    return SubjectsModel.fromFirestore(doc.data()!);
  }
}
