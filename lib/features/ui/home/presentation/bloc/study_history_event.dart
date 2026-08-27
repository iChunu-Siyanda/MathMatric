import 'package:math_matric/features/ui/home/domain/entities/last_studied.dart';

abstract class StudyHistoryEvent {}

class TopicAccessed extends StudyHistoryEvent {
  final LastStudied topic;
  TopicAccessed(this.topic);
}

class RemoveTopicFromHistory extends StudyHistoryEvent {
  final String title;
  RemoveTopicFromHistory(this.title);
}

class ClearStudyHistory extends StudyHistoryEvent {}
