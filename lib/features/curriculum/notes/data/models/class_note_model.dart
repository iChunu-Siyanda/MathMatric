import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/curriculum/notes/domain/entites/class_note_entity.dart';

class ClassNoteModel extends ClassNoteEntity {
  final int version;

  const ClassNoteModel({
    required super.id,
    required super.topicId,
    required super.title,
    required super.content,
    required super.order,
    required this.version,
  });

  factory ClassNoteModel.fromDrift(ClassNote note) {
    return ClassNoteModel(
      id: note.id,
      topicId: note.topicId,
      title: note.title,
      content: note.content,
      order: note.order,
      version: note.version,
    );
  }

  factory ClassNoteModel.fromEntity(
    ClassNoteEntity note, {
    required int version,
  }) {
    return ClassNoteModel(
      id: note.id,
      topicId: note.topicId,
      title: note.title,
      content: note.content,
      order: note.order,
      version: version,
    );
  }

  factory ClassNoteModel.fromFirestore(
    Map<String, dynamic> json,
  ) {
    return ClassNoteModel(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      order: json['order'] as int,
      version: json['version'] as int,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'topicId': topicId,
      'title': title,
      'content': content,
      'order': order,
      'version': version,
    };
  }

  ClassNoteEntity toEntity() {
    return ClassNoteEntity(
      id: id,
      topicId: topicId,
      title: title,
      content: content,
      order: order,
    );
  }

  ClassNotesCompanion toCompanion() {
    return ClassNotesCompanion.insert(
      id: id,
      topicId: topicId,
      title: title,
      content: content,
      order: order,
      version: version,
      updatedAt: DateTime.now(),
    );
  }
}
