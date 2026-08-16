import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/core/constants/firestore_collections.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/remote/exam_paper_remote_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/models/exam_paper_model.dart';

class ExamPaperRemoteDataSourceImpl  implements ExamPaperRemoteDataSource {
  final FirebaseFirestore firestore;
  ExamPaperRemoteDataSourceImpl(this.firestore);

  DocumentReference<Map<String, dynamic>> get firestoreRef => firestore.collection(FirestoreCollections.curriculum).doc(FirestoreCollections.mathmatric);

  @override
  Future<List<ExamPaperModel>> getAllExamPapers() async {
    final snapshot = await firestoreRef
        .collection(FirestoreCollections.examPapers)
        .get();

    return snapshot.docs
        .map((doc) => ExamPaperModel.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Future<ExamPaperModel?> getExamPaper(
    String paperId,
  ) async {
    final doc = await firestoreRef
        .collection(FirestoreCollections.examPapers)
        .doc(paperId)
        .get();

    if (!doc.exists) return null;

    return ExamPaperModel.fromFirestore(doc.data()!);
  }

  @override
  Future<List<ExamPaperModel>> getExamPapersBySubject(
    String subjectId,
  ) async {
    final snapshot = await firestoreRef
        .collection(FirestoreCollections.examPapers)
        .where(
          'subjectId',
          isEqualTo: subjectId,
        )
        .get();

    return snapshot.docs
        .map(
          (doc) => ExamPaperModel.fromFirestore(
            doc.data(),
          ),
        )
        .toList();
  }

  @override
  Future<List<ExamPaperModel>> getExamPapersByYear(
    int year,
  ) async {
    final snapshot = await firestoreRef
        .collection(FirestoreCollections.examPapers)
        .where('year', isEqualTo: year)
        .get();

    return snapshot.docs
        .map((doc) => ExamPaperModel.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Future<List<ExamPaperModel>> getExamPapersBySession(
    String session,
  ) async {
    final snapshot = await firestoreRef
        .collection(FirestoreCollections.examPapers)
        .where('session', isEqualTo: session)
        .get();

    return snapshot.docs
        .map((doc) => ExamPaperModel.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Future<List<ExamPaperModel>> getNationalExamPapers() async {
    final snapshot = await firestoreRef
        .collection(FirestoreCollections.examPapers)
        .where('isNational', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => ExamPaperModel.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Future<List<ExamPaperModel>> getProvincialExamPapers(
    String province,
  ) async {
    final snapshot = await firestoreRef
        .collection(FirestoreCollections.examPapers)
        .where('province', isEqualTo: province)
        .get();

    return snapshot.docs
        .map((doc) => ExamPaperModel.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Future<List<ExamPaperModel>> getMemoPapers() async {
    final snapshot = await firestoreRef
        .collection(FirestoreCollections.examPapers)
        .where('isMemo', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => ExamPaperModel.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Future<List<ExamPaperModel>> getChildPapers(
    String parentPaperId,
  ) async {
    final snapshot = await firestoreRef
        .collection(FirestoreCollections.examPapers)
        .where(
          'parentPaperId',
          isEqualTo: parentPaperId,
        )
        .get();

    return snapshot.docs
        .map((doc) => ExamPaperModel.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Future<List<ExamPaperModel>> getExamPapersByType(String paperType) async {
    final snapshot = await firestoreRef
        .collection(FirestoreCollections.examPapers)
        .where(
          'paperType',
          isEqualTo: paperType,
        )
        .get();

    return snapshot.docs
        .map((doc) => ExamPaperModel.fromFirestore(doc.data(),),)
        .toList();
  }
}
