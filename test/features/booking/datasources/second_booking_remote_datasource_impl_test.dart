import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/data/models/booking_model.dart';
import 'package:math_matric/features/marketplace/booking/data/repositories/booking/booking_remote_datasource_impl.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_status.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late BookingRemoteDataSourceImpl dataSource;

  setUp(() {
    firestore = FakeFirebaseFirestore();

    dataSource = BookingRemoteDataSourceImpl(
      firestore: firestore,
    );
  });

  group('createBooking', () {
    test(
      'creates a pending booking request in Firestore',
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

        final result = await dataSource.createBooking(
          booking,
        );

        expect(
          result.id,
          'booking-1',
        );

        final snapshot = await firestore
            .collection('bookings')
            .doc('booking-1')
            .get();

        expect(snapshot.exists, isTrue);

        final data = snapshot.data()!;

        expect(
          data['studentId'],
          'student-1',
        );

        expect(
          data['tutorId'],
          'tutor-1',
        );

        expect(
          data['status'],
          'pending',
        );

        expect(
          data['teachingMode'],
          'online',
        );

        expect(
          data['priceCents'],
          18000,
        );
      },
    );

    test(
      'does not create a confirmed booking when creating a request',
      () async {
        final booking = BookingModel(
          id: 'booking-2',
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

        await dataSource.createBooking(
          booking,
        );

        final snapshot = await firestore
            .collection('bookings')
            .doc('booking-2')
            .get();

        expect(
          snapshot.data()!['status'],
          isNot('confirmed'),
        );

        expect(
          snapshot.data()!['status'],
          'pending',
        );
      },
    );

    test(
      'allows multiple pending requests for the same tutor and timeslot',
      () async {
        final scheduledAt =
            DateTime(2026, 9, 15, 15, 0);

        final booking1 = BookingModel(
          id: 'booking-1',
          studentId: 'student-1',
          tutorId: 'tutor-1',
          scheduledAt: scheduledAt,
          durationMinutes: 60,
          teachingMode: TeachingMode.online,
          priceCents: 18000,
          currency: 'ZAR',
          status: BookingStatus.pending,
          tutorName: 'Alice',
          tutorPhotoUrl: null,
          createdAt: DateTime(2026, 9, 10),
          updatedAt: DateTime(2026, 9, 10),
          respondedAt: null,
        );

        final booking2 = BookingModel(
          id: 'booking-2',
          studentId: 'student-2',
          tutorId: 'tutor-1',
          scheduledAt: scheduledAt,
          durationMinutes: 60,
          teachingMode: TeachingMode.online,
          priceCents: 18000,
          currency: 'ZAR',
          status: BookingStatus.pending,
          tutorName: 'Alice',
          tutorPhotoUrl: null,
          createdAt: DateTime(2026, 9, 10),
          updatedAt: DateTime(2026, 9, 10),
          respondedAt: null,
        );

        await dataSource.createBooking(booking1);
        await dataSource.createBooking(booking2);

        final snapshots = await firestore
            .collection('bookings')
            .get();

        expect(
          snapshots.docs.length,
          2,
        );

        expect(
          snapshots.docs.every(
            (doc) => doc.data()['status'] == 'pending',
          ),
          isTrue,
        );
      },
    );
  
    group('getConfirmedBookingsForDate', () {
      test(
        'returns only confirmed bookings for the requested tutor and date',
        () async {
          final date = DateTime(2026, 9, 15);

          await firestore
              .collection('bookings')
              .doc('booking-1')
              .set({
                'id': 'booking-1',
                'studentId': 'student-1',
                'tutorId': 'tutor-1',
                'scheduledAt': Timestamp.fromDate(
                  DateTime(2026, 9, 15, 15, 0),
                ),
                'durationMinutes': 60,
                'teachingMode': 'online',
                'priceCents': 18000,
                'currency': 'ZAR',
                'status': 'confirmed',
                'tutorName': 'Alice',
                'tutorPhotoUrl': null,
                'createdAt': Timestamp.fromDate(date),
                'updatedAt': Timestamp.fromDate(date),
                'respondedAt': Timestamp.fromDate(date),
              });

          // Pending — must not be returned.
          await firestore
              .collection('bookings')
              .doc('booking-2')
              .set({
                'id': 'booking-2',
                'studentId': 'student-2',
                'tutorId': 'tutor-1',
                'scheduledAt': Timestamp.fromDate(
                  DateTime(2026, 9, 15, 16, 0),
                ),
                'durationMinutes': 60,
                'teachingMode': 'online',
                'priceCents': 18000,
                'currency': 'ZAR',
                'status': 'pending',
                'tutorName': 'Alice',
                'tutorPhotoUrl': null,
                'createdAt': Timestamp.fromDate(date),
                'updatedAt': Timestamp.fromDate(date),
                'respondedAt': null,
              });

          // Different tutor — must not be returned.
          await firestore
              .collection('bookings')
              .doc('booking-3')
              .set({
                'id': 'booking-3',
                'studentId': 'student-3',
                'tutorId': 'tutor-2',
                'scheduledAt': Timestamp.fromDate(
                  DateTime(2026, 9, 15, 17, 0),
                ),
                'durationMinutes': 60,
                'teachingMode': 'online',
                'priceCents': 18000,
                'currency': 'ZAR',
                'status': 'confirmed',
                'tutorName': 'Bob',
                'tutorPhotoUrl': null,
                'createdAt': Timestamp.fromDate(date),
                'updatedAt': Timestamp.fromDate(date),
                'respondedAt': Timestamp.fromDate(date),
              });

          // Different date — must not be returned.
          await firestore
              .collection('bookings')
              .doc('booking-4')
              .set({
            'id': 'booking-4',
            'studentId': 'student-4',
            'tutorId': 'tutor-1',
            'scheduledAt': Timestamp.fromDate(
              DateTime(2026, 9, 16, 15, 0),
            ),
            'durationMinutes': 60,
            'teachingMode': 'online',
            'priceCents': 18000,
            'currency': 'ZAR',
            'status': 'confirmed',
            'tutorName': 'Alice',
            'tutorPhotoUrl': null,
            'createdAt': Timestamp.fromDate(date),
            'updatedAt': Timestamp.fromDate(date),
            'respondedAt': Timestamp.fromDate(date),
          });

          final result = await dataSource.getConfirmedBookingsForDate(
            tutorId: 'tutor-1',
            date: date,
          );

          expect(result.length, 1);
          expect(result.first.id, 'booking-1');
        },
      );
    });
  
  });
}
