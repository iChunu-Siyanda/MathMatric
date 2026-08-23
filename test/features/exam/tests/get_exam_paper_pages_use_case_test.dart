import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/papers/exam/domain/usercases/get_exam_paper_pages_use_case.dart';

import '../repos/mock_exam_paper_storage_repository.dart';

void main() {
  late MockExamPaperStorageRepository repository;
  late GetExamPaperPagesUseCase useCase;

  setUp(() {
    repository = MockExamPaperStorageRepository();
    useCase = GetExamPaperPagesUseCase(repository);
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
    pageCount: 3,
  );

  test('returns all local page paths', () async {
    repository.savedPages.addAll({
      'p-01.webp': '/local/paper-1/p-01.webp',
      'p-02.webp': '/local/paper-1/p-02.webp',
      'p-03.webp': '/local/paper-1/p-03.webp',
    });

    final result = await useCase(paper);

    expect(result, [
      '/local/paper-1/p-01.webp',
      '/local/paper-1/p-02.webp',
      '/local/paper-1/p-03.webp',
    ]);
  });

  test('throws when a page does not exist', () async {
    repository.savedPages.addAll({
      'p-01.webp': '/local/paper-1/p-01.webp',
      'p-02.webp': '/local/paper-1/p-02.webp',
    });

    expect(
      () => useCase(paper),
      throwsA(isA<Exception>()),
    );
  });
}

