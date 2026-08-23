import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';

abstract class ExamPaperStorageRepository {
  Future<void> downloadPaper(
    ExamPaperEntity paper,
  );

  Future<String?> getPagePath({
    required String paperId,
    required String fileName,
  });

  Future<bool> isPaperDownloaded(
    ExamPaperEntity paper,
  );

  Future<void> deletePaper(
    ExamPaperEntity paper,
  );
}
