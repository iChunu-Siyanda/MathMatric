import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_storage_repository.dart';
import 'package:math_matric/features/ui/exam/domain/usercases/download_exam_paper_use_case.dart';

class MockDownloadBlocExamPaperUseCase implements DownloadExamPaperUseCase {
  ExamPaperEntity? downloadedPaper;

  @override
  Future<void> call({
    required ExamPaperEntity paper,
  }) async {
    downloadedPaper = paper;
  }

  @override
  ExamPaperStorageRepository get repository => throw UnimplementedError();
}
