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

final class ExamPapersByTypeRequested extends ExamEvent {
  final String paperType;

  const ExamPapersByTypeRequested({
    required this.paperType,
  });
}

final class ExamPapersBySessionRequested extends ExamEvent {
  final String session;

  const ExamPapersBySessionRequested({
    required this.session,
  });
}

final class ExamPaperRequested extends ExamEvent {
  final String paperId;

  const ExamPaperRequested({
    required this.paperId,
  });
}

final class ExamPaperDownloadStatusChanged extends ExamEvent {
  final String paperId;
  final bool downloaded;

  const ExamPaperDownloadStatusChanged({
    required this.paperId,
    required this.downloaded,
  });
}

final class ResetExamPapers extends ExamEvent {
  const ResetExamPapers();
}
