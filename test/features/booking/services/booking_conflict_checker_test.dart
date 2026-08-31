import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_entity.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_status.dart';
import 'package:math_matric/features/marketplace/booking/domain/services/booking_conflict_checker.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';

void main() {
  const checker = BookingConflictChecker();

  final baseDate = DateTime(2026, 9, 15);

  BookingEntity booking({
    required String id,
    required BookingStatus status,
    required DateTime scheduledAt,
    int durationMinutes = 60,
  }) {
    return BookingEntity(
      id: id,
      studentId: 'student-1',
      tutorId: 'tutor-1',
      scheduledAt: scheduledAt,
      durationMinutes: durationMinutes,
      teachingMode: TeachingMode.online,
      priceCents: 18000,
      currency: 'ZAR',
      status: status,
      tutorName: 'Alice',
      tutorPhotoUrl: null,
      createdAt: baseDate,
      updatedAt: baseDate,
      respondedAt: null,
    );
  }

  group('hasConflict', () {
    test(
      'returns true when slot overlaps a confirmed booking',
      () {
        final bookings = [
          booking(
            id: 'booking-1',
            status: BookingStatus.confirmed,
            scheduledAt: DateTime(
              2026,
              9,
              15,
              15,
              0,
            ),
          ),
        ];

        final result = checker.hasConflict(
          slotStart: DateTime(
            2026,
            9,
            15,
            15,
            30,
          ),
          slotDurationMinutes: 60,
          bookings: bookings,
        );

        expect(result, isTrue);
      },
    );

    test(
      'returns false when slot does not overlap confirmed booking',
      () {
        final bookings = [
          booking(
            id: 'booking-1',
            status: BookingStatus.confirmed,
            scheduledAt: DateTime(
              2026,
              9,
              15,
              15,
              0,
            ),
          ),
        ];

        final result = checker.hasConflict(
          slotStart: DateTime(
            2026,
            9,
            15,
            16,
            0,
          ),
          slotDurationMinutes: 60,
          bookings: bookings,
        );

        expect(result, isFalse);
      },
    );

    test(
      'pending booking does not block the slot',
      () {
        final bookings = [
          booking(
            id: 'booking-1',
            status: BookingStatus.pending,
            scheduledAt: DateTime(
              2026,
              9,
              15,
              15,
              0,
            ),
          ),
        ];

        final result = checker.hasConflict(
          slotStart: DateTime(
            2026,
            9,
            15,
            15,
            30,
          ),
          slotDurationMinutes: 60,
          bookings: bookings,
        );

        expect(result, isFalse);
      },
    );

    test(
      'declined booking does not block the slot',
      () {
        final bookings = [
          booking(
            id: 'booking-1',
            status: BookingStatus.declined,
            scheduledAt: DateTime(
              2026,
              9,
              15,
              15,
              0,
            ),
          ),
        ];

        final result = checker.hasConflict(
          slotStart: DateTime(
            2026,
            9,
            15,
            15,
            30,
          ),
          slotDurationMinutes: 60,
          bookings: bookings,
        );

        expect(result, isFalse);
      },
    );

    test(
      'cancelled booking does not block the slot',
      () {
        final bookings = [
          booking(
            id: 'booking-1',
            status: BookingStatus.cancelled,
            scheduledAt: DateTime(
              2026,
              9,
              15,
              15,
              0,
            ),
          ),
        ];

        final result = checker.hasConflict(
          slotStart: DateTime(2026,9,15,15,30,),
          slotDurationMinutes: 60,
          bookings: bookings,
        );

        expect(result, isFalse);
      },
    );

    test(
      'slot immediately after confirmed booking is available',
      () {
        final bookings = [
          booking(
            id: 'booking-1',
            status: BookingStatus.confirmed,
            scheduledAt: DateTime(2026,9,15,15,0,),
          ),
        ];

        final result = checker.hasConflict(
          slotStart: DateTime(2026,9,15,16,0,),
          slotDurationMinutes: 60,
          bookings: bookings,
        );

        expect(result, isFalse);
      },
    );

    test(
      'slot starting before booking but ending during booking conflicts',
      () {
        final bookings = [
          booking(
            id: 'booking-1',
            status: BookingStatus.confirmed,
            scheduledAt: DateTime(2026,9,15,15,30,),
          ),
        ];

        final result = checker.hasConflict(
          slotStart: DateTime(2026,9,15,15,0,),
          slotDurationMinutes: 60,
          bookings: bookings,
        );

        expect(result, isTrue);
      },
    );

    test(
      'slot completely containing confirmed booking conflicts',
      () {
        final bookings = [
          booking(
            id: 'booking-1',
            status: BookingStatus.confirmed,
            scheduledAt: DateTime(2026,9,15,15,30,),
            durationMinutes: 30,
          ),
        ];

        final result = checker.hasConflict(
          slotStart: DateTime(2026,9,15,15,0,),
          slotDurationMinutes: 120,
          bookings: bookings,
        );

        expect(result, isTrue);
      },
    );

    test(
      'returns false when there are no bookings',
      () {
        final result = checker.hasConflict(
          slotStart: DateTime(2026,9,15,15,0,),
          slotDurationMinutes: 60,
          bookings: const [],
        );

        expect(result, isFalse);
      },
    );
  });

  group('removeConflictingSlots', () {
    test(
      'removes only slots that conflict with confirmed bookings',
      () {
        final slots = [
          DateTime(2026, 9, 15, 14, 0),
          DateTime(2026, 9, 15, 14, 30),
          DateTime(2026, 9, 15, 15, 0),
          DateTime(2026, 9, 15, 15, 30),
          DateTime(2026, 9, 15, 16, 0),
        ];

        final bookings = [
          booking(
            id: 'booking-1',
            status: BookingStatus.confirmed,
            scheduledAt: DateTime(
              2026,
              9,
              15,
              15,
              0,
            ),
          ),
        ];

        final result = checker.removeConflictingSlots(
          slots: slots,
          slotDurationMinutes: 60,
          bookings: bookings,
        );

        expect(result, [
          DateTime(2026, 9, 15, 14, 0),
          DateTime(2026, 9, 15, 16, 0),
        ]);
      },
    );

    test(
      'does not remove slots because of pending requests',
      () {
        final slots = [
          DateTime(2026, 9, 15, 15, 0),
          DateTime(2026, 9, 15, 15, 30),
        ];

        final bookings = [
          booking(
            id: 'booking-1',
            status: BookingStatus.pending,
            scheduledAt: DateTime(2026,9,15,15,0,),
          ),
        ];

        final result = checker.removeConflictingSlots(
          slots: slots,
          slotDurationMinutes: 60,
          bookings: bookings,
        );

        expect(result, slots);
      },
    );
  });
}
