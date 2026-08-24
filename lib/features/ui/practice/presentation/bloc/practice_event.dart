abstract class PracticeEvent {
  const PracticeEvent();
}

class PracticeLoadTopic extends PracticeEvent {
  final String topicId;

  PracticeLoadTopic(this.topicId);
}

class CompleteLevel extends PracticeEvent {
  final String topicId;
  final String levelId;
  final int xpEarned;

  CompleteLevel({
    required this.topicId,
    required this.levelId,
    required this.xpEarned,
  });
}

class RefreshTopic extends PracticeEvent {
  final String topicId;

  RefreshTopic(this.topicId);
}
