import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';

abstract class ExamPaperRepository {
  Future<List<ExamPaper>> getExamPaper1();
  Future<List<ExamPaper>> getExamPaper2();
}