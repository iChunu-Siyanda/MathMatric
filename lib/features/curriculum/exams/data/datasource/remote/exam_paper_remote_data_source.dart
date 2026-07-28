import 'package:math_matric/features/curriculum/exams/data/models/exam_paper_model.dart';

abstract class ExamPaperRemoteDataSource {
  Future<List<ExamPaperModel>> getAllExamPapers();
}
