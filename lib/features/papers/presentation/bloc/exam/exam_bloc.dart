import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/data/local/exam_paper_data.dart';
import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/domain/usercases/get_exam_paper_data.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_event.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final GetExamPaperData getExamPaperData;

  // Cache to reuse loaded papers
  Map<ExamSession, Map<String, List<ExamPaper>>>? _cachedExamPapers;

  ExamBloc(this.getExamPaperData) : super(const ExamPaperInitial()) {
    //on<ExamPaperRequested>(_onExamPaperRequested);
    on<ExamPaperFocusRequested>(_onExamPaperFocusRequested);
    on<ResetExamPapers>(_onResetExamPapers);
  }

  // Load ALL papers (browse mode)
  // Future<void> _onExamPaperRequested(
  //   ExamPaperRequested event,
  //   Emitter<ExamState> emit,
  // ) async {
  //   emit(const ExamPaperLoading());

  //   try {
  //     final examPapers = await getExamPaperData(event.paperType);
  //     _cachedExamPapers = examPapers;
  //     emit(ExamPaperLoaded(examPapers));
  //   } catch (e) {
  //     emit(ExamPaperError('Exam Paper failed to load. Error: $e'));
  //   }
  // }

  //Specific papers
  Future<void> _onExamPaperFocusRequested(
    ExamPaperFocusRequested event,
    Emitter<ExamState> emit,
  ) async {
    if (state is ExamPaperFocusLoaded) {
      final currentState = state as ExamPaperFocusLoaded;

      if (currentState.paper.id == event.paperId) {
        return;//do nothing since it is already loaded
      }
    }

    emit(const ExamPaperLoading());

    final examPapers = await getExamPaperData(event.paperType);
    _cachedExamPapers = examPapers;

    if (_cachedExamPapers == null) {
      emit(const ExamPaperError('No exam papers loaded'));
      return;
    }

    try {
      final allPapers = _cachedExamPapers?.values
              .expand((innerMap) => innerMap
                  .values) // Flattens Map<String, List<ExamPaper>> to Iterable<List<ExamPaper>>
              .expand((list) =>
                  list) // Flattens Iterable<List<ExamPaper>> to Iterable<ExamPaper>
              .toList() ??
          [];

      debugPrint("Event Paper ID: ${event.paperId}");
      debugPrint("Available IDs: ${allPapers.map((e) => e.id).toList()}");

      final paper = allPapers.firstWhere(
        (p) => p.id == event.paperId && !p.isMemo,
        orElse: () => throw Exception("Paper not found: ${event.paperId}"),
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
    } catch (e) {
      emit(ExamPaperError('Exam Paper failed to load. Error: $e'));
    }
  }

  void _onResetExamPapers(
    ResetExamPapers event,
    Emitter<ExamState> emit,
  ) {
    _cachedExamPapers = null;
    emit(const ExamPaperInitial());
  }
}
