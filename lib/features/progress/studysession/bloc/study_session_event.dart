import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';

sealed class StudySessionEvent {
  const StudySessionEvent();
}

final class StudySessionStarted extends StudySessionEvent {
  final String topicId;
  final StudyActivity activity;

  const StudySessionStarted({
    required this.topicId,
    required this.activity,
  });
}

final class ActiveStudySessionRequested extends StudySessionEvent {
  const ActiveStudySessionRequested();
}

final class StudySessionProgressUpdated extends StudySessionEvent {
  final int questionsAnswered;
  final int correctAnswers;
  final int earnedXP;

  const StudySessionProgressUpdated({
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.earnedXP,
  });
}

final class StudySessionCompleted extends StudySessionEvent {
  const StudySessionCompleted();
}

final class StudySessionReset extends StudySessionEvent {
  const StudySessionReset();
}
