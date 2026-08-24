import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/ui/classnotes/domain/usecases/get_class_note_by_topic_use_case.dart';
import 'package:math_matric/features/ui/classnotes/domain/usecases/get_class_note_use_case.dart';

import 'class_notes_event.dart';
import 'class_notes_state.dart';

class ClassNotesBloc extends Bloc<ClassNotesEvent, ClassNotesState> {
  final GetClassNotesUseCase getClassNotes;
  final GetClassNotesByTopicUseCase getClassNotesByTopic;

  ClassNotesBloc({
    required this.getClassNotes,
    required this.getClassNotesByTopic,
  }) : super(const ClassNotesInitial()) {
    on<ClassNotesRequested>(_onClassNotesRequested);
    on<ClassNotesByTopicRequested>(_onClassNotesByTopicRequested);
    on<ResetClassNotes>(_onResetClassNotes);
  }

  Future<void> _onClassNotesRequested(
    ClassNotesRequested event,
    Emitter<ClassNotesState> emit,
  ) async {
    emit(const ClassNotesLoading());

    try {
      final notes = await getClassNotes();

      emit(ClassNotesLoaded(notes: notes,),);
    } catch (e) {
      emit(ClassNotesError('Failed to load class notes: $e',),);
    }
  }

  Future<void> _onClassNotesByTopicRequested(
    ClassNotesByTopicRequested event,
    Emitter<ClassNotesState> emit,
  ) async {
    emit(const ClassNotesLoading());

    try {
      final notes = await getClassNotesByTopic(topicId: event.topicId,);

      emit(ClassNotesLoaded(notes: notes,),);
    } catch (e) {
      emit(ClassNotesError('Failed to load class notes: $e',),);
    }
  }

  void _onResetClassNotes(
    ResetClassNotes event,
    Emitter<ClassNotesState> emit,
  ) {
    emit(const ClassNotesInitial());
  }
}
