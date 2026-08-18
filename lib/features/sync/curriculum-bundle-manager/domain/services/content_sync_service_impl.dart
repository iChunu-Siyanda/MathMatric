import 'package:math_matric/features/sync/curriculum-bundle-manager/data/datasource/local/downloaded_bundle_local_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/local/exam_paper_local_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/remote/exam_paper_remote_data_source.dart';
import 'package:math_matric/features/curriculum/levels/data/datasource/local/levels_local_datasource.dart';
import 'package:math_matric/features/curriculum/levels/data/datasource/remote/levels_remote_data_source.dart';
import 'package:math_matric/features/curriculum/questions/data/datasource/local/questions_local_datasource.dart';
import 'package:math_matric/features/curriculum/questions/data/datasource/remote/questions_remote_datasource.dart';
import 'package:math_matric/features/curriculum/subjects/data/datasource/local/subjects_local_datasource.dart';
import 'package:math_matric/features/curriculum/subjects/data/datasource/remote/subjects_remote_datasource.dart';
import 'package:math_matric/features/curriculum/topics/data/datasource/local/topic_local_datasource.dart';
import 'package:math_matric/features/curriculum/topics/data/datasource/remote/topic_remote_datasource.dart';
import 'package:math_matric/core/constants/bundle_ids.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/data/datasource/remote/bundle_remote_data_source.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/data/models/downloaded_bundle_model.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/domain/entities/sync_progress.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/domain/entities/sync_status.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/domain/services/content_sync_service.dart';

class ContentSyncServiceImpl implements ContentSyncService {

  final SubjectsRemoteDataSource subjectRemote;
  final TopicRemoteDataSource topicRemote;
  final LevelsRemoteDataSource levelRemote;
  final QuestionsRemoteDataSource questionRemote;
  final ExamPaperRemoteDataSource examPaperRemote;

  final SubjectsLocalDataSource subjectLocal;
  final TopicLocalDataSource topicLocal;
  final LevelsLocalDatasource levelLocal;
  final QuestionsLocalDatasource questionLocal;
  final ExamPaperLocalDataSource examPaperLocal;

  final DownloadedBundleLocalDataSource bundleLocal;
  final BundleRemoteDataSource bundleRemote;

  ContentSyncServiceImpl({
    required this.subjectRemote,
    required this.topicRemote,
    required this.levelRemote,
    required this.questionRemote,
    required this.examPaperRemote,
    required this.subjectLocal,
    required this.topicLocal,
    required this.levelLocal,
    required this.questionLocal,
    required this.examPaperLocal,
    required this.bundleLocal, 
    required this.bundleRemote,
  });

  @override
  Future<void> clearLocalContent() async {
    await subjectLocal.clearSubjects();

    await topicLocal.clearTopics();

    await levelLocal.clearLevels();

    await questionLocal.clearQuestions();

    await examPaperLocal.clearExamPapers();
  }


  @override
    Future<bool> needsUpdate() async {
      final remote = await bundleRemote.getBundleInfo(BundleIds.curriculum);
      if (remote == null) {return false;}
      final local = await bundleLocal.getBundle(BundleIds.curriculum);

      return remote.version > (local?.version ?? 0);
    }

  @override
  Stream<SyncProgress> synchronize() async* {
    try{
      yield const SyncProgress(
        status: SyncStatus.checking,
        progress: 0,
        message: "Checking for updates...",
      );

      final bundle = await bundleRemote.downloadBundle(BundleIds.curriculum);
      yield const SyncProgress(
        status: SyncStatus.downloading,
        progress: 0.3,
        message: 'Downloading curriculum...',
      );

      yield const SyncProgress(
        status: SyncStatus.saving,
        progress: .60,
        message: "Saving to device...",
      );

      await clearLocalContent();
      await subjectLocal.saveSubjects(bundle.subjects);
      await topicLocal.saveTopics(bundle.topics);
      await levelLocal.saveLevels(bundle.levels);
      await questionLocal.saveQuestions(bundle.questions);
      await examPaperLocal.saveExamPapers(bundle.examPapers);

      await bundleLocal.saveBundle(
        DownloadedBundleModel(
          id: bundle.info.id,
          version: bundle.info.version,
          downloadedAt: DateTime.now(),
        ),
      );

      yield const SyncProgress(
        status: SyncStatus.completed,
        progress: 1,
        message: "Done. Curriculum installed.",
      );
    } catch (e) {

      yield SyncProgress(
        status: SyncStatus.failed,
        progress: 0.0,
        message: e.toString(),
      );
    }
  }
}
