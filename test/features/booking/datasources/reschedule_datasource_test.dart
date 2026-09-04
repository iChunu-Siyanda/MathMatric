import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/data/models/booking_model.dart';
import 'package:math_matric/features/marketplace/booking/data/repositories/booking/booking_remote_datasource_impl.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_status.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/reschedule_booking_entity.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFunctions extends Mock implements FirebaseFunctions {}

class MockHttpsCallable extends Mock implements HttpsCallable {}

class MockHttpsCallableResult extends Mock implements HttpsCallableResult<Map<String, dynamic>> {}

void main() {
  late FakeFirebaseFirestore firestore;
  late MockFirebaseFunctions functions;
  late MockHttpsCallable callable;
  late MockHttpsCallableResult callableResult;
  late BookingRemoteDataSourceImpl dataSource;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    functions = MockFirebaseFunctions();
    callable = MockHttpsCallable();
    callableResult = MockHttpsCallableResult();

    dataSource = BookingRemoteDataSourceImpl(
      firestore: firestore,
      functions: functions,
    );
  });

  test(
    'reschedules booking through the callable function',
    () async {
      final originalScheduledAt = DateTime(2026,9,10,15,);

      final newScheduledAt = DateTime(2026,9,11,15,);

      final request = RescheduleBookingEntity(
        bookingId: 'booking-1',
        newScheduledAt: newScheduledAt,
      );

      when(
        () => functions.httpsCallable(
          'rescheduleBooking',
        ),
      ).thenReturn(callable);

      when(
        () => callable.call(
          any(),
        ),
      ).thenAnswer(
        (_) async => callableResult,
      );

      when(
        () => callableResult.data,
      ).thenReturn({
        'success': true,
        'bookingId': 'booking-1',
        'status': 'confirmed',
      });

      await firestore
          .collection('bookings')
          .doc('booking-1')
          .set({
        'studentId': 'student-1',
        'tutorId': 'tutor-1',
        'scheduledAt':
            Timestamp.fromDate(newScheduledAt),
        'durationMinutes': 60,
        'teachingMode': 'online',
        'priceCents': 25000,
        'currency': 'ZAR',
        'status': BookingStatus.confirmed.name,
        'tutorName': 'Jane Tutor',
        'tutorPhotoUrl': null,
        'createdAt': Timestamp.fromDate(
          DateTime(2026, 9, 1),
        ),
        'updatedAt': Timestamp.fromDate(
          DateTime(2026, 9, 11),
        ),
        'respondedAt': null,
        'rescheduledAt': Timestamp.fromDate(
          DateTime(2026, 9, 11),
        ),
        'rescheduledBy': 'student',
        'previousScheduledAt':
            Timestamp.fromDate(originalScheduledAt),
      });

      final result =
          await dataSource.rescheduleBooking(
        request,
      );

      expect(
        result,
        isA<BookingModel>(),
      );

      expect(result.id, 'booking-1');
      expect(result.studentId, 'student-1');
      expect(result.tutorId, 'tutor-1');
      expect(
        result.scheduledAt,
        newScheduledAt,
      );
      expect(
        result.durationMinutes,
        60,
      );
      expect(
        result.teachingMode,
        TeachingMode.online,
      );
      expect(
        result.priceCents,
        25000,
      );
      expect(
        result.currency,
        'ZAR',
      );
      expect(
        result.status,
        BookingStatus.confirmed,
      );
      expect(
        result.tutorName,
        'Jane Tutor',
      );
      expect(
        result.tutorPhotoUrl,
        isNull,
      );
      expect(
        result.rescheduledBy,
        'student',
      );
      expect(
        result.previousScheduledAt,
        originalScheduledAt,
      );

      verify(
        () => functions.httpsCallable(
          'rescheduleBooking',
        ),
      ).called(1);

      verify(
        () => callable.call({
          'bookingId': 'booking-1',
          'newScheduledAt':
              newScheduledAt.toUtc().toIso8601String(),
        }),
      ).called(1);
    },
  );
}
