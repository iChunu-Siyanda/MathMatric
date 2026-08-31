import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/data/repositories/availability/tutor_availability_remaote_data_source_impl.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late TutorAvailabilityRemoteDataSourceImpl dataSource;

  setUp(() {
    firestore = FakeFirebaseFirestore();

    dataSource = TutorAvailabilityRemoteDataSourceImpl(
      firestore: firestore,
    );
  });

  group('getAvailability', () {
    test('returns tutor availability when document exists', () async {
      await firestore
          .collection('tutorAvailability')
          .doc('tutor-1')
          .set({
        'tutorId': 'tutor-1',
        'timezone': 'Africa/Johannesburg',
        'weeklySchedule': {
          '1': [
            {
              'start': '09:00',
              'end': '17:00',
            },
          ],
          '2': [
            {
              'start': '10:00',
              'end': '15:00',
            },
          ],
          '3': [],
        },
      });

      final result = await dataSource.getAvailability(
        'tutor-1',
      );

      expect(result.tutorId, 'tutor-1');

      expect(
        result.timezone,
        'Africa/Johannesburg',
      );

      expect(
        result.weeklySchedule[1]!.first.start,
        '09:00',
      );

      expect(
        result.weeklySchedule[1]!.first.end,
        '17:00',
      );
    });

    test('throws when tutor availability does not exist', () async {
      expect(
        () => dataSource.getAvailability(
          'missing-tutor',
        ),
        throwsException,
      );
    });
  });
}
