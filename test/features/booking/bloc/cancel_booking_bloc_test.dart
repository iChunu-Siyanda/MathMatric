import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/cancellation/booking_cancellation_bloc.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/cancellation/booking_cancellation_event.dart';
import 'package:math_matric/features/marketplace/booking/presentation/bloc/cancellation/booking_cancellation_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/cancel_booking.dart';

class MockCancelBooking extends Mock implements CancelBooking {}

void main() {
  late MockCancelBooking mockCancelBooking;

  setUp(() {
    mockCancelBooking = MockCancelBooking();
  });

  group('BookingCancellationBloc', () {
    test(
      'initial state is BookingCancellationInitial',
      () {
        final bloc = BookingCancellationBloc(
          cancelBooking: mockCancelBooking,
        );

        expect(
          bloc.state,
          const BookingCancellationInitial(),
        );

        bloc.close();
      },
    );

    blocTest<BookingCancellationBloc,BookingCancellationState>(
      'emits in progress then success when cancellation succeeds',
      build: () {
        when(
          () => mockCancelBooking('booking-123'),
        ).thenAnswer((_) async {});

        return BookingCancellationBloc(
          cancelBooking: mockCancelBooking,
        );
      },
      act: (bloc) {
        bloc.add(
          const BookingCancellationRequested(
            bookingId: 'booking-123',
          ),
        );
      },
      expect: () => [
        const BookingCancellationInProgress(),
        const BookingCancellationSuccess(
          bookingId: 'booking-123',
        ),
      ],
      verify: (_) {
        verify(
          () => mockCancelBooking('booking-123'),
        ).called(1);
      },
    );

    blocTest<BookingCancellationBloc,
        BookingCancellationState>(
      'emits in progress then error when cancellation fails',
      build: () {
        when(
          () => mockCancelBooking('booking-123'),
        ).thenThrow(
          Exception('Cancellation failed'),
        );

        return BookingCancellationBloc(
          cancelBooking: mockCancelBooking,
        );
      },
      act: (bloc) {
        bloc.add(
          const BookingCancellationRequested(
            bookingId: 'booking-123',
          ),
        );
      },
      expect: () => [
        const BookingCancellationInProgress(),
        const BookingCancellationError(
          'Exception: Cancellation failed',
        ),
      ],
      verify: (_) {
        verify(
          () => mockCancelBooking('booking-123'),
        ).called(1);
      },
    );

    blocTest<BookingCancellationBloc,
        BookingCancellationState>(
      'resets to initial state',
      build: () {
        return BookingCancellationBloc(
          cancelBooking: mockCancelBooking,
        );
      },
      act: (bloc) {
        bloc.add(
          const BookingCancellationReset(),
        );
      },
      expect: () => [
        const BookingCancellationInitial(),
      ],
    );
  });
}
