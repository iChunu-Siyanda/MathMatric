import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_repository.dart';

class GetExamPapersByTypeUseCase {
  final ExamPapersRepository repository;

  GetExamPapersByTypeUseCase(this.repository);

  Future<List<ExamPaperEntity>> call({
    required String paperType,
  }) {
    return repository.getExamPapersByType(paperType);
  }
}
