import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/domain/respositories/papers_respository.dart';

class GetPaperData {
  final PapersRepository repository;

  GetPaperData(this.repository);

  Future<ExamPaper> call(PaperType type) {
    if (type == PaperType.paper1) {
      return repository.getPaper1();
    } else {
      return repository.getPaper2();
    }
  }
}
