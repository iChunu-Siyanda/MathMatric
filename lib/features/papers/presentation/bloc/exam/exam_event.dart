import 'package:math_matric/features/papers/domain/entities/paper_type.dart';

abstract class ExamEvent {
  const ExamEvent();
}

class ExamPaperRequested extends ExamEvent {
  final PaperType paperType;

  const ExamPaperRequested(this.paperType);
}

//specific exam (Paper + Memo tabs)
class ExamPaperFocusRequested extends ExamEvent {
  final String paperId;

  const ExamPaperFocusRequested(this.paperId);
}

// Reset when leaving page
class ResetExamPapers extends ExamEvent {
  const ResetExamPapers();
}
