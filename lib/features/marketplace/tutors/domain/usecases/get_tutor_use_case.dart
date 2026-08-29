import '../entities/tutor_entity.dart';
import '../repositories/tutor_repository.dart';

class GetTutorUseCase {
  final TutorRepository repository;

  GetTutorUseCase(this.repository);

  Future<TutorEntity> call(String tutorId) {
    return repository.getTutor(tutorId);
  }
}
