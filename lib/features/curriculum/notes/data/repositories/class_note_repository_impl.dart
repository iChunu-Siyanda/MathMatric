import 'package:math_matric/features/curriculum/notes/data/datasource/class_note_local_data_source.dart';
import 'package:math_matric/features/curriculum/notes/domain/entites/class_note_entity.dart';
import 'package:math_matric/features/curriculum/notes/domain/repositories/class_note_repository.dart';

class ClassNoteRepositoryImpl implements ClassNoteRepository {
  final ClassNoteLocalDataSource local;
  ClassNoteRepositoryImpl(this.local);

  @override
  Future<List<ClassNoteEntity>> getAllClassNotes() async {
    final models = await local.getAllClassNotes();

    return models
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<ClassNoteEntity?> getClassNote(
    String noteId,
  ) async {
    final model = await local.getClassNote(noteId);

    return model?.toEntity();
  }

  @override
  Future<List<ClassNoteEntity>> getClassNotesByTopic(
    String topicId,
  ) async {
    final models =
        await local.getClassNotesByTopic(topicId);

    return models
        .map((model) => model.toEntity())
        .toList();
  }
}
