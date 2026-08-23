import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_repository.dart';

class GetChildExamPapersUseCase {
  final ExamPapersRepository repository;

  GetChildExamPapersUseCase(this.repository);

  Future<List<ExamPaperEntity>> call({
    required String parentPaperId,
  }) {
    return repository.getChildPapers(parentPaperId);
  }
}
