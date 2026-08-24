import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_storage_repository.dart';
import 'package:math_matric/features/papers/exam/domain/usercases/get_exam_paper_pages_use_case.dart';
import 'package:math_matric/features/papers/exam/domain/usercases/open_exam_paper_use_case.dart';

class MockOpenExamPaperUseCase implements OpenExamPaperUseCase {
  List<String> pages = [];
  ExamPaperEntity? receivedPaper;
  
  @override
  Future<List<String>> call(ExamPaperEntity paper) async {
    receivedPaper = paper;
    return pages;
  }

  @override
  GetExamPaperPagesUseCase get getExamPaperPages => throw UnimplementedError();

  @override
  ExamPaperStorageRepository get storageRepository => throw UnimplementedError();

}
