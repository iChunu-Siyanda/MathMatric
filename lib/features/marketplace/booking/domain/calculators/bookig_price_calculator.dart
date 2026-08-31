import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';

class BookingPriceCalculator {
  const BookingPriceCalculator();

  int calculate({
    required TeachingMode teachingMode,
    required int onlinePriceCents,
    required int inPersonPriceCents,
    required int durationMinutes,
  }) {
    if (durationMinutes <= 0) {
      throw ArgumentError('Duration must be greater than zero.',);
    }

    final hourlyPriceCents = teachingMode == TeachingMode.online
                          ? onlinePriceCents
                          : inPersonPriceCents;

    return (hourlyPriceCents * durationMinutes) ~/ 60;
  }
}
