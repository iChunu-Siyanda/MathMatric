import 'package:math_matric/features/curriculum/exams/data/datasource/local/exam_paper_local_data_source.dart';
import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_repository.dart';

class ExamPapersRepositoryImpl implements ExamPapersRepository {
  final ExamPaperLocalDataSource local;
  //final ExamPaperLocalStorageDataSource localDataSource;
  //final ExamPaperRemoteStorageDataSource remoteDataSource;
  
  ExamPapersRepositoryImpl(
    this.local,
    //this.localDataSource, 
    //this.remoteDataSource,
  );

  @override
  Future<List<ExamPaperEntity>> getAllExamPapers() async {
    final models = await local.getAllExamPapers();

    return models.map((m) => m.toEntity()).toList();
  }

  // Future<List<String>> getPaperPages({
  //   required String paperId,
  //   required String storagePath,
  //   required int pageCount,
  // }) async {
  //   final List<String> resolvedPaths = [];

  //   for (int i = 1; i <= pageCount; i++) {
  //     final fileName = 'p-${i.toString().padLeft(2, '0')}.webp';
      
  //     // 1. Check if the page exists in device storage
  //     final localPath = await localDataSource.getPagePath(
  //       paperId: paperId,
  //       fileName: fileName,
  //     );

  //     if (localPath != null) {
  //       resolvedPaths.add(localPath);
  //     } else {
  //       // 2. Download from Firebase Storage if missing
  //       final bytes = await remoteDataSource.downloadPage(
  //         storagePath: storagePath,
  //         fileName: fileName,
  //       );

  //       // 3. Persist to device storage via path_provider
  //       final savedPath = await localDataSource.savePage(
  //         paperId: paperId,
  //         fileName: fileName,
  //         data: bytes,
  //       );

  //       resolvedPaths.add(savedPath);
  //     }
  //   }

  //   return resolvedPaths;
  // }

  @override
  Future<ExamPaperEntity?> getExamPaper(
    String paperId,
  ) async {
    final model = await local.getExamPaper(paperId);

    return model?.toEntity();
  }

  @override
  Future<List<ExamPaperEntity>> getExamPapers({
    required String subjectId,
    required String paperType,
    required String session,
    int? year,
  }) async {
    final models = await local.getExamPapers(
      subjectId,
      paperType,
      session,
      year,
    );

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getExamPapersByType(
    String paperType,
  ) async {
    final models = await local.getExamPapersByType(paperType);

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getExamPapersByYear(
    int year,
  ) async {
    final models = await local.getExamPapersByYear(year);

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getExamPapersBySession(
    String session,
  ) async {
    final models = await local.getExamPapersBySession(session);

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getNationalExamPapers() async {
    final models = await local.getNationalExamPapers();

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getProvincialExamPapers(
    String province,
  ) async {
    final models = await local.getProvincialExamPapers(province);

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getDownloadedExamPapers() async {
    final models = await local.getDownloadedExamPapers();

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateDownloadedStatus({
    required String paperId,
    required bool downloaded,
  }) {
    return local.updateDownloadedStatus(
      paperId: paperId,
      downloaded: downloaded,
    );
  }

  @override
  Future<List<ExamPaperEntity>> getMemoPapers() async {
    final models = await local.getMemoPapers();

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getChildPapers(
    String parentPaperId,
  ) async {
    final models = await local.getChildPapers(parentPaperId);

    return models.map((m) => m.toEntity()).toList();
  }
}
