import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_storage_repository.dart';

class DownloadExamPaperUseCase {
  final ExamPaperStorageRepository repository;
  DownloadExamPaperUseCase(this.repository);

  Future<void> call({
    required ExamPaperEntity paper,
  }) {
    return repository.downloadPaper(paper);
  }
}
