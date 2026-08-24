import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';

extension ClassNotesQueries on AppDatabase {
  Future<List<ClassNote>> getAllClassNotes() {
    return (select(classNotes)
          ..orderBy([
            (n) => OrderingTerm.asc(n.order),
          ]))
        .get();
  }

  Future<ClassNote?> getClassNote(String noteId) {
    return (select(classNotes)
          ..where((n) => n.id.equals(noteId)))
        .getSingleOrNull();
  }

  Future<List<ClassNote>> getClassNotesByTopic(
    String topicId,
  ) {
    return (select(classNotes)
          ..where((n) => n.topicId.equals(topicId))
          ..orderBy([
            (n) => OrderingTerm.asc(n.order),
          ]))
        .get();
  }

  Future<void> insertClassNotes(
    List<ClassNotesCompanion> notes,
  ) async {
    await batch((batch) {
      batch.insertAll(
        classNotes,
        notes,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<int> clearClassNotes() {
    return delete(classNotes).go();
  }

  Future<int> deleteClassNote(String noteId) {
    return (delete(classNotes)
          ..where((n) => n.id.equals(noteId)))
        .go();
}
}