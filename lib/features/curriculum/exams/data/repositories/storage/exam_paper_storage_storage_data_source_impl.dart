import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/storage/remote/exam_paper_remote_storage_data_source.dart';

class ExamPaperRemoteStorageDataSourceImpl implements ExamPaperRemoteStorageDataSource {
  final FirebaseStorage storage;
  ExamPaperRemoteStorageDataSourceImpl(this.storage);

  @override
  Future<Uint8List> downloadPage({
    required String storagePath,
    required String fileName,
  }) async {
    final ref = storage.ref().child('$storagePath/$fileName',);
    final data = await ref.getData();

    if (data == null) {
      throw Exception(
        'Could not download exam paper page: $fileName',
      );
    }

    return data;
  }

  @override
  Future<List<String>> getPagePaths({
    required String storagePath,
    required int pageCount,
  }) async {
    return List.generate(
      pageCount, (index) {
        final pageNumber = (index + 1)
            .toString()
            .padLeft(2, '0');

        return '$storagePath/p-$pageNumber.webp';
      },
    );
  }
}
