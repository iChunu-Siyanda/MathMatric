import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';

abstract class PapersRepository {
  Future<ExamPaper> getPaper1();
  Future<ExamPaper> getPaper2();
}
