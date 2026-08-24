import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_storage_repository.dart';

class GetExamPaperPagesUseCase {
  final ExamPaperStorageRepository repository;

  GetExamPaperPagesUseCase(this.repository);

  Future<List<String>> call(
    ExamPaperEntity paper,
  ) async {
    final pages = <String>[];

    for (int i = 1; i <= paper.pageCount; i++) {
      final fileName = 'p-${i.toString().padLeft(2, '0')}.webp';

      final path = await repository.getPagePath(
        paperId: paper.id,
        fileName: fileName,
      );

      if (path == null) {
        throw Exception('Exam paper page not found: $fileName',);
      }

      pages.add(path);
    }

    return pages;
  }
}
