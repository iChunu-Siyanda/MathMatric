import 'package:math_matric/features/curriculum/exams/data/datasource/storage/local/exam_paper_local_storage_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/storage/remote/exam_paper_remote_storage_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/models/exam_paper_model.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_download_repository.dart';

class ExamPaperDownloadRepositoryImpl implements ExamPaperDownloadRepository {
  final ExamPaperRemoteStorageDataSource remoteStorage;
  final ExamPaperLocalStorageDataSource localStorage;

  ExamPaperDownloadRepositoryImpl({
    required this.remoteStorage,
    required this.localStorage,
  });

  @override
  Future<void> downloadPaper(
    ExamPaperModel paper,
  ) async {
    try {
      final pagePaths = await remoteStorage.getPagePaths(
        storagePath: paper.storagePath,
        pageCount: paper.pageCount,
      );

      for (final remotePath in pagePaths) {
        final fileName = remotePath.split('/').last;

        final data = await remoteStorage.downloadPage(
          storagePath: paper.storagePath,
          fileName: fileName,
        );

        await localStorage.savePage(
          paperId: paper.id,
          fileName: fileName,
          data: data,
        );
      }
    } catch (e) {
      await localStorage.deletePaper(paper.id,);

      rethrow;
    }
  }
}
