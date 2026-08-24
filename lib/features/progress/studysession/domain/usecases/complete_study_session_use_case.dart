import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';

class CompleteStudySessionUseCase {
  final StudySessionRepository repository;

  CompleteStudySessionUseCase(this.repository);

  Future<void> call({
    required String sessionId,
  }) {
    return repository.completeSession(
      sessionId: sessionId,
    );
  }
}
