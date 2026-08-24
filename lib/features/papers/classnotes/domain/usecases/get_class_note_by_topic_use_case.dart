import 'package:math_matric/features/curriculum/notes/domain/entites/class_note_entity.dart';
import 'package:math_matric/features/curriculum/notes/domain/repositories/class_note_repository.dart';

class GetClassNotesByTopicUseCase {
  final ClassNoteRepository repository;

  GetClassNotesByTopicUseCase(this.repository);

  Future<List<ClassNoteEntity>> call({
    required String topicId,
  }) {
    return repository.getClassNotesByTopic(topicId);
  }
}
