import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/availability_window.dart';
import 'package:math_matric/features/marketplace/booking/domain/services/availability_slot_generator.dart';

void main() {
  const generator = AvailabilitySlotGenerator();

  final date = DateTime(2026, 9, 15);

  group('AvailabilitySlotGenerator', () {
    test('generates 60-minute slots at 30-minute intervals', () {
      const windows = [
        AvailabilityWindow(
          start: '09:00',
          end: '12:00',
        ),
      ];

      final result = generator.generateSlots(
        date: date,
        durationMinutes: 60,
        windows: windows,
      );

      expect(result, [
        DateTime(2026, 9, 15, 9, 0),
        DateTime(2026, 9, 15, 9, 30),
        DateTime(2026, 9, 15, 10, 0),
        DateTime(2026, 9, 15, 10, 30),
        DateTime(2026, 9, 15, 11, 0),
      ]);
    });

    test('does not generate a slot that exceeds availability', () {
      const windows = [
        AvailabilityWindow(
          start: '09:00',
          end: '10:30',
        ),
      ];

      final result = generator.generateSlots(
        date: date,
        durationMinutes: 60, 
        windows: windows,
      );

      expect(result, [
        DateTime(2026, 9, 15, 9, 0),
        DateTime(2026, 9, 15, 9, 30),
      ]);
    });

    test('generates 90-minute slots correctly', () {
      const windows = [
        AvailabilityWindow(
          start: '09:00',
          end: '13:00',
        ),
      ];

      final result = generator.generateSlots(
        date: date,
        durationMinutes: 90, 
        windows: windows,
      );

      expect(result, [
        DateTime(2026, 9, 15, 9, 0),
        DateTime(2026, 9, 15, 9, 30),
        DateTime(2026, 9, 15, 10, 0),
        DateTime(2026, 9, 15, 10, 30),
        DateTime(2026, 9, 15, 11, 0),
        DateTime(2026, 9, 15, 11, 30),
      ]);
    });

    test('returns empty list when duration is longer than availability', () {
      const windows = [
        AvailabilityWindow(
          start: '09:00',
          end: '09:30',
        ),
      ];

      final result = generator.generateSlots(
        date: date,
        durationMinutes: 60,
        windows: windows,
      );

      expect(result, isEmpty);
    });

    test('supports custom slot intervals', () {
      const windows = [
        AvailabilityWindow(
          start: '09:00',
          end: '12:00',
        ),
      ];

      final result = generator.generateSlots(
        date: date,
        durationMinutes: 60,
        intervalMinutes: 60, 
        windows: windows,
      );

      expect(result, [
        DateTime(2026, 9, 15, 9, 0),
        DateTime(2026, 9, 15, 10, 0),
        DateTime(2026, 9, 15, 11, 0),
      ]);
    });

    test('handles multiple availability windows', () {
    const windows = [
      AvailabilityWindow(
        start: '09:00',
        end: '12:00',
      ),
      AvailabilityWindow(
        start: '14:00',
        end: '17:00',
      ),
    ];

    final result = generator.generateSlots(
      date: date,
      durationMinutes: 60, 
      windows: windows,
    );

    expect(result, [
      DateTime(2026, 9, 15, 9, 0),
      DateTime(2026, 9, 15, 9, 30),
      DateTime(2026, 9, 15, 10, 0),
      DateTime(2026, 9, 15, 10, 30),
      DateTime(2026, 9, 15, 11, 0),
      DateTime(2026, 9, 15, 14, 0),
      DateTime(2026, 9, 15, 14, 30),
      DateTime(2026, 9, 15, 15, 0),
      DateTime(2026, 9, 15, 15, 30),
      DateTime(2026, 9, 15, 16, 0),
    ]);
  });

});
}
