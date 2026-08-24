import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/ui/exam/domain/usercases/download_exam_paper_use_case.dart';
import 'package:math_matric/features/ui/exam/domain/usercases/get_exam_paper_data.dart';
import 'package:math_matric/features/ui/exam/domain/usercases/get_exam_paper_use_case.dart';
import 'package:math_matric/features/ui/exam/domain/usercases/open_exam_paper_use_case.dart';
import 'package:math_matric/features/ui/exam/presentation/bloc/exam_event.dart';
import 'package:math_matric/features/ui/exam/presentation/bloc/exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final GetExamPapersUseCase getExamPapers;
  final GetExamPaperUseCase getExamPaper;
  final OpenExamPaperUseCase openExamPaper;
  final DownloadExamPaperUseCase downloadExamPaper;

  ExamBloc({
    required this.getExamPapers,
    required this.getExamPaper, 
    required this.openExamPaper, 
    required this.downloadExamPaper,
  }) : super(const ExamInitial()) {
    on<ExamPapersRequested>(_onExamPapersRequested);
    on<ExamPaperRequested>(_onExamPaperRequested);
    on<ExamPaperPagesRequested>(_onExamPaperPagesRequested);
    on<ExamPaperDownloadRequested>(_onExamPaperDownloadRequested);
    on<ResetExamPapers>(_onResetExamPapers);
  }

  Future<void> _onExamPapersRequested(
    ExamPapersRequested event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamLoading());

    try {
      final papers = await getExamPapers(
        subjectId: event.subjectId, 
        paperType: event.paperType, 
        session: event.session,
        year: event.year,
      );

      emit(ExamPaperListLoaded(papers: papers));
    } catch (e) {
      emit(ExamError('Failed to load exam papers: $e',),);
    }
  }

  Future<void> _onExamPaperRequested(
    ExamPaperRequested event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamLoading());

    try {
      final paper = await getExamPaper(
        paperId: event.paperId,
      );

      if (paper == null) {
        emit(const ExamError('Exam paper not found.'),);
        return;
      }

      emit(ExamPaperLoaded(paper: paper,),);
    } catch (e) {
      emit(ExamError('Failed to load exam paper: $e',),);
    }
  }

  Future<void> _onExamPaperPagesRequested(
    ExamPaperPagesRequested event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamLoading());

    try {
      final pages = await openExamPaper(event.paper);

      emit(
        ExamPaperPagesLoaded(
          paper: event.paper,
          pages: pages,
        ),
      );
    } catch (e) {
      emit(
        ExamError(
          'Failed to open exam paper: $e',
        ),
      );
    }
  }

  Future<void> _onExamPaperDownloadRequested(
    ExamPaperDownloadRequested event,
    Emitter<ExamState> emit,
  ) async {
    emit(
      ExamPaperDownloading(
        paper: event.paper,
      ),
    );

    try {
      await downloadExamPaper(
        paper:event.paper,
      );

      emit(
        ExamPaperLoaded(
          paper: event.paper.copyWith(
            downloaded: true,
          ),
        ),
      );
    } catch (e) {
      emit(ExamError('Failed to download exam paper: $e',),);
    }
  }

  void _onResetExamPapers(
    ResetExamPapers event,
    Emitter<ExamState> emit,
  ) {
    emit(const ExamInitial());
  }

}
