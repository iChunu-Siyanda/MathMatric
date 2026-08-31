import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_entity.dart';
import 'package:math_matric/features/marketplace/tutors/domain/repositories/tutor_repository.dart';
import 'package:math_matric/features/marketplace/tutors/domain/usecases/get_tutor_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockTutorRepository extends Mock implements TutorRepository {}

void main() {
  late MockTutorRepository repository;
  late GetTutorUseCase useCase;

  setUp(() {
    repository = MockTutorRepository();
    useCase = GetTutorUseCase(repository);
  });

  test('should return tutor from repository', () async {
    const tutor = TutorEntity(
      id: 'tutor-1',
      displayName: 'Alice',
      rating: 4.8,
      reviewCount: 10,
      experienceYears: 5,
      isVerified: true,
    );

    when(
      () => repository.getTutor('tutor-1'),
    ).thenAnswer((_) async => tutor);

    final result = await useCase('tutor-1');

    expect(result, tutor);

    verify(
      () => repository.getTutor('tutor-1'),
    ).called(1);
  });
}
