import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/pagination_cursor.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_entity.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_page.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_search_criteria.dart';
import 'package:math_matric/features/marketplace/tutors/domain/usecases/search_tutors_use_case.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/search/tutor_search_bloc.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/search/tutor_search_event.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/search/tutor_search_state.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchTutors extends Mock implements SearchTutors {}

class FakePaginationCursor extends Fake implements PaginationCursor {}

void main() {
  late MockSearchTutors mockSearchTutors;

  const criteria = TutorSearchCriteria(
    curriculumKey: 'mathematics_grade12:quadratic_functions',
  );

  final tutor1 = TutorEntity(
    id: 'tutor-1',
    displayName: 'Siya',
    photoUrl: null,
    headline: 'Mathematics Tutor',
    rating: 4.8,
    reviewCount: 100,
    experienceYears: 5,
    isVerified: true,
    teachingModes: const [
      TeachingMode.online,
      TeachingMode.inPerson,
    ], searchKeys: [], onlinePriceCents: 0.0, inPersonPriceCents: 0.0,
  );

  final tutor2 = TutorEntity(
    id: 'tutor-2',
    displayName: 'Njomane',
    photoUrl: null,
    headline: 'Grade 12 Mathematics Tutor',
    rating: 4.7,
    reviewCount: 80,
    experienceYears: 4,
    isVerified: true,
    teachingModes: const [
      TeachingMode.online,
    ], searchKeys: [], onlinePriceCents: 0.0, inPersonPriceCents: 0.0,
  );

  setUp(() {
    mockSearchTutors = MockSearchTutors();
  });

  group('SearchTutorsRequested', () {
    blocTest<TutorSearchBloc, TutorSearchState>(
      'emits loading then loaded',
      build: () {
        when(
          () => mockSearchTutors(
            criteria: criteria,
          ),
        ).thenAnswer(
          (_) async => TutorPage(
            tutors: [tutor1, tutor2],
            lastCursor: null,
            hasMore: false,
          ),
        );

        return TutorSearchBloc(
          searchTutors: mockSearchTutors,
        );
      },
      act: (bloc) => bloc.add(
        const SearchTutorsRequested(criteria),
      ),
      expect: () => [
        const TutorSearchLoading(),
        TutorSearchLoaded(
          tutors: [tutor1, tutor2],
          lastCursor: null,
          hasMore: false,
        ),
      ],
    );
  });

  group('TeachingModeFilterChanged', () {
    blocTest<TutorSearchBloc, TutorSearchState>(
      'filters tutors to online',
      build: () {
        when(
          () => mockSearchTutors(
            criteria: criteria,
          ),
        ).thenAnswer(
          (_) async => TutorPage(
            tutors: [tutor1, tutor2],
            lastCursor: null,
            hasMore: false,
          ),
        );

        return TutorSearchBloc(
          searchTutors: mockSearchTutors,
        );
      },
      seed: () => TutorSearchLoaded(
        tutors: [tutor1, tutor2],
        lastCursor: null,
        hasMore: false,
      ),
      act: (bloc) => bloc.add(
        const TeachingModeFilterChanged(
          TeachingMode.online,
        ),
      ),
      expect: () => [
        TutorSearchLoaded(
          tutors: [tutor1, tutor2],
          lastCursor: null,
          hasMore: false,
          teachingMode: TeachingMode.online,
        ),
      ],
    );

    blocTest<TutorSearchBloc, TutorSearchState>(
      'filters tutors to in-person',
      build: () => TutorSearchBloc(
        searchTutors: mockSearchTutors,
      ),
      seed: () => TutorSearchLoaded(
        tutors: [tutor1, tutor2],
        lastCursor: null,
        hasMore: false,
      ),
      act: (bloc) => bloc.add(
        const TeachingModeFilterChanged(
          TeachingMode.inPerson,
        ),
      ),
      expect: () => [
        TutorSearchLoaded(
          tutors: [tutor1, tutor2],
          lastCursor: null,
          hasMore: false,
          teachingMode: TeachingMode.inPerson,
        ),
      ],
    );
  });

  group('Search error', () {
    blocTest<TutorSearchBloc, TutorSearchState>(
      'emits loading then error',
      build: () {
        when(
          () => mockSearchTutors(
            criteria: criteria,
          ),
        ).thenThrow(
          Exception('Failed to search tutors'),
        );

        return TutorSearchBloc(
          searchTutors: mockSearchTutors,
        );
      },
      act: (bloc) => bloc.add(
        const SearchTutorsRequested(criteria),
      ),
      expect: () => [
        const TutorSearchLoading(),
        const TutorSearchError(
          'Exception: Failed to search tutors',
        ),
      ],
    );
  });
}
