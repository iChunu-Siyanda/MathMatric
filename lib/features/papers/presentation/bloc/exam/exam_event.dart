import 'package:math_matric/features/papers/data/local/exam_paper_data.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';

abstract class ExamEvent {
  const ExamEvent();
}

class ExamPaperRequested extends ExamEvent {
  final PaperType paperType;
  final ExamSession session;
  final int? year;

  const ExamPaperRequested(this.paperType, this.session, this.year);
}

//specific exam (Paper + Memo tabs)
// class ExamPaperFocusRequested extends ExamEvent {
//   final String paperId;
//   final PaperType paperType;

//   const ExamPaperFocusRequested(this.paperId,this.paperType);
// }

// Reset when leaving page
class ResetExamPapers extends ExamEvent {
  const ResetExamPapers();
}
