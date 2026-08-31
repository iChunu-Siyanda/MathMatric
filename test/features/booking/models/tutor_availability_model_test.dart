import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/data/models/tutor_availability_model.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/availability_window.dart';

void main() {
  group('TutorAvailabilityModel', () {
    test('fromMap correctly parses availability', () {
      final model = TutorAvailabilityModel.fromFirestore({
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

      expect(model.tutorId, 'tutor-1');
      expect(
        model.timezone,
        'Africa/Johannesburg',
      );

      expect(
        model.weeklySchedule[1]!.first.start,
        '09:00',
      );

      expect(
        model.weeklySchedule[1]!.first.end,
        '17:00',
      );

      expect(
        model.weeklySchedule[2]!.first.start,
        '10:00',
      );

      expect(
        model.weeklySchedule[3],
        isEmpty,
      );
    });

    test('toMap correctly serializes availability', () {
      const model = TutorAvailabilityModel(
        tutorId: 'tutor-1',
        timezone: 'Africa/Johannesburg',
        weeklySchedule: {
          1: [
            AvailabilityWindow(
              start: '09:00',
              end: '17:00',
            ),
          ],
          6: [
            AvailabilityWindow(
              start: '10:00',
              end: '14:00',
            ),
          ],
        },
      );

      final map = model.toFirestore();

      expect(map['tutorId'], 'tutor-1');
      expect(
        map['timezone'],
        'Africa/Johannesburg',
      );

      expect(
        map['weeklySchedule']['1'],
        [
          {
            'start': '09:00',
            'end': '17:00',
          },
        ],
      );

      expect(
        map['weeklySchedule']['6'],
        [
          {
            'start': '10:00',
            'end': '14:00',
          },
        ],
      );
    });
  });
}
