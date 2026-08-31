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
  });
}
