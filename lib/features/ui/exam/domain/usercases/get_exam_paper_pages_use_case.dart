import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_storage_repository.dart';
import 'package:math_matric/features/ui/exam/domain/services/exam_paper_missing_exeption.dart';

class GetExamPaperPagesUseCase {
  final ExamPaperStorageRepository _repository;

  GetExamPaperPagesUseCase(this._repository);

  Future<List<String>> call(ExamPaperEntity paper) async {
    // 1. Guard input validity early
    if (paper.pageCount <= 0) {
      return const [];
    }

    // 2. Prepare parallel fetch tasks
    final tasks = List.generate(paper.pageCount, (index) async {
      final pageNumber = (index + 1).toString().padLeft(2, '0');
      final fileName = 'p-$pageNumber.webp';

      final path = await _repository.getPagePath(
        paperId: paper.id,
        fileName: fileName,
      );

      // 3. Fail fast on missing resources
      if (path == null || path.isEmpty) {
        throw ExamPaperMissingPageException(
          paperId: paper.id,
          fileName: fileName,
        );
      }

      return path;
    });

    // 4. Run concurrently; cancel immediately if any page fails
    return await Future.wait(tasks, eagerError: true);
  }
}

