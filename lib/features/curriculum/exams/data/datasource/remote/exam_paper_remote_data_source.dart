import 'package:math_matric/features/curriculum/exams/data/models/exam_paper_model.dart';

abstract class ExamPaperRemoteDataSource {
  Future<List<ExamPaperModel>> getAllExamPapers();

  Future<ExamPaperModel?> getExamPaper(
    String paperId,
  );

  Future<List<ExamPaperModel>> getExamPapersByType(
    String paperType,
  );

  Future<List<ExamPaperModel>> getExamPapersByYear(
    int year,
  );

  Future<List<ExamPaperModel>> getExamPapersBySession(
    String session,
  );

  Future<List<ExamPaperModel>> getNationalExamPapers();

  Future<List<ExamPaperModel>> getProvincialExamPapers(
    String province,
  );

  Future<List<ExamPaperModel>> getMemoPapers();

  Future<List<ExamPaperModel>> getChildPapers(
    String parentPaperId,
  );
}
