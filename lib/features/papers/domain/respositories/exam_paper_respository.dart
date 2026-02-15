import 'package:math_matric/features/papers/data/local/exam_paper_data.dart';
import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';

abstract class ExamPaperRepository {
  Future<Map<ExamSession, Map<String,List<ExamPaper>>>> getExamPaper1();
  Future<Map<ExamSession, Map<String,List<ExamPaper>>>> getExamPaper2();
}