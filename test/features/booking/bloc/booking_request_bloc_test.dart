import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_status.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/booking/booking_request_bloc.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/booking/booking_request_event.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/booking/booking_request_state.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';
import 'package:mocktail/mocktail.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_entity.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/create_booking.dart';

class MockCreateBooking extends Mock implements CreateBooking {}

void main() {
  late MockCreateBooking createBooking;
  late BookingRequestBloc bloc;

  final booking = BookingEntity(
    id: 'booking-1',
    studentId: 'student-1',
    tutorId: 'tutor-1',
    scheduledAt: DateTime(2026, 9, 15, 15),
    durationMinutes: 60,
    teachingMode: TeachingMode.online,
    priceCents: 18000,
    currency: 'ZAR',
    status: BookingStatus.pending,
    tutorName: 'Alice',
    tutorPhotoUrl: null,
    createdAt: DateTime(2026, 9, 1),
    updatedAt: DateTime(2026, 9, 1),
    respondedAt: null,
  );

  setUp(() {
    createBooking = MockCreateBooking();

    bloc = BookingRequestBloc(
      createBooking: createBooking,
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  group('BookingRequestSubmitted', () {
    blocTest<BookingRequestBloc, BookingRequestState>(
      'emits submitting then submitted when booking succeeds',
      build: () {
        when(
          () => createBooking(booking),
        ).thenAnswer(
          (_) async => booking,
        );

        return bloc;
      },
      act: (bloc) {
        bloc.add(
          BookingRequestSubmittedEvent(
            booking: booking,
          ),
        );
      },
      expect: () => [
        const BookingRequestSubmitting(),
        BookingRequestSubmittedState(
          booking: booking,
        ),
      ],
      verify: (_) {
        verify(
          () => createBooking(booking),
        ).called(1);
      },
    );

    blocTest<BookingRequestBloc, BookingRequestState>(
      'emits submitting then error when booking fails',
      build: () {
        when(
          () => createBooking(booking),
        ).thenThrow(
          Exception('Failed to create booking'),
        );

        return bloc;
      },
      act: (bloc) {
        bloc.add(
          BookingRequestSubmittedEvent(
            booking: booking,
          ),
        );
      },
      expect: () => [
        const BookingRequestSubmitting(),
        const BookingRequestError(
          'Exception: Failed to create booking',
        ),
      ],
      verify: (_) {
        verify(
          () => createBooking(booking),
        ).called(1);
      },
    );
  });

  group('BookingRequestReset', () {
    blocTest<BookingRequestBloc, BookingRequestState>(
      'emits initial state',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const BookingRequestReset(),
        );
      },
      expect: () => [
        const BookingRequestInitial(),
      ],
    );
  });
}