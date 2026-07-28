import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/tables/exam_papers.dart';

extension ExamPapersQueries on AppDatabase {
  Future<List<ExamPaper>> getAllExamPapers() {
    return (select(examPapers)
          ..orderBy([
            (p) => OrderingTerm.desc(p.year),
            (p) => OrderingTerm.asc(p.title),
          ]))
        .get();
  }

  Future<ExamPaper?> getExamPaper(String paperId) {
    return (select(examPapers)
          ..where((p) => p.id.equals(paperId)))
        .getSingleOrNull();
  }

  Future<List<ExamPaper>> getExamPapersByType(
    String paperType,
  ) {
    return (select(examPapers)
          ..where((p) => p.paperType.equals(paperType))
          ..orderBy([
            (p) => OrderingTerm.desc(p.year),
          ]))
        .get();
  }

  Future<List<ExamPaper>> getExamPapersByYear(
    int year,
  ) {
    return (select(examPapers)
          ..where((p) => p.year.equals(year))
          ..orderBy([
            (p) => OrderingTerm.asc(p.title),
          ]))
        .get();
  }

  Future<List<ExamPaper>> getExamPapersBySession(
    String session,
  ) {
    return (select(examPapers)
          ..where((p) => p.session.equals(session))
          ..orderBy([
            (p) => OrderingTerm.desc(p.year),
          ]))
        .get();
  }

  Future<List<ExamPaper>> getNationalExamPapers() {
    return (select(examPapers)
          ..where((p) => p.isNational.equals(true))
          ..orderBy([
            (p) => OrderingTerm.desc(p.year),
          ]))
        .get();
  }

  Future<List<ExamPaper>> getProvincialExamPapers(
    String province,
  ) {
    return (select(examPapers)
          ..where((p) => p.province.equals(province))
          ..orderBy([
            (p) => OrderingTerm.desc(p.year),
          ]))
        .get();
  }

  Future<List<ExamPaper>> getDownloadedExamPapers() {
    return (select(examPapers)
          ..where((p) => p.downloaded.equals(true))
          ..orderBy([
            (p) => OrderingTerm.desc(p.year),
          ]))
        .get();
  }

  Future<List<ExamPaper>> getMemoPapers() {
    return (select(examPapers)
          ..where((p) => p.isMemo.equals(true))
          ..orderBy([
            (p) => OrderingTerm.desc(p.year),
          ]))
        .get();
  }

  Future<List<ExamPaper>> getChildPapers(
    String parentPaperId,
  ) {
    return (select(examPapers)
          ..where((p) => p.parentPaperId.equals(parentPaperId)))
        .get();
  }

  Future<int> getExamPaperCount() async {
    final query = selectOnly(examPapers)
      ..addColumns([examPapers.id.count()]);

    final result = await query.getSingle();

    return result.read(examPapers.id.count()) ?? 0;
  }

  Future<int> insertExamPaper(
    ExamPapersCompanion paper,
  ) {
    return into(examPapers).insert(paper);
  }

  Future<void> insertExamPapers(
    List<ExamPapersCompanion> papers,
  ) {
    return batch((batch) {
      batch.insertAll(examPapers, papers);
    });
  }

  Future<bool> updateExamPaper(
    ExamPaper paper,
  ) {
    return update(examPapers).replace(paper);
  }

  Future<int> deleteExamPaper(
    String paperId,
  ) {
    return (delete(examPapers)
          ..where((p) => p.id.equals(paperId)))
        .go();
  }

  Future<int> clearExamPapers() {
    return delete(examPapers).go();
  }

  Future<bool> hasExamPapers() async {
    final papers = await getAllExamPapers();

    return papers.isNotEmpty;
  }
}
