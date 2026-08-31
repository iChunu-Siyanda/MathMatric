import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/tutors/data/datasources/remote/tutor_remote_data_source.dart';
import 'package:math_matric/features/marketplace/tutors/data/models/tutor_model.dart';
import 'package:math_matric/features/marketplace/tutors/data/models/tutor_page_model.dart';
import 'package:math_matric/features/marketplace/tutors/data/repositories/tutor_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockTutorRemoteDataSource extends Mock
implements TutorRemoteDataSource {}

// class FakeDocumentSnapshot extends Fake
//     implements DocumentSnapshot {}

void main() {
  late MockTutorRemoteDataSource datasource;
  late TutorRepositoryImpl repository;

  setUp(() {
    datasource = MockTutorRemoteDataSource();

    repository = TutorRepositoryImpl(
      remoteDataSource: datasource,
    );
  });

  group('getTutors', () {
    test('should delegate to datasource', () async {
      const page = TutorPageModel(
        tutors: [
          TutorModel(
            id: 'tutor-1',
            displayName: 'Alice',
            rating: 4.8,
            reviewCount: 10,
            experienceYears: 5,
            isVerified: true, teachingModes: [],
          ),
        ],
        lastCursor: null,
        hasMore: false,
      );

      when(
        () => datasource.getTutors(
          limit: 20,
          startAfter: null,
        ),
      ).thenAnswer((_) async => page);

      final result = await repository.getTutors();

      expect(result.tutors.length, 1);
      expect(result.tutors.first.id, 'tutor-1');
      expect(result.hasMore, false);

      verify(
        () => datasource.getTutors(
          limit: 20,
          startAfter: null,
        ),
      ).called(1);
    });
  });

  group('getTutor', () {
    test('should delegate to datasource', () async {
      const tutor = TutorModel(
        id: 'tutor-1',
        displayName: 'Alice',
        rating: 4.8,
        reviewCount: 10,
        experienceYears: 5,
        isVerified: true, teachingModes: [],
      );

      when(
        () => datasource.getTutor('tutor-1'),
      ).thenAnswer((_) async => tutor);

      final result = await repository.getTutor('tutor-1');

      expect(result, tutor);

      verify(
        () => datasource.getTutor('tutor-1'),
      ).called(1);
    });
  });
}
