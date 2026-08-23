import 'package:math_matric/features/curriculum/exams/data/datasource/local/exam_paper_local_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/storage/local/exam_paper_local_storage_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/storage/remote/exam_paper_remote_storage_data_source.dart';
import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_storage_repository.dart';

class ExamPaperStorageRepositoryImpl implements ExamPaperStorageRepository {
  final ExamPaperRemoteStorageDataSource remote;
  final ExamPaperLocalStorageDataSource localStorage;
  final ExamPaperLocalDataSource localData;

  ExamPaperStorageRepositoryImpl({
    required this.remote,
    required this.localStorage,
    required this.localData,
  });

  @override
  Future<void> downloadPaper(
    ExamPaperEntity paper,
  ) async {
    final pagePaths = await remote.getPagePaths(
      storagePath: paper.storagePath,
      pageCount: paper.pageCount,
    );

    try {
      for (final fullPath in pagePaths) {
        final fileName = fullPath.split('/').last;

        final exists =
            await localStorage.pageExists(
          paperId: paper.id,
          fileName: fileName,
        );

        if (exists) {
          continue;
        }

        final data = await remote.downloadPage(
          storagePath: paper.storagePath,
          fileName: fileName,
        );

        await localStorage.savePage(
          paperId: paper.id,
          fileName: fileName,
          data: data,
        );
      }

      await localData.updateDownloadedStatus(
        paperId: paper.id,
        downloaded: true,
      );
    } catch (e) {
      // Don't leave the database saying
      // the paper is downloaded if something failed.
      await localData.updateDownloadedStatus(
        paperId: paper.id,
        downloaded: false,
      );

      rethrow;
    }
  }

  @override
  Future<String?> getPagePath({
    required String paperId,
    required String fileName,
  }) {
    return localStorage.getPagePath(
      paperId: paperId,
      fileName: fileName,
    );
  }

  @override
  Future<bool> isPaperDownloaded(
    ExamPaperEntity paper,
  ) async {
    if (paper.downloaded != true) {
      return false;
    }

    for (int i = 1; i <= paper.pageCount; i++) {
      final fileName =
          'p-${i.toString().padLeft(2, '0')}.webp';

      final exists =
          await localStorage.pageExists(
        paperId: paper.id,
        fileName: fileName,
      );

      if (!exists) {
        return false;
      }
    }

    return true;
  }

  @override
  Future<void> deletePaper(
    ExamPaperEntity paper,
  ) async {
    await localStorage.deletePaper(
      paper.id,
    );

    await localData.updateDownloadedStatus(
      paperId: paper.id,
      downloaded: false,
    );
  }
}
