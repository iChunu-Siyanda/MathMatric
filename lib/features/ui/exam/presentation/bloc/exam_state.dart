import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';

sealed class ExamState {
  const ExamState();
}

final class ExamInitial extends ExamState {
  const ExamInitial();
}

final class ExamLoading extends ExamState {
  const ExamLoading();
}

final class ExamPaperListLoaded extends ExamState {
  final List<ExamPaperEntity> papers;

  const ExamPaperListLoaded({
    required this.papers,
  });
}

final class ExamPaperLoaded extends ExamState {
  final ExamPaperEntity paper;
  final ExamPaperEntity? memo;

  const ExamPaperLoaded({
    required this.paper,
    this.memo,
  });
}

final class ExamPaperPagesLoaded extends ExamState {
  final ExamPaperEntity paper;
  final List<String> pages;

  const ExamPaperPagesLoaded({
    required this.paper,
    required this.pages,
  });
}

final class ExamPaperDownloading extends ExamState {
  final ExamPaperEntity paper;

  const ExamPaperDownloading({
    required this.paper,
  });
}



final class ExamError extends ExamState {
  final String message;

  const ExamError(this.message);
}
