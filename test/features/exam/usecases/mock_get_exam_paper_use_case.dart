import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_repository.dart';
import 'package:math_matric/features/papers/exam/domain/usercases/get_exam_paper_use_case.dart';

class MockGetExamPaperUseCase implements GetExamPaperUseCase {
  ExamPaperEntity? paper;

  @override
  Future<ExamPaperEntity?> call({
    required String paperId,
  }) async {
    if (paper?.id == paperId) {
      return paper;
    }

    return null;
  }

  @override
  ExamPapersRepository get repository => throw UnimplementedError();
}
