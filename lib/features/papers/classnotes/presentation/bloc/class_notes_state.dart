import 'package:math_matric/features/curriculum/notes/domain/entites/class_note_entity.dart';

sealed class ClassNotesState {
  const ClassNotesState();
}

final class ClassNotesInitial extends ClassNotesState {
  const ClassNotesInitial();
}

final class ClassNotesLoading extends ClassNotesState {
  const ClassNotesLoading();
}

final class ClassNotesLoaded extends ClassNotesState {
  final List<ClassNoteEntity> notes;

  const ClassNotesLoaded({
    required this.notes,
  });
}

final class ClassNotesError extends ClassNotesState {
  final String message;

  const ClassNotesError(this.message);
}
