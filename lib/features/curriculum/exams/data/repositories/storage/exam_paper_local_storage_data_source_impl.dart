import 'dart:io';
import 'dart:typed_data';

import 'package:math_matric/features/curriculum/exams/data/datasource/storage/local/exam_paper_local_storage_data_source.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ExamPaperLocalStorageDataSourceImpl implements ExamPaperLocalStorageDataSource {
  
  Future<Directory> _getPaperDirectory(
    String paperId,
  ) async {
    final directory = await getApplicationSupportDirectory();

    final paperDirectory = Directory(p.join(
        directory.path,
        'exam_papers',
        paperId,
      ),
    );

    if (!await paperDirectory.exists()) {
      await paperDirectory.create(recursive: true,);
    }

    return paperDirectory;
  }

  @override
  Future<String> savePage({
    required String paperId,
    required String fileName,
    required Uint8List data,
  }) async {
    final directory = await _getPaperDirectory(paperId,);

    final file = File(p.join(
        directory.path,
        fileName,
      ),
    );

    await file.writeAsBytes(data,flush: true,);

    return file.path;
  }

  @override
  Future<String?> getPagePath({
    required String paperId,
    required String fileName,
  }) async {
    final directory = await _getPaperDirectory(paperId,);

    final file = File(p.join(
        directory.path,
        fileName,
      ),
    );

    if (!await file.exists()) {return null;}

    return file.path;
  }

  @override
  Future<bool> pageExists({
    required String paperId,
    required String fileName,
  }) async {
    final directory = await _getPaperDirectory(paperId,);

    final file = File(p.join(
        directory.path,
        fileName,
      ),
    );

    return file.exists();
  }

  @override
  Future<void> deletePaper(
    String paperId,
  ) async {
    final directory = await getApplicationSupportDirectory();

    final paperDirectory = Directory(p.join(
        directory.path,
        'exam_papers',
        paperId,
      ),
    );

    if (await paperDirectory.exists()) {
      await paperDirectory.delete(recursive: true,);
    }
  }
}
