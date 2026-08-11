import 'dart:typed_data';

abstract class ExamPaperRemoteStorageDataSource {
  Future<Uint8List> downloadPage({
    required String storagePath,
    required String fileName,
  });

  Future<List<String>> getPagePaths({
    required String storagePath,
    required int pageCount,
  });
}
