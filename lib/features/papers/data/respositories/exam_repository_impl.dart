import 'package:math_matric/features/papers/data/local/exam_paper_data.dart';
import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/domain/respositories/exam_paper_respository.dart';

class ExamPaperRepositoryImpl implements ExamPaperRepository {
  final ExamPaperData localExamDataSource;

  ExamPaperRepositoryImpl(this.localExamDataSource);

  @override
  Future<Map<ExamSession, Map<String,List<ExamPaper>>>> getExamPaper1() async {
    return ExamPaperData().getExamItems(PaperType.paper1);
  }
  
  @override
  Future<Map<ExamSession, Map<String,List<ExamPaper>>>> getExamPaper2() async{
    return ExamPaperData().getExamItems(PaperType.paper2);
  }
}
