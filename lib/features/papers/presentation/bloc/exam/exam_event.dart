import 'package:math_matric/features/papers/domain/entities/paper_type.dart';

abstract class ExamEvent {
  const ExamEvent();
}

//Exam viewer/TopicsSliverList opens this fires up
class ExamPaperRequested extends ExamEvent{
  final PaperType paperType;

  const ExamPaperRequested(this.paperType);
}

//Reset when leaving page.
class ResetExamPapers extends ExamEvent{
  const ResetExamPapers();
}