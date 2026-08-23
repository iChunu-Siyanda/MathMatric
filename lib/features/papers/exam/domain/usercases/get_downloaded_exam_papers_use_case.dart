import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_repository.dart';

class GetDownloadedExamPapersUseCase {
  final ExamPapersRepository repository;

  GetDownloadedExamPapersUseCase(this.repository);

  Future<List<ExamPaperEntity>> call() {
    return repository.getDownloadedExamPapers();
  }
}
