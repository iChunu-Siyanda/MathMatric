import 'package:math_matric/features/curriculum/exams/data/datasource/local/exam_paper_local_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/storage/local/exam_paper_local_storage_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/storage/remote/exam_paper_remote_storage_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/models/exam_paper_model.dart';
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
    final model = ExamPaperModel.fromEntity(
      paper,
      version: 1,
    );

    final pagePaths = await remote.getPagePaths(
      storagePath: model.storagePath,
      pageCount: model.pageCount,
    );

    try {
      for (final fullPath in pagePaths) {
        final fileName = fullPath.split('/').last;

        final exists = await localStorage.pageExists(
          paperId: model.id,
          fileName: fileName,
        );

        if (exists) continue;

        final data = await remote.downloadPage(
          storagePath: model.storagePath,
          fileName: fileName,
        );

        await localStorage.savePage(
          paperId: model.id,
          fileName: fileName,
          data: data,
        );
      }

      await localData.updateDownloadedStatus(
        paperId: model.id,
        downloaded: true,
      );
    } catch (e) {
      await localData.updateDownloadedStatus(
        paperId: model.id,
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
    final model = ExamPaperModel.fromEntity(
      paper,
      version: 1,
    );

    if (model.downloaded != true) {
      return false;
    }

    for (int i = 1; i <= model.pageCount; i++) {
      final fileName =
          'p-${i.toString().padLeft(2, '0')}.webp';

      final exists = await localStorage.pageExists(
        paperId: model.id,
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
    final model = ExamPaperModel.fromEntity(
      paper,
      version: 1,
    );

    await localStorage.deletePaper(
      model.id,
    );

    await localData.updateDownloadedStatus(
      paperId: model.id,
      downloaded: false,
    );
  }
}
