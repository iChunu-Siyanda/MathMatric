import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/data/local/exam_paper_data.dart';
import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/domain/usercases/get_exam_paper_data.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_event.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final GetExamPaperData getExamPaperData;

  // Cache to reuse loaded papers
  Map<ExamSession, List<ExamPaper>>? _cachedExamPapers;

  ExamBloc(this.getExamPaperData) : super(const ExamPaperInitial()) {
    on<ExamPaperRequested>(_onExamPaperRequested);
    on<ExamPaperFocusRequested>(_onExamPaperFocusRequested);
    on<ResetExamPapers>(_onResetExamPapers);
  }

  // Load ALL papers (browse mode)
  Future<void> _onExamPaperRequested(
    ExamPaperRequested event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamPaperLoading());

    try {
      final examPapers = await getExamPaperData(event.paperType);
      _cachedExamPapers = examPapers;
      emit(ExamPaperLoaded(examPapers));
    } catch (e) {
      emit(ExamPaperError('Exam Paper failed to load. Error: $e'));
    }
  }

  //Specific papers
  void _onExamPaperFocusRequested(
    ExamPaperFocusRequested event,
    Emitter<ExamState> emit,
  ) {
    if (_cachedExamPapers == null) {
      emit(const ExamPaperError('No exam papers loaded'));
      return;
    }

    final allPapers = _cachedExamPapers!.values.expand((e) => e);

    final paper = allPapers.firstWhere(
      (p) => p.id == event.paperId && !p.isMemo,
    );

    final memo = allPapers.firstWhere(
      (p) => p.isMemo && p.parentPaperId == paper.id,
    );

    emit(
      ExamPaperFocusLoaded(
        paper: paper,
        memo: memo,
      ),
    );
  }

  void _onResetExamPapers(
    ResetExamPapers event,
    Emitter<ExamState> emit,
  ) {
    _cachedExamPapers = null;
    emit(const ExamPaperInitial());
  }
}
