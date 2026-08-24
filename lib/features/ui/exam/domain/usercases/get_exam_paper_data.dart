import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_repository.dart';

class GetExamPapersUseCase {
  final ExamPapersRepository repository;

  GetExamPapersUseCase(this.repository);

  Future<List<ExamPaperEntity>> call({
    required String subjectId,
    required String paperType,
    required String session,
    int? year,
  }) {
    return repository.getExamPapers(
      subjectId: subjectId,
      paperType: paperType,
      session: session,
      year: year,
    );
  }
}
