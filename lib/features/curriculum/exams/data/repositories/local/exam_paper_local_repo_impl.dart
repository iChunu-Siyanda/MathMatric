import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/curriculum/exam_papers_queries.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/local/exam_paper_local_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/models/exam_paper_model.dart';

class ExamPaperLocalDataSourceImpl implements ExamPaperLocalDataSource {
  final AppDatabase db;
  ExamPaperLocalDataSourceImpl(this.db);

  @override
  Future<List<ExamPaperModel>> getAllExamPapers() async {
    final rows = await db.getAllExamPapers();
    return rows.map((r) => ExamPaperModel.fromDrift(r)).toList();
  }

  @override
  Future<ExamPaperModel?> getExamPaper(
    String paperId,
  ) async {
    final row = await db.getExamPaper(paperId);

    if (row == null) return null;

    return ExamPaperModel.fromDrift(row);
  }

  @override
  Future<List<ExamPaperModel>> getExamPapersByType(
    String paperType,
  ) async {
    final rows = await db.getExamPapersByType(paperType);

    return rows.map(ExamPaperModel.fromDrift).toList();
  }

  @override
  Future<List<ExamPaperModel>> getExamPapersByYear(
    int year,
  ) async {
    final rows = await db.getExamPapersByYear(year);

    return rows.map(ExamPaperModel.fromDrift).toList();
  }

  @override
  Future<List<ExamPaperModel>> getExamPapersBySession(
    String session,
  ) async {
    final rows = await db.getExamPapersBySession(session);

    return rows.map(ExamPaperModel.fromDrift).toList();
  }

  @override
  Future<List<ExamPaperModel>> getNationalExamPapers() async {
    final rows = await db.getNationalExamPapers();

    return rows.map(ExamPaperModel.fromDrift).toList();
  }

  @override
  Future<List<ExamPaperModel>> getProvincialExamPapers(
    String province,
  ) async {
    final rows = await db.getProvincialExamPapers(province);

    return rows.map(ExamPaperModel.fromDrift).toList();
  }

  @override
  Future<List<ExamPaperModel>> getDownloadedExamPapers() async {
    final rows = await db.getDownloadedExamPapers();

    return rows.map(ExamPaperModel.fromDrift).toList();
  }

  @override
  Future<List<ExamPaperModel>> getMemoPapers() async {
    final rows = await db.getMemoPapers();

    return rows.map(ExamPaperModel.fromDrift).toList();
  }

  @override
  Future<List<ExamPaperModel>> getChildPapers(
    String parentPaperId,
  ) async {
    final rows = await db.getChildPapers(parentPaperId);

    return rows.map(ExamPaperModel.fromDrift).toList();
  }

  @override
  Future<void> saveExamPapers(
    List<ExamPaperModel> papers,
  ) async {
    await db.insertExamPapers(
      papers.map((e) => e.toCompanion()).toList(),
    );
  }

  @override
  Future<void> updateDownloadedStatus({
    required String paperId,
    required bool downloaded,
  }) async {
    await db.updateDownloadedStatus(
      paperId: paperId,
      downloaded: downloaded,
    );
  }

  @override
  Future<void> clearExamPapers() async {
    await db.clearExamPapers();
  }

  @override
  Future<int> deleteExamPaper(
    String paperId,
  ) {
    return db.deleteExamPaper(paperId);
  }

  @override
  Future<List<ExamPaperModel>> getExamPapers({
    required String subjectId, 
    required String paperType, 
    required String session,
    int? year,
  }) async {
    final rows = await db.getExamPapers(subjectId: subjectId, session: session, paperType: paperType);

    return rows.map(ExamPaperModel.fromDrift).toList();
  }
}
