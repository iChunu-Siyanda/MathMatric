import 'package:math_matric/features/marketplace/booking/domain/entities/booking_entity.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/booking_status.dart';

class BookingConflictChecker {
  const BookingConflictChecker();

  bool hasConflict({
    required DateTime slotStart,
    required int slotDurationMinutes,
    required List<BookingEntity> bookings,
  }) {
    final slotEnd = slotStart.add(
      Duration(minutes: slotDurationMinutes),
    );

    return bookings.any((booking) {
      if (booking.status != BookingStatus.confirmed) {
        return false;
      }

      final bookingStart = booking.scheduledAt;

      final bookingEnd = bookingStart.add(
        Duration(
          minutes: booking.durationMinutes,
        ),
      );

      return slotStart.isBefore(bookingEnd) && slotEnd.isAfter(bookingStart);
    });
  }

  List<DateTime> removeConflictingSlots({
    required List<DateTime> slots,
    required int slotDurationMinutes,
    required List<BookingEntity> bookings,
  }) {
    return slots.where((slot) {
      return !hasConflict(
        slotStart: slot,
        slotDurationMinutes: slotDurationMinutes,
        bookings: bookings,
      );
    }).toList();
  }
}
