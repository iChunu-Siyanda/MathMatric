import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/domain/usercases/get_paper_data.dart';
import 'package:math_matric/features/papers/presentation/bloc/paper/papers_event.dart';
import 'package:math_matric/features/papers/presentation/bloc/paper/papers_state.dart';

class PapersBloc extends Bloc<PapersEvent, PapersState> {
  final GetPaperData getPaperData;

  PapersBloc(this.getPaperData) : super(const PapersInitial()) {
    on<LoadPaperRequested>(_onLoadPaperRequested);
    on<ResetPapers>(_onResetPapers);
  }

  Future<void> _onLoadPaperRequested(
    LoadPaperRequested event,
    Emitter<PapersState> emit,
  ) async {
    emit(const PapersLoading());

    try {
      final paper = await getPaperData(event.paperType);
      emit(PapersLoaded(paper as PaperItem));
    } catch (e) {
      emit(const PapersError('Failed to load paper'));
    }
  }

  void _onResetPapers(
    ResetPapers event,
    Emitter<PapersState> emit,
  ) {
    emit(const PapersInitial());
  }
}

// Bloc only coordinates state changes. Bloc does not know if data is local or Firebase, and Bloc does not know about UI widgets.
// Bloc = traffic controller
// It doesn’t own data
// It doesn’t draw UI
// It just decides what state comes next

