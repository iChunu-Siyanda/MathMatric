import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';

abstract class ExamPaperStorageRepository {
  Future<void> downloadPaper(
    ExamPaperEntity paper,
  );

  Future<String?> getPagePath({
    required String paperId,
    required String fileName,
  });

  Future<List<String>> getPagePaths({
    required String paperId,
    required int pageCount,
  });

  Future<bool> isPaperDownloaded(
    ExamPaperEntity paper,
  );

  Future<void> deletePaper(
    ExamPaperEntity paper,
  );
}
