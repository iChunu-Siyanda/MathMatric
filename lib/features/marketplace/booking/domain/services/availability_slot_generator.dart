import 'package:math_matric/features/marketplace/booking/domain/entities/availability_window.dart';

class AvailabilitySlotGenerator {
  const AvailabilitySlotGenerator();

  List<DateTime> generateSlots({
    required DateTime date,
    required int durationMinutes,
    required List<AvailabilityWindow> windows,
    int intervalMinutes = 30,
  }) {
    final slots = <DateTime>[];

    for (final window in windows) {
      final start = _combine(
        date,
        window.start,
      );

      final availabilityEnd = _combine(
        date,
        window.end,
      );

      var current = start;

      while (
        current.add(Duration(minutes: durationMinutes,),).compareTo(availabilityEnd) <= 0
      ) {
        slots.add(current);

        current = current.add(
          Duration(minutes: intervalMinutes,),
        );
      }
    }

    return slots;
  }

  DateTime _combine(
    DateTime date,
    String time,
  ) {
    final parts = time.split(':');

    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}
