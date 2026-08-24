import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/ui/exam/domain/entities/exam_session.dart';

abstract class ExamPaperRepository {
  Future<Map<ExamSession, Map<String,List<ExamPaperEntity>>>> getExamPaper1();
  Future<Map<ExamSession, Map<String,List<ExamPaperEntity>>>> getExamPaper2();
}