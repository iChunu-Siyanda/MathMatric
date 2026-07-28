import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/remote/exam_paper_remote_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/models/exam_paper_model.dart';
import 'package:math_matric/features/curriculum/levels/data/datasource/remote/levels_remote_data_source.dart';
import 'package:math_matric/features/curriculum/levels/data/models/levels_model.dart';
import 'package:math_matric/features/curriculum/questions/data/datasource/remote/questions_remote_datasource.dart';
import 'package:math_matric/features/curriculum/questions/data/models/questions_model.dart';
import 'package:math_matric/features/curriculum/subjects/data/datasource/remote/subjects_remote_datasource.dart';
import 'package:math_matric/features/curriculum/subjects/data/models/subjects_model.dart';
import 'package:math_matric/features/curriculum/topics/data/datasource/remote/topic_remote_datasource.dart';
import 'package:math_matric/features/curriculum/topics/data/models/topic_model.dart';
import 'package:math_matric/features/sync/data/datasource/remote/bundle_remote_data_source.dart';
import 'package:math_matric/features/sync/data/models/bundle_info_model.dart';
import 'package:math_matric/features/sync/domain/entities/curriculum_bundle.dart';

class BundleRemoteDataSourceImpl implements BundleRemoteDataSource {
  final FirebaseFirestore firestore;
  final SubjectsRemoteDataSource subjectRemote;
  final TopicRemoteDataSource topicRemote;
  final LevelsRemoteDataSource levelRemote;
  final QuestionsRemoteDataSource questionRemote;
  final ExamPaperRemoteDataSource examPaperRemote;

  BundleRemoteDataSourceImpl({
    required this.firestore,
    required this.subjectRemote,
    required this.topicRemote,
    required this.levelRemote,
    required this.questionRemote,
    required this.examPaperRemote,
  });

  @override
  Future<BundleInfoModel?> getBundleInfo(
    String bundleId,
  ) async {
    final doc = await firestore
        .collection("bundles")
        .doc(bundleId)
        .get();

    if (!doc.exists) {return null;}

    return BundleInfoModel.fromFirestore(doc.data()!,);
  }

  @override
  Future<CurriculumBundle> downloadBundle(
    String bundleId,
  ) async {
    final info = await getBundleInfo(bundleId,);

    if (info == null) {
      throw Exception("Bundle does not exist.",);
    }

    final results = await Future.wait([
      subjectRemote.getAllSubjects(),
      topicRemote.getAllTopics(),
      levelRemote.getAllLevels(),
      questionRemote.getAllQuestions(),
      examPaperRemote.getAllExamPapers(),
    ]);

    return CurriculumBundle(
      info: info,
      subjects: results[0] as List<SubjectsModel>,
      topics: results[1] as List<TopicModel>,
      levels: results[2] as List<LevelsModel>,
      questions: results[3] as List<QuestionsModel>,
      examPapers: results[4] as List<ExamPaperModel>,
    );
  }
}
