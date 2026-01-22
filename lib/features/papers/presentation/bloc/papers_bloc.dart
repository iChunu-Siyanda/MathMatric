import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/domain/usercases/get_paper_data.dart';

class PapersBloc extends Bloc<PapersEvent, PapersState> {
  final GetPaperData getPaperData;

  PapersBloc(this.getPaperData) : super(PapersInitial()) {
    on<LoadPaperRequested>(_onLoadPaper);
  }

  Future<void> _onLoadPaper(
    LoadPaperRequested event,
    Emitter<PapersState> emit,
  ) async {
    emit(PapersLoading());

    final paper = await getPaperData(event.paperType);

    emit(PapersLoaded(paper));
  }
}
