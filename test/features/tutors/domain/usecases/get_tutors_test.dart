import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_entity.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_page.dart';
import 'package:math_matric/features/marketplace/tutors/domain/repositories/tutor_repository.dart';
import 'package:math_matric/features/marketplace/tutors/domain/usecases/get_tutors_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockTutorRepository extends Mock implements TutorRepository {}

void main() {
  late MockTutorRepository repository;
  late GetTutorsUseCase useCase;

  setUp(() {
    repository = MockTutorRepository();
    useCase = GetTutorsUseCase(repository);
  });

  test('should return tutors from repository', () async {
    const tutor = TutorEntity(
      id: 'tutor-1',
      displayName: 'Alice',
      rating: 4.8,
      reviewCount: 10,
      experienceYears: 5,
      isVerified: true, teachingModes: [],
    );

    const page = TutorPage(
      tutors: [tutor],
      lastCursor: null,
      hasMore: false,
    );

    when(
      () => repository.getTutors(
        limit: 20,
        startAfter: null,
      ),
    ).thenAnswer((_) async => page);

    final result = await useCase();

    expect(result.tutors, [tutor]);
    expect(result.hasMore, false);

    verify(
      () => repository.getTutors(
        limit: 20,
        startAfter: null,
      ),
    ).called(1);
  });
}
