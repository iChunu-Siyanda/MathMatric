import 'package:math_matric/features/curriculum/notes/domain/entites/class_note_entity.dart';
import 'package:math_matric/features/curriculum/notes/domain/repositories/class_note_repository.dart';

class GetClassNotesUseCase {
  final ClassNoteRepository repository;

  GetClassNotesUseCase(this.repository);

  Future<List<ClassNoteEntity>> call() {
    return repository.getAllClassNotes();
  }
}
