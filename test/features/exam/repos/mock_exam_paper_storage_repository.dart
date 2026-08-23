import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_storage_repository.dart';

class MockExamPaperStorageRepository implements ExamPaperStorageRepository {
  final Map<String, String> savedPages = {};

  @override
  Future<String?> getPagePath({
    required String paperId,
    required String fileName,
  }) async {
    return savedPages[fileName];
  }

  @override
  Future<void> downloadPaper(
    ExamPaperEntity paper,
  ) async {}

  @override
  Future<bool> isPaperDownloaded(
    ExamPaperEntity paper,
  ) async {
    return true;
  }

  @override
  Future<void> deletePaper(
    ExamPaperEntity paper,
  ) async {}
}

