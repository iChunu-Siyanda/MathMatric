import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_storage_repository.dart';
import 'package:math_matric/features/ui/exam/domain/usercases/get_exam_paper_pages_use_case.dart';

class OpenExamPaperUseCase {
  final ExamPaperStorageRepository storageRepository;
  final GetExamPaperPagesUseCase getExamPaperPages;

  OpenExamPaperUseCase({
    required this.storageRepository,
    required this.getExamPaperPages,
  });

  Future<List<String>> call(
    ExamPaperEntity paper,
  ) async {
    final downloaded = await storageRepository.isPaperDownloaded(paper);

    if (!downloaded) {
      await storageRepository.downloadPaper(paper);
    }

    return getExamPaperPages(paper);
  }
}
