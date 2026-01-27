import 'package:math_matric/features/papers/data/local/exam_paper.dart';
import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';

class GetExamPaperData {
  final ExamPaperRepository repository;

  GetExamPaperData(this.repository);

  Future<List<ExamPaper>> call(PaperType type){
    if(type == PaperType.paper1){
      return repository.getExamPaper1();
    } else {
      return repository.getExamPaper2();
    }
  }
}
