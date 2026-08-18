import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/core/constants/firestore_collections.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/remote/exam_paper_remote_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/models/exam_paper_model.dart';
import 'package:math_matric/features/curriculum/levels/data/datasource/remote/levels_remote_data_source.dart';
import 'package:math_matric/features/curriculum/questions/data/datasource/remote/questions_remote_datasource.dart';
import 'package:math_matric/features/curriculum/subjects/data/datasource/remote/subjects_remote_datasource.dart';
import 'package:math_matric/features/curriculum/topics/data/datasource/remote/topic_remote_datasource.dart';
import 'package:math_matric/features/curriculum/topics/data/models/topic_model.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/data/datasource/remote/bundle_remote_data_source.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/data/models/bundle_info_model.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/domain/entities/curriculum_bundle.dart';

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
        .collection(FirestoreCollections.bundles)
        .doc(bundleId)
        .get();

    if (!doc.exists) {return null;}

    return BundleInfoModel.fromFirestore(doc.data()!,);
  }

  @override
  Future<CurriculumBundle> downloadBundle(
    String bundleId,
  ) async {
    final info = await getBundleInfo(bundleId);

    if (info == null) {
      throw Exception(
        'Bundle $bundleId not found.',
      );
    }

    final subject = await subjectRemote.getSubject(
      info.subjectId,
    );

    if (subject == null) {
      throw Exception(
        'Subject ${info.subjectId} not found.',
      );
    }

    // Topics and exam papers can be fetched
    // independently.
    final results = await Future.wait([
      topicRemote.getTopicsBySubject(
        info.subjectId,
      ),
      examPaperRemote.getExamPapersBySubject(
        info.subjectId,
      ),
    ]);

    final topics =
        results[0] as List<TopicModel>;

    final examPapers =
        results[1] as List<ExamPaperModel>;

    // Get levels for all topics in parallel.
    final levelResults = await Future.wait(
      topics.map(
        (topic) => levelRemote.getLevelsByTopic(
          topic.id,
        ),
      ),
    );

    final levels = levelResults
        .expand((levels) => levels)
        .toList();

    // Get questions for all levels in parallel.
    final questionResults = await Future.wait(
      levels.map(
        (level) => questionRemote.getQuestionsByLevel(
          level.id,
        ),
      ),
    );

    final questions = questionResults
        .expand((questions) => questions)
        .toList();

    return CurriculumBundle(
      info: info,
      subjects: [subject],
      topics: topics,
      levels: levels,
      questions: questions,
      examPapers: examPapers,
    );
  }
}
