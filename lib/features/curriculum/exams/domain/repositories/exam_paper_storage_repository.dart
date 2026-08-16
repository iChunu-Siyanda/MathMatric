import 'package:math_matric/features/curriculum/exams/data/models/exam_paper_model.dart';

abstract class ExamPaperStorageRepository {
  Future<void> downloadPaper(
    ExamPaperModel paper,
  );

  Future<String?> getPagePath({
    required String paperId,
    required String fileName,
  });

  Future<bool> isPaperDownloaded(
    ExamPaperModel paper,
  );

  Future<void> deletePaper(
    ExamPaperModel paper,
  );
}
