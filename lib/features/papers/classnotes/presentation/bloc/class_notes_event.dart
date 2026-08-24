sealed class ClassNotesEvent {
  const ClassNotesEvent();
}

final class ClassNotesRequested extends ClassNotesEvent {
  const ClassNotesRequested();
}

final class ClassNotesByTopicRequested extends ClassNotesEvent {
  final String topicId;

  const ClassNotesByTopicRequested({
    required this.topicId,
  });
}

final class ResetClassNotes extends ClassNotesEvent {
  const ResetClassNotes();
}
