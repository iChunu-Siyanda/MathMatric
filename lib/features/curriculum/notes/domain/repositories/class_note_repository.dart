import 'package:math_matric/features/curriculum/notes/domain/entites/class_note_entity.dart';

abstract class ClassNoteRepository {
  Future<List<ClassNoteEntity>> getAllClassNotes();

  Future<ClassNoteEntity?> getClassNote(
    String noteId,
  );

  Future<List<ClassNoteEntity>> getClassNotesByTopic(
    String topicId,
  );
}
