import 'package:bloc/bloc.dart';
import 'package:math_matric/features/papers/domain/usercases/get_exam_paper_data.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_event.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final GetExamPaperData getExamPaperData;

  ExamBloc(this.getExamPaperData) : super(const ExamPaperInitial()) {
    on<ExamPaperRequested>(_onExamPaperRequested);
    on<ResetExamPapers>(_onResetExamPapers as EventHandler<ResetExamPapers, ExamState>);
  }

  Future<void> _onExamPaperRequested(
    ExamPaperRequested event,
    Emitter<ExamState> emit
  ) async {
    emit(const ExamPaperLoading());

    try {
      final examPaper = await getExamPaperData(event.paperType);
      emit(ExamPaperLoaded(examPaper));
    } catch (e) {
      emit(ExamPaperError('Exam Paper failed to load. Error: $e'));
    }
  }

  Future<void> _onResetExamPapers(
    ExamPaperRequested event,
    Emitter<ExamState> emit
  ) async {
    emit(const ExamPaperInitial());
  }
}
