import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/data/datasource/booking_remote_datasource.dart';
import 'package:math_matric/features/marketplace/booking/data/models/booking_model.dart';
import 'package:math_matric/features/marketplace/booking/data/repositories/booking/booking_repository_impl.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_status.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingRemoteDataSource extends Mock implements BookingRemoteDataSource {}

void main() {
  late MockBookingRemoteDataSource dataSource;
  late BookingRepositoryImpl repository;

  setUp(() {
    dataSource = MockBookingRemoteDataSource();

    repository = BookingRepositoryImpl(
      remoteDataSource: dataSource,
    );
  });

  group('createBooking', () {
    test(
      'delegates booking creation to the remote datasource',
      () async {
        final booking = BookingModel(
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
          () => dataSource.createBooking(booking),
        ).thenAnswer(
          (_) async => booking,
        );

        final result = await repository.createBooking(
          booking,
        );

        expect(result, booking);

        verify(
          () => dataSource.createBooking(booking),
        ).called(1);
      },
    );
  });
}
