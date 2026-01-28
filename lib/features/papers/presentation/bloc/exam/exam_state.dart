import 'package:math_matric/features/papers/data/local/exam_paper_data.dart';
import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';

abstract class ExamState {
  const ExamState();
}

//Initial state
class ExamPaperInitial extends ExamState{
  const ExamPaperInitial();
}

//Loading assets or data
class ExamPaperLoading extends ExamState{
  const ExamPaperLoading();
}

//Exam papers are loaded
class ExamPaperLoaded extends ExamState{
  final Map<ExamSession, List<ExamPaper>> examPapers;

  const ExamPaperLoaded(this.examPapers);
}

//Error state missing any data
class ExamPaperError extends ExamState {
  final String message;

  const ExamPaperError(this.message);
}