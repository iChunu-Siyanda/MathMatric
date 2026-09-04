import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_entity.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_status.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/reschedule_booking_entity.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/reschedule_booking_use_case.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/reschedule/reschedule_bloc.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/reschedule/reschedule_booking_event.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/reschedule/reschedule_booking_state.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';
import 'package:mocktail/mocktail.dart';

class MockRescheduleBooking extends Mock implements RescheduleBookingUseCase {}

void main() {
  late MockRescheduleBooking rescheduleBooking;
  late RescheduleBookingEntity request;
  late BookingEntity expectedBooking;

  setUp(() {
    rescheduleBooking = MockRescheduleBooking();

    request = RescheduleBookingEntity(
      bookingId: 'booking-1',
      newScheduledAt: DateTime(2026,9,11,15,),
    );

    expectedBooking = BookingEntity(
      id: 'booking-1',
      studentId: 'student-1',
      tutorId: 'tutor-1',
      scheduledAt: DateTime(2026,9,11,15,),
      durationMinutes: 60,
      teachingMode: TeachingMode.online,
      priceCents: 25000,
      currency: 'ZAR',
      status: BookingStatus.confirmed,
      tutorName: 'Jane Tutor',
      tutorPhotoUrl: null,
      createdAt: DateTime(2026,9,1,),
      updatedAt: DateTime(2026,9,11,),
      respondedAt: null,
      rescheduledAt: DateTime(2026,9,11,),
      rescheduledBy: 'student',
      previousScheduledAt: DateTime(2026,9,10,15,),
    );
  });

  group(
    'RescheduleBookingBloc',
    () {
      blocTest<RescheduleBookingBloc, RescheduleBookingState>(
        'emits [InProgress, Success] when rescheduling succeeds',
        build: () {
          when(
            () => rescheduleBooking(request),
          ).thenAnswer(
            (_) async => expectedBooking,
          );

          return RescheduleBookingBloc(
            rescheduleBooking: rescheduleBooking,
          );
        },
        act: (bloc) {
          bloc.add(RescheduleBookingRequested(request,),);
        },
        expect: () => [
          const RescheduleBookingInProgress(),
          RescheduleBookingSuccess(
            booking: expectedBooking,
          ),
        ],
        verify: (_) {
          verify(
            () => rescheduleBooking(request),
          ).called(1);
        },
      );

      blocTest<RescheduleBookingBloc, RescheduleBookingState>(
        'emits [InProgress, Error] when rescheduling fails',
        build: () {
          when(
            () => rescheduleBooking(request),
          ).thenThrow(
            Exception(
              'Unable to reschedule booking',
            ),
          );

          return RescheduleBookingBloc(
            rescheduleBooking: rescheduleBooking,
          );
        },
        act: (bloc) {
          bloc.add(
            RescheduleBookingRequested(
              request,
            ),
          );
        },
        expect: () => [
          const RescheduleBookingInProgress(),
          const RescheduleBookingError(
            'Exception: Unable to reschedule booking',
          ),
        ],
        verify: (_) {
          verify(
            () => rescheduleBooking(request),
          ).called(1);
        },
      );

      blocTest<RescheduleBookingBloc, RescheduleBookingState>(
        'emits Initial when reset is requested',
        build: () {
          return RescheduleBookingBloc(rescheduleBooking: rescheduleBooking,);
        },
        act: (bloc) {
          bloc.add(const RescheduleBookingReset(),);
        },
        expect: () => [const RescheduleBookingInitial(),],
      );
    },
  );
}

// the UI sends:

// RescheduleBookingEntity(
//   bookingId: booking.id,
//   newScheduledAt: selectedDateTime,
// )

// The UI should:

// Show the current booking date/time.
// Only allow rescheduling when the booking is confirmed.
// Only allow it when there are 24+ hours before the original lesson.
// Display available slots for the tutor.
// Remove slots that conflict with confirmed bookings.
// Submit the selected slot through RescheduleBookingBloc.
// Show loading/success/error states.
// On success, refresh/update the booking.
// On failure, display the backend error appropriately.
