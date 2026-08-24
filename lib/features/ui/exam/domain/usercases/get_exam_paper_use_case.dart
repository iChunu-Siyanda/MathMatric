import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_repository.dart';

class GetExamPaperUseCase {
  final ExamPapersRepository repository;

  GetExamPaperUseCase(this.repository);

  Future<ExamPaperEntity?> call({
    required String paperId,
  }) {
    return repository.getExamPaper(paperId);
  }
}
