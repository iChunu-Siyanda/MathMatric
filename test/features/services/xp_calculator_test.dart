import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/progress/services/xp_calculator.dart';

void main() {
  const calculator = XPCalculator();

  group('XPCalculator', () {
    test('first pass at 80% awards 130 XP', () {
      final result = calculator.calculate(
        firstPass: true,
        correctAnswers: 8,
        newCorrectAnswers: 0,
        newBestTime: false,
        perfect: false,
      );

      expect(result.xp, 130);
    });

    test('first pass at 100% awards 200 XP', () {
      final result = calculator.calculate(
        firstPass: true,
        correctAnswers: 10,
        newCorrectAnswers: 0,
        newBestTime: false,
        perfect: true,
      );

      expect(result.xp, 200);
    });

    test('replay with no improvement awards 0 XP', () {
      final result = calculator.calculate(
        firstPass: false,
        correctAnswers: 8,
        newCorrectAnswers: 0,
        newBestTime: false,
        perfect: false,
      );

      expect(result.xp, 0);
    });

    test('replay awards 5 XP per new correct answer', () {
      final result = calculator.calculate(
        firstPass: false,
        correctAnswers: 9,
        newCorrectAnswers: 2,
        newBestTime: false,
        perfect: false,
      );

      expect(result.xp, 10);
    });

    test('replay awards 5 XP for a new best time', () {
      final result = calculator.calculate(
        firstPass: false,
        correctAnswers: 8,
        newCorrectAnswers: 0,
        newBestTime: true,
        perfect: false,
      );

      expect(result.xp, 5);
    });

    test('replay awards XP for both new correct answers and new best time', () {
      final result = calculator.calculate(
        firstPass: false,
        correctAnswers: 10,
        newCorrectAnswers: 3,
        newBestTime: true,
        perfect: false,
      );

      expect(result.xp, 20);
    });

    test('first pass with zero correct answers awards base XP only', () {
      final result = calculator.calculate(
        firstPass: true,
        correctAnswers: 0,
        newCorrectAnswers: 0,
        newBestTime: false,
        perfect: false,
      );

      expect(result.xp, 50);
    });
  });
}
