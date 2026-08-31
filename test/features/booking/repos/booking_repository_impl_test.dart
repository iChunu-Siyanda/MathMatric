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

  final booking = BookingModel(
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
    createdAt: DateTime(2026, 8, 31),
    updatedAt: DateTime(2026, 8, 31),
  );

  setUp(() {
    dataSource = MockBookingRemoteDataSource();

    repository = BookingRepositoryImpl(
      remoteDataSource: dataSource,
    );
  });

  group('getBooking', () {
    test('returns booking from datasource', () async {
      when(
        () => dataSource.getBooking('booking-1'),
      ).thenAnswer(
        (_) async => booking,
      );

      final result = await repository.getBooking(
        'booking-1',
      );

      expect(result, booking);

      verify(
        () => dataSource.getBooking('booking-1'),
      ).called(1);
    });
  });

  group('getStudentBookings', () {
    test('returns student bookings from datasource', () async {
      when(
        () => dataSource.getStudentBookings(
          studentId: 'student-1',
        ),
      ).thenAnswer(
        (_) async => [booking],
      );

      final result = await repository.getStudentBookings(
        studentId: 'student-1',
      );

      expect(result, [booking]);

      verify(
        () => dataSource.getStudentBookings(
          studentId: 'student-1',
        ),
      ).called(1);
    });
  });

  group('createBooking', () {
    test('passes booking to datasource', () async {
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
    });
  });

  group('cancelBooking', () {
    test('passes booking id to datasource', () async {
      when(
        () => dataSource.cancelBooking('booking-1'),
      ).thenAnswer(
        (_) async {});

      await repository.cancelBooking(
        'booking-1',
      );

      verify(
        () => dataSource.cancelBooking('booking-1'),
      ).called(1);
    });
  });
}
