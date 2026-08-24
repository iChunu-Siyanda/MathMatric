class ClassNoteEntity {
  final String id;
  final String topicId;
  final String title;
  final String content;
  final int order;

  const ClassNoteEntity({
    required this.id,
    required this.topicId,
    required this.title,
    required this.content,
    required this.order,
  });
}
