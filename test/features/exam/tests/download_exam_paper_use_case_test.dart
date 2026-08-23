import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/papers/exam/domain/usercases/download_exam_paper_use_case.dart';

import '../repos/mock_download_exam_paper_storage_repo.dart';

void main() {
  late MockDownloadExamPaperStorageRepository repository;
  late DownloadExamPaperUseCase useCase;

  setUp(() {
    repository = MockDownloadExamPaperStorageRepository();
    useCase = DownloadExamPaperUseCase(repository);
  });

  final paper = ExamPaperEntity(
    id: 'paper-1',
    subjectId: 'math',
    paperType: 'paper1',
    session: 'november',
    title: 'Mathematics Paper 1',
    isMemo: false,
    storagePath: 'exam-papers/math/2025/november/paper-1',
    isNational: true,
    year: 2025,
    pageCount: 10,
  );

  test('downloads the requested paper', () async {
    await useCase(paper: paper);

    expect(
      repository.downloadedPaper?.id,
      'paper-1',
    );
  });
}
