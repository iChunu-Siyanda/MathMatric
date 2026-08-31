import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_entity.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_status.dart';
import 'package:math_matric/features/marketplace/booking/domain/repositories/booking_repository.dart';
import 'package:math_matric/features/marketplace/booking/domain/usecases/create_booking.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late MockBookingRepository repository;
  late CreateBooking createBooking;

  setUp(() {
    repository = MockBookingRepository();

    createBooking = CreateBooking(
      repository,
    );
  });

  group('CreateBooking', () {
    test(
      'creates a pending booking request',
      () async {
        final booking = BookingEntity(
          id: 'booking-1',
          studentId: 'student-1',
          tutorId: 'tutor-1',
          scheduledAt: DateTime(2026, 9, 15, 15, 0),
          durationMinutes: 60,
          teachingMode: TeachingMode.online,
          priceCents: 18000,
          currency: 'ZAR',
          status: BookingStatus.pending,
          tutorName: 'Alice',
          tutorPhotoUrl: null,
          createdAt: DateTime(2026, 9, 10, 12, 0),
          updatedAt: DateTime(2026, 9, 10, 12, 0),
          respondedAt: null,
        );

        when(
          () => repository.createBooking(booking),
        ).thenAnswer(
          (_) async => booking,
        );

        final result = await createBooking(
          booking,
        );

        expect(
          result.status,
          BookingStatus.pending,
        );

        expect(
          result.studentId,
          'student-1',
        );

        expect(
          result.tutorId,
          'tutor-1',
        );

        verify(
          () => repository.createBooking(booking),
        ).called(1);
      },
    );
  });
}
