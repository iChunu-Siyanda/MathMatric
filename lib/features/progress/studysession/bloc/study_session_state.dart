import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';

sealed class StudySessionState {
  const StudySessionState();
}

final class StudySessionInitial extends StudySessionState {
  const StudySessionInitial();
}

final class StudySessionLoading extends StudySessionState {
  const StudySessionLoading();
}

final class StudySessionActive extends StudySessionState {
  final StudySessionEntity session;

  const StudySessionActive({
    required this.session,
  });
}

final class StudySessionCompletedState extends StudySessionState {
  final StudySessionEntity session;

  const StudySessionCompletedState({
    required this.session,
  });
}

final class StudySessionError extends StudySessionState {
  final String message;

  const StudySessionError(this.message);
}
