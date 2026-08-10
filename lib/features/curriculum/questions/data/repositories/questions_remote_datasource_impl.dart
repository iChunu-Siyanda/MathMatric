import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/features/curriculum/questions/data/datasource/remote/questions_remote_datasource.dart';
import 'package:math_matric/features/curriculum/questions/data/models/questions_model.dart';
import 'package:math_matric/core/constants/firestore_collections.dart';

class QuestionsRemoteDatasourceImpl implements QuestionsRemoteDataSource{
  final FirebaseFirestore firestore;
  QuestionsRemoteDatasourceImpl(this.firestore);

  @override
  Future<List<QuestionsModel>> getAllQuestions() async {
    final snapshot = await firestore
        .collection(FirestoreCollections.questions)
        .get();

    return snapshot.docs
        .map((doc) => QuestionsModel.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Future<QuestionsModel?> getQuestion(String questionId) async {
    final doc = await firestore
        .collection(FirestoreCollections.questions)
        .doc(questionId)
        .get();

    if (!doc.exists) return null;

    return QuestionsModel.fromFirestore(doc.data()!);
  }

  @override
  Future<List<QuestionsModel>> getQuestionsByLevel(String levelId) async {
    final snapshot = await firestore
        .collection(FirestoreCollections.questions)
        .where(
          'levelId',
          isEqualTo: levelId,
        )
        .get();

    return snapshot.docs
        .map((doc) => QuestionsModel.fromFirestore(doc.data()))
        .toList();
  }
}
