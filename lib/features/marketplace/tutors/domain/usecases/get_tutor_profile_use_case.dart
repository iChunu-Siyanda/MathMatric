import '../entities/tutor_entity.dart';
import '../repositories/tutor_repository.dart';

class GetTutorProfileUseCase {
  final TutorRepository repository;

  const GetTutorProfileUseCase(this.repository);

  Future<TutorEntity> call(String tutorId) {
    return repository.getTutor(tutorId);
  }
}
