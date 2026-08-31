import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/marketplace/booking/domain/calculators/bookig_price_calculator.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/teaching_mode.dart';

void main() {
  const calculator = BookingPriceCalculator();

  group('BookingPriceCalculator', () {
    test('calculates online price correctly', () {
      final result = calculator.calculate(
        teachingMode: TeachingMode.online,
        onlinePriceCents: 18000,
        inPersonPriceCents: 25000,
        durationMinutes: 60,
      );

      expect(result, 18000);
    });

    test('calculates in-person price correctly', () {
      final result = calculator.calculate(
        teachingMode: TeachingMode.inPerson,
        onlinePriceCents: 18000,
        inPersonPriceCents: 25000,
        durationMinutes: 60,
      );

      expect(result, 25000);
    });

    test('calculates partial hour correctly', () {
      final result = calculator.calculate(
        teachingMode: TeachingMode.inPerson,
        onlinePriceCents: 18000,
        inPersonPriceCents: 25000,
        durationMinutes: 90,
      );

      expect(result, 37500);
    });

    test('throws when duration is zero', () {
      expect(
        () => calculator.calculate(
          teachingMode: TeachingMode.online,
          onlinePriceCents: 18000,
          inPersonPriceCents: 25000,
          durationMinutes: 0,
        ),
        throwsArgumentError,
      );
    });

    test('throws when duration is negative', () {
      expect(
        () => calculator.calculate(
          teachingMode: TeachingMode.online,
          onlinePriceCents: 18000,
          inPersonPriceCents: 25000,
          durationMinutes: -30,
        ),
        throwsArgumentError,
      );
    });
  });
}
