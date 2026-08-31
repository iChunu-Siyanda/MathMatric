import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/get_tutor_availability_use_case.dart';
import 'package:mocktail/mocktail.dart';

import 'package:math_matric/features/marketplace/booking/domain/entities/booking_entity.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/tutor_availability.dart';
import 'package:math_matric/features/marketplace/booking/domain/services/availability_slot_generator.dart';
import 'package:math_matric/features/marketplace/booking/domain/services/booking_conflict_checker.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/get_confirmed_bookings_for_date.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/availability/availability_bloc.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/availability/availability_event.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/availability/availability_state.dart';

class MockGetTutorAvailability extends Mock implements GetTutorAvailabilityUseCase {}

class MockGetConfirmedBookingsForDate extends Mock implements GetConfirmedBookingsForDate {}

class MockAvailabilitySlotGenerator extends Mock implements AvailabilitySlotGenerator {}

class MockBookingConflictChecker extends Mock implements BookingConflictChecker {}

class FakeAvailability extends Fake implements TutorAvailability {}

void main() {
  late MockGetTutorAvailability getTutorAvailability;
  late MockGetConfirmedBookingsForDate getConfirmedBookingsForDate;
  late MockAvailabilitySlotGenerator slotGenerator;
  late MockBookingConflictChecker conflictChecker;

  late AvailabilityBloc bloc;

  final date = DateTime(2026, 9, 15);

  final availability = TutorAvailability(
    tutorId: 'tutor-1',
    weeklySchedule: const {}, 
    timezone: '',
  );

  final bookings = <BookingEntity>[];

  final candidateSlots = <DateTime>[
    DateTime(2026, 9, 15, 15, 0),
    DateTime(2026, 9, 15, 16, 0),
  ];

  final availableSlots = <DateTime>[
    DateTime(2026, 9, 15, 15, 0),
  ];

  setUpAll(() {
    registerFallbackValue(FakeAvailability());
  });

  setUp(() {
    getTutorAvailability =
        MockGetTutorAvailability();

    getConfirmedBookingsForDate =
        MockGetConfirmedBookingsForDate();

    slotGenerator =
        MockAvailabilitySlotGenerator();

    conflictChecker =
        MockBookingConflictChecker();

    bloc = AvailabilityBloc(
      getTutorAvailability:
          getTutorAvailability,
      getConfirmedBookingsForDate:
          getConfirmedBookingsForDate,
      slotGenerator:
          slotGenerator,
      conflictChecker:
          conflictChecker,
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  group('AvailabilityRequested', () {
    blocTest<AvailabilityBloc, AvailabilityState>(
      'emits loading then loaded',
      build: () {
        when(
          () => getTutorAvailability('tutor-1'),
        ).thenAnswer(
          (_) async => availability,
        );

        when(
          () => getConfirmedBookingsForDate(
            tutorId: 'tutor-1',
            date: date,
          ),
        ).thenAnswer(
          (_) async => bookings,
        );

        when(
          () => slotGenerator.generateSlots(
            date: date,
            durationMinutes: 60,
            windows: any(named: 'windows'),
          ),
        ).thenReturn(candidateSlots);

        when(
          () => conflictChecker.removeConflictingSlots(
            slots: candidateSlots,
            slotDurationMinutes: 60,
            bookings: bookings,
          ),
        ).thenReturn(availableSlots);

        return bloc;
      },
      act: (bloc) => bloc.add(
        AvailabilityRequested(
          tutorId: 'tutor-1',
          date: date,
          durationMinutes: 60,
        ),
      ),
      expect: () => [
        const AvailabilityLoading(),
        AvailabilityLoaded(
          tutorId: 'tutor-1',
          date: date,
          durationMinutes: 60,
          slots: [
            AvailableSlot(
              start: DateTime(2026, 9, 15, 15, 0),
              end: DateTime(2026, 9, 15, 16, 0),
            ),
          ],
        ),
      ],
    );

    test(
      'fetches tutor availability only once for the same tutor',
      () async {
        when(
          () => getTutorAvailability('tutor-1'),
        ).thenAnswer(
          (_) async => availability,
        );

        when(
          () => getConfirmedBookingsForDate(
            tutorId: 'tutor-1',
            date: any(named: 'date'),
          ),
        ).thenAnswer(
          (_) async => bookings,
        );

        when(
          () => slotGenerator.generateSlots(
            date: any(named: 'date'),
            durationMinutes: 60,
            windows: any(named: 'windows'),
          ),
        ).thenReturn(candidateSlots);

        when(
          () => conflictChecker.removeConflictingSlots(
            slots: candidateSlots,
            slotDurationMinutes: 60,
            bookings: bookings,
          ),
        ).thenReturn(availableSlots);

        bloc.add(
          AvailabilityRequested(
            tutorId: 'tutor-1',
            date: DateTime(2026, 9, 15),
            durationMinutes: 60,
          ),
        );

        await Future<void>.delayed(Duration.zero);

        bloc.add(
          AvailabilityRequested(
            tutorId: 'tutor-1',
            date: DateTime(2026, 9, 16),
            durationMinutes: 60,
          ),
        );

        await Future<void>.delayed(Duration.zero);

        verify(
          () => getTutorAvailability('tutor-1'),
        ).called(1);
      },
    );

    test(
      'fetches availability again when tutor changes',
      () async {
        when(
          () => getTutorAvailability(any()),
        ).thenAnswer(
          (_) async => availability,
        );

        when(
          () => getConfirmedBookingsForDate(
            tutorId: any(named: 'tutorId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer(
          (_) async => bookings,
        );

        when(
          () => slotGenerator.generateSlots(
            date: any(named: 'date'),
            durationMinutes: 60,
            windows: any(named: 'windows'),
          ),
        ).thenReturn(candidateSlots);

        when(
          () => conflictChecker.removeConflictingSlots(
            slots: candidateSlots,
            slotDurationMinutes: 60,
            bookings: bookings,
          ),
        ).thenReturn(availableSlots);

        bloc.add(
          AvailabilityRequested(
            tutorId: 'tutor-1',
            date: date,
            durationMinutes: 60,
          ),
        );

        await Future<void>.delayed(Duration.zero);

        bloc.add(
          AvailabilityRequested(
            tutorId: 'tutor-2',
            date: date,
            durationMinutes: 60,
          ),
        );

        await Future<void>.delayed(Duration.zero);

        verify(
          () => getTutorAvailability('tutor-1'),
        ).called(1);

        verify(
          () => getTutorAvailability('tutor-2'),
        ).called(1);
      },
    );
  });

  group('Error handling', () {
    blocTest<AvailabilityBloc, AvailabilityState>(
      'emits AvailabilityError when tutor availability fails',
      build: () {
        when(
          () => getTutorAvailability('tutor-1'),
        ).thenThrow(
          Exception('Failed to load availability'),
        );

        return bloc;
      },
      act: (bloc) => bloc.add(
        AvailabilityRequested(
          tutorId: 'tutor-1',
          date: date,
          durationMinutes: 60,
        ),
      ),
      expect: () => [
        const AvailabilityLoading(),
        const AvailabilityError(
          'Exception: Failed to load availability',
        ),
      ],
    );

    blocTest<AvailabilityBloc, AvailabilityState>(
      'emits AvailabilityError when confirmed bookings fail',
      build: () {
        when(
          () => getTutorAvailability('tutor-1'),
        ).thenAnswer(
          (_) async => availability,
        );

        when(
          () => getConfirmedBookingsForDate(
            tutorId: 'tutor-1',
            date: date,
          ),
        ).thenThrow(
          Exception('Failed to load bookings'),
        );

        return bloc;
      },
      act: (bloc) => bloc.add(
        AvailabilityRequested(
          tutorId: 'tutor-1',
          date: date,
          durationMinutes: 60,
        ),
      ),
      expect: () => [
        const AvailabilityLoading(),
        const AvailabilityError(
          'Exception: Failed to load bookings',
        ),
      ],
    );
  });
}
