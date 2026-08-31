import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/pagination_cursor.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_entity.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_page.dart';
import 'package:math_matric/features/marketplace/tutors/domain/usecases/get_tutors_use_case.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/tutor_bloc.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/tutor_event.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/tutor_states.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTutors extends Mock implements GetTutorsUseCase {}
class FakePaginationCursor extends Fake implements PaginationCursor {}
void main() {
  late MockGetTutors getTutors;

  const tutor1 = TutorEntity(
    id: 'tutor-1',
    displayName: 'Alice',
    rating: 4.8,
    reviewCount: 100,
    experienceYears: 5,
    isVerified: true,
  );

  const tutor2 = TutorEntity(
    id: 'tutor-2',
    displayName: 'Bob',
    rating: 4.7,
    reviewCount: 80,
    experienceYears: 4,
    isVerified: true,
  );

  setUp(() {
    getTutors = MockGetTutors();
  });

  TutorBloc buildBloc() {
    return TutorBloc(
      getTutors: getTutors,
    );
  }

  group('initial state', () {
    test('should be TutorInitial', () {
      final bloc = buildBloc();

      expect(bloc.state, const TutorInitial());

      bloc.close();
    });
  });

  group('LoadTutors', () {
    blocTest<TutorBloc, TutorState>(
      'emits loading then loaded',
      build: () {
        when(
          () => getTutors(
            limit: 20,
            startAfter: null,
          ),
        ).thenAnswer(
          (_) async => const TutorPage(
            tutors: [tutor1, tutor2],
            lastCursor: null,
            hasMore: false,
          ),
        );

        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadTutors()),
      expect: () => [
        const TutorLoading(),
        const TutorLoaded(
          tutors: [tutor1, tutor2],
          lastCursor: null,
          hasMore: false,
        ),
      ],
    );

    blocTest<TutorBloc, TutorState>(
      'emits loading then error when loading fails',
      build: () {
        when(
          () => getTutors(
            limit: 20,
            startAfter: null,
          ),
        ).thenThrow(Exception('Network error'));

        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadTutors()),
      expect: () => [
        const TutorLoading(),
        isA<TutorError>(),
      ],
    );
  });

  group('LoadMoreTutors', () {
    blocTest<TutorBloc, TutorState>(
      'loads next page and appends tutors',
      build: () {
        final bloc = buildBloc();
        final cursor = FakePaginationCursor();

        when(
          () => getTutors(
            limit: 20,
            startAfter: null,
          ),
        ).thenAnswer(
          (_) async => TutorPage(
            tutors: const [tutor1],
            lastCursor: cursor,
            hasMore: true,
          ),
        );

        when(
          () => getTutors(
            limit: 20,
            startAfter: any(named: 'startAfter'),
          ),
        ).thenAnswer(
          (_) async => const TutorPage(
            tutors: [tutor2],
            lastCursor: null,
            hasMore: false,
          ),
        );

        bloc.add(const LoadTutors());

        return bloc;
      },
      act: (bloc) async {
        await Future<void>.delayed(Duration.zero);
        bloc.add(const LoadMoreTutors());
      },
      expect: () => [
        const TutorLoading(),
        isA<TutorLoaded>()
            .having(
              (state) => state.tutors,
              'tutors',
              [tutor1],
            )
            .having(
              (state) => state.hasMore,
              'hasMore',
              true,
            ),
        isA<TutorLoaded>()
            .having(
              (state) => state.isLoadingMore,
              'isLoadingMore',
              true,
            ),
        isA<TutorLoaded>()
            .having(
              (state) => state.tutors,
              'tutors',
              [tutor1, tutor2],
            )
            .having(
              (state) => state.hasMore,
              'hasMore',
              false,
            ),
      ],
    );

    blocTest<TutorBloc, TutorState>(
      'does nothing when hasMore is false',
      build: () => buildBloc(),
      seed: () => const TutorLoaded(
        tutors: [tutor1],
        lastCursor: null,
        hasMore: false,
      ),
      act: (bloc) => bloc.add(const LoadMoreTutors()),
      expect: () => [],
      verify: (_) {
        verifyNever(
          () => getTutors(
            limit: any(named: 'limit'),
            startAfter: any(named: 'startAfter'),
          ),
        );
      },
    );

    blocTest<TutorBloc, TutorState>(
      'does nothing when already loading more',
      build: () => buildBloc(),
      seed: () {
        final cursor = FakePaginationCursor();
        
        return TutorLoaded(
        tutors: const [tutor1],
        lastCursor: cursor,
        hasMore: true,
        isLoadingMore: true,
      );},
      act: (bloc) => bloc.add(const LoadMoreTutors()),
      expect: () => [],
    );
  });

  group('RefreshTutors', () {
    blocTest<TutorBloc, TutorState>(
      'loads a fresh first page',
      build: () {
        when(
          () => getTutors(
            limit: 20,
            startAfter: null,
          ),
        ).thenAnswer(
          (_) async => const TutorPage(
            tutors: [tutor2],
            lastCursor: null,
            hasMore: false,
          ),
        );

        return buildBloc();
      },
      seed: () => const TutorLoaded(
        tutors: [tutor1],
        lastCursor: null,
        hasMore: false,
      ),
      act: (bloc) => bloc.add(const RefreshTutors()),
      expect: () => [
        const TutorLoaded(
          tutors: [tutor2],
          lastCursor: null,
          hasMore: false,
        ),
      ],
    );
  });
}
