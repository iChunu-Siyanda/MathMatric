import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_repository.dart';
import 'package:math_matric/features/papers/exam/domain/usercases/get_exam_paper_data.dart';

class MockGetExamPapersUseCase implements GetExamPapersUseCase {
  List<ExamPaperEntity> papers = [];

  String? receivedSubjectId;
  String? receivedPaperType;
  String? receivedSession;
  int? receivedYear;

  @override
  Future<List<ExamPaperEntity>> call({
    required String subjectId,
    required String paperType,
    required String session,
    int? year,
  }) async {
    receivedSubjectId = subjectId;
    receivedPaperType = paperType;
    receivedSession = session;
    receivedYear = year;

    return papers;
  }

  @override
  ExamPapersRepository get repository => throw UnimplementedError();
}
