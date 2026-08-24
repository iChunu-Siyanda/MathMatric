import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_repository.dart';

class GetExamPapersBySessionUseCase {
  final ExamPapersRepository repository;

  GetExamPapersBySessionUseCase(this.repository);

  Future<List<ExamPaperEntity>> call({
    required String session,
  }) {
    return repository.getExamPapersBySession(session);
  }
}
