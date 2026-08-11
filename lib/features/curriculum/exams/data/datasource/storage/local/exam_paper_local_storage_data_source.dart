import 'dart:typed_data';

abstract class ExamPaperLocalStorageDataSource {
  Future<String> savePage({
    required String paperId,
    required String fileName,
    required Uint8List data,
  });

  Future<String?> getPagePath({
    required String paperId,
    required String fileName,
  });

  Future<bool> pageExists({
    required String paperId,
    required String fileName,
  });

  Future<void> deletePaper(String paperId);
}
