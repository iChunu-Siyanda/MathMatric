import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';

class UpdateStudySessionProgressUseCase {
  final StudySessionRepository repository;

  UpdateStudySessionProgressUseCase(this.repository);

  Future<void> call({
    required String sessionId,
    required int questionsAnswered,
    required int correctAnswers,
    required int earnedXP,
  }) {
    return repository.updateSessionProgress(
      sessionId: sessionId,
      questionsAnswered: questionsAnswered,
      correctAnswers: correctAnswers,
      earnedXP: earnedXP,
    );
  }
}
