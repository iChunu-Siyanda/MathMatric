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

//Exam papers are loaded. Browsing state
class ExamPaperListLoaded extends ExamState {
  final Map<String, List<ExamPaper>> sections;

  const ExamPaperListLoaded(this.sections);
}

//Focus state, getting specific papers
// class ExamPaperFocusLoaded extends ExamState {
//   final ExamPaper paper;
//   final ExamPaper memo;
//   final List<ExamPaper> allPapers;  
//   final List<ExamPaper> allMemos;

//   ExamPaperFocusLoaded({
//     required this.paper,
//     required this.memo,
//     required this.allPapers,
//     required this.allMemos,
//   });
// }

//Error state missing any data
class ExamPaperError extends ExamState {
  final String message;

  const ExamPaperError(this.message);
}
