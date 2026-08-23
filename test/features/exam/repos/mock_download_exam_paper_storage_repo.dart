import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_storage_repository.dart';

class MockDownloadExamPaperStorageRepository implements ExamPaperStorageRepository {
  ExamPaperEntity? downloadedPaper;

  @override
  Future<void> downloadPaper(
    ExamPaperEntity paper,
  ) async {
    downloadedPaper = paper;
  }

  @override
  Future<String?> getPagePath({
    required String paperId,
    required String fileName,
  }) async {
    return null;
  }

  @override
  Future<bool> isPaperDownloaded(
    ExamPaperEntity paper,
  ) async {
    return downloadedPaper?.id == paper.id;
  }

  @override
  Future<void> deletePaper(
    ExamPaperEntity paper,
  ) async {}
}
