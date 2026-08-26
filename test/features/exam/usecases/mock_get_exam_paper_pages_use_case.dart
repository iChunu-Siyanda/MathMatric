import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_storage_repository.dart';
import 'package:math_matric/features/ui/exam/domain/usercases/get_exam_paper_pages_use_case.dart';

class MockGetExamPaperPagesUseCase implements GetExamPaperPagesUseCase {
  List<String> pages = [];

  @override
  Future<List<String>> call(
    ExamPaperEntity paper,
  ) async {
    return pages;
  }

  ExamPaperStorageRepository get repository => throw UnimplementedError();
}
