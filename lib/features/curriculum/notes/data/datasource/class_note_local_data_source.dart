import 'package:math_matric/features/curriculum/notes/data/models/class_note_model.dart';

abstract class ClassNoteLocalDataSource {
  Future<List<ClassNoteModel>> getAllClassNotes();

  Future<ClassNoteModel?> getClassNote(
    String noteId,
  );

  Future<List<ClassNoteModel>> getClassNotesByTopic(
    String topicId,
  );

  Future<void> saveClassNotes(
    List<ClassNoteModel> notes,
  );

  Future<void> clearClassNotes();

  Future<int> deleteClassNote(
    String noteId,
  );
}
