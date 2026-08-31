import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/data/models/booking_model.dart';
import 'package:math_matric/features/marketplace/booking/data/repositories/booking_remote_datasource_impl.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_status.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late BookingRemoteDataSourceImpl dataSource;

  final scheduledAt = DateTime(2026, 9, 15, 15, 0);
  final createdAt = DateTime(2026, 8, 31, 10, 0);
  final updatedAt = DateTime(2026, 8, 31, 10, 0);

  BookingModel createBooking({
    String id = 'booking-1',
    String studentId = 'student-1',
    String tutorId = 'tutor-1',
    BookingStatus status = BookingStatus.pending,
    TeachingMode teachingMode = TeachingMode.online,
    int priceCents = 18000,
  }) {
    return BookingModel(
      id: id,
      studentId: studentId,
      tutorId: tutorId,
      scheduledAt: scheduledAt,
      durationMinutes: 60,
      teachingMode: teachingMode,
      priceCents: priceCents,
      currency: 'ZAR',
      status: status,
      tutorName: 'Alice',
      tutorPhotoUrl: null,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  setUp(() {
    firestore = FakeFirebaseFirestore();

    dataSource = BookingRemoteDataSourceImpl(
      firestore: firestore,
    );
  });

  group('getBooking', () {
    test('returns booking when booking exists', () async {
      final booking = createBooking();

      await firestore
          .collection('bookings')
          .doc(booking.id)
          .set(booking.toFirestore());

      final result = await dataSource.getBooking(
        booking.id,
      );

      expect(result.id, booking.id);
      expect(result.studentId, booking.studentId);
      expect(result.tutorId, booking.tutorId);
      expect(result.durationMinutes, 60);
      expect(result.teachingMode, TeachingMode.online);
      expect(result.priceCents, 18000);
      expect(result.currency, 'ZAR');
      expect(result.status, BookingStatus.pending);
      expect(result.tutorName, 'Alice');
    });

    test('throws when booking does not exist', () async {
      expect(
        () => dataSource.getBooking('missing-booking'),
        throwsException,
      );
    });
  });

  group('getStudentBookings', () {
    test('returns only bookings belonging to the student', () async {
      final studentBooking1 = createBooking(
        id: 'booking-1',
        studentId: 'student-1',
      );

      final studentBooking2 = createBooking(
        id: 'booking-2',
        studentId: 'student-1',
      );

      final otherStudentBooking = createBooking(
        id: 'booking-3',
        studentId: 'student-2',
      );

      await firestore
          .collection('bookings')
          .doc(studentBooking1.id)
          .set(studentBooking1.toFirestore());

      await firestore
          .collection('bookings')
          .doc(studentBooking2.id)
          .set(studentBooking2.toFirestore());

      await firestore
          .collection('bookings')
          .doc(otherStudentBooking.id)
          .set(otherStudentBooking.toFirestore());

      final result = await dataSource.getStudentBookings(
        studentId: 'student-1',
      );

      expect(result.length, 2);

      expect(
        result.map((booking) => booking.id),
        containsAll([
          'booking-1',
          'booking-2',
        ]),
      );

      expect(
        result.map((booking) => booking.studentId),
        everyElement('student-1'),
      );
    });

    test('returns empty list when student has no bookings', () async {
      final result = await dataSource.getStudentBookings(
        studentId: 'student-with-no-bookings',
      );

      expect(result, isEmpty);
    });
  });

  group('createBooking', () {
    test('creates booking in Firestore', () async {
      final booking = createBooking();

      final result = await dataSource.createBooking(
        booking,
      );

      expect(result.id, booking.id);

      final document = await firestore
          .collection('bookings')
          .doc(booking.id)
          .get();

      expect(document.exists, isTrue);

      final data = document.data();

      expect(data?['studentId'], 'student-1');
      expect(data?['tutorId'], 'tutor-1');
      expect(data?['durationMinutes'], 60);
      expect(data?['teachingMode'], 'online');
      expect(data?['priceCents'], 18000);
      expect(data?['currency'], 'ZAR');
      expect(data?['status'], 'pending');
      expect(data?['tutorName'], 'Alice');
    });

    test('preserves in-person teaching mode and price', () async {
      final booking = createBooking(
        teachingMode: TeachingMode.inPerson,
        priceCents: 25000,
      );

      await dataSource.createBooking(booking);

      final document = await firestore
          .collection('bookings')
          .doc(booking.id)
          .get();

      final data = document.data();

      expect(data?['teachingMode'], 'inPerson');
      expect(data?['priceCents'], 25000);
    });
  });

  group('cancelBooking', () {
    test('changes booking status to cancelled', () async {
      final booking = createBooking();

      await firestore
          .collection('bookings')
          .doc(booking.id)
          .set(booking.toFirestore());

      await dataSource.cancelBooking(
        booking.id,
      );

      final document = await firestore
          .collection('bookings')
          .doc(booking.id)
          .get();

      final data = document.data();

      expect(
        data?['status'],
        'cancelled',
      );

      expect(
        data?['updatedAt'],
        isNotNull,
      );
    });
  });
}
