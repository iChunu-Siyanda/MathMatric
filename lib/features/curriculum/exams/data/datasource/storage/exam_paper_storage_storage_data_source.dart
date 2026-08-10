import 'dart:typed_data';

abstract class ExamPaperStorageDataSource {
  Future<Uint8List> downloadPage({
    required String storagePath,
    required String fileName,
  });

  Future<List<String>> getPagePaths({
    required String storagePath,
    required int pageCount,
  });
}
