import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/curriculum/class_notes_queries.dart';
import 'package:math_matric/features/curriculum/notes/data/datasource/class_note_local_data_source.dart';
import 'package:math_matric/features/curriculum/notes/data/models/class_note_model.dart';

class ClassNoteLocalDataSourceImpl implements ClassNoteLocalDataSource {
  final AppDatabase db;

  ClassNoteLocalDataSourceImpl(this.db);

  @override
  Future<List<ClassNoteModel>> getAllClassNotes() async {
    final rows = await db.getAllClassNotes();

    return rows
        .map(ClassNoteModel.fromDrift)
        .toList();
  }

  @override
  Future<ClassNoteModel?> getClassNote(
    String noteId,
  ) async {
    final row = await db.getClassNote(noteId);

    if (row == null) return null;

    return ClassNoteModel.fromDrift(row);
  }

  @override
  Future<List<ClassNoteModel>> getClassNotesByTopic(
    String topicId,
  ) async {
    final rows = await db.getClassNotesByTopic(topicId);

    return rows
        .map(ClassNoteModel.fromDrift)
        .toList();
  }

  @override
  Future<void> saveClassNotes(
    List<ClassNoteModel> notes,
  ) async {
    await db.insertClassNotes(
      notes
          .map((note) => note.toCompanion())
          .toList(),
    );
  }

  @override
  Future<void> clearClassNotes() async {
    await db.clearClassNotes();
  }

  @override
  Future<int> deleteClassNote(
    String noteId,
  ) {
    return db.deleteClassNote(noteId);
  }
}
