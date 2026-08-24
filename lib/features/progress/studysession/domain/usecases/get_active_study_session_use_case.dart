import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';

class GetActiveStudySessionUseCase {
  final StudySessionRepository repository;

  GetActiveStudySessionUseCase(this.repository);

  Future<StudySessionEntity?> call() {
    return repository.getActiveStudySession();
  }
}
