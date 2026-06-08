import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/domain/entities/exam_session.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/domain/repositories/exam_paper_respository.dart';

class GetExamPaperData {
  final ExamPaperRepository repository;

  GetExamPaperData(this.repository);

  Future<Map<ExamSession, Map<String,List<ExamPaper>>>> call(PaperType type){
    if(type == PaperType.paper1){
      return repository.getExamPaper1();
    } else {
      return repository.getExamPaper2();
    }
  }
}
