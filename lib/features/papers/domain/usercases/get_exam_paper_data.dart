import 'package:math_matric/features/papers/data/local/exam_paper_data.dart';
import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/domain/respositories/exam_paper_respository.dart';

class GetExamPaperData {
  final ExamPaperRepository repository;

  GetExamPaperData(this.repository);

  Future<Map<ExamSession, List<ExamPaper>>> call(PaperType type){
    if(type == PaperType.paper1){
      return repository.getExamPaper1();
    } else {
      return repository.getExamPaper2();
    }
  }
}
