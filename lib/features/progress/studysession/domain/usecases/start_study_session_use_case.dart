import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';
import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';

class StartStudySessionUseCase {
  final StudySessionRepository repository;

  StartStudySessionUseCase(this.repository);

  Future<StudySessionEntity> call({
    required String topicId,
    required StudyActivity activity,
  }) {
    return repository.startSession(
      topicId: topicId,
      activity: activity,
    );
  }
}
