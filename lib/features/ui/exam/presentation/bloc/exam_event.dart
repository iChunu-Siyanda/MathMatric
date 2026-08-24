import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';

sealed class ExamEvent {
  const ExamEvent();
}

final class ExamPapersRequested extends ExamEvent {
  final String subjectId;
  final String paperType;
  final String session;
  final int? year;

  const ExamPapersRequested({
    required this.subjectId,
    required this.paperType,
    required this.session,
    this.year,
  });
}

final class ExamPaperPagesRequested extends ExamEvent {
  final ExamPaperEntity paper;

  const ExamPaperPagesRequested({
    required this.paper,
  });
}

final class ExamPaperRequested extends ExamEvent {
  final String paperId;

  const ExamPaperRequested({
    required this.paperId,
  });
}

final class ExamPaperDownloadRequested extends ExamEvent {
  final ExamPaperEntity paper;

  const ExamPaperDownloadRequested({
    required this.paper,
  });
}

final class ResetExamPapers extends ExamEvent {
  const ResetExamPapers();
}
