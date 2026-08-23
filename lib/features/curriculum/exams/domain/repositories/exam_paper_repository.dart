import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';

abstract class ExamPapersRepository {
  Future<List<ExamPaperEntity>> getAllExamPapers();

  Future<List<ExamPaperEntity>> getExamPapers({
    required String subjectId,
    required String paperType,
    required String session,
    int? year,
  });

  Future<ExamPaperEntity?> getExamPaper(
    String paperId,
  );

  Future<List<ExamPaperEntity>> getExamPapersByType(
    String paperType,
  );

  Future<List<ExamPaperEntity>> getExamPapersByYear(
    int year,
  );

  Future<List<ExamPaperEntity>> getExamPapersBySession(
    String session,
  );

  Future<void> updateDownloadedStatus({
    required String paperId,
    required bool downloaded,
  });

  Future<List<ExamPaperEntity>> getNationalExamPapers();

  Future<List<ExamPaperEntity>> getProvincialExamPapers(
    String province,
  );

  Future<List<ExamPaperEntity>> getDownloadedExamPapers();

  Future<List<ExamPaperEntity>> getMemoPapers();

  Future<List<ExamPaperEntity>> getChildPapers(
    String parentPaperId,
  );
}
