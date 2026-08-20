import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/features/progress/services/user_progress_calculator.dart';

void main() {
  const calculator = UserProgressCalculator();

  group('UserProgressCalculator', () {
    // LEVEL:
    test('level is completed at exactly 80%', () {
      expect(
        calculator.isLevelCompleted(accuracy: 80),
        true,
      );
    });

    test('level is completed above 80%', () {
      expect(
        calculator.isLevelCompleted(accuracy: 95),
        true,
      );
    });

    test('level is not completed below 80%', () {
      expect(
        calculator.isLevelCompleted(accuracy: 79.9),
        false,
      );
    });

    // BESTSCORE:
    test('higher score produces a new best', () {
      expect(
        calculator.isNewBestScore(
          currentBest: 80,
          newScore: 90,
        ),
        true,
      );
    });

    test('lower score does not produce a new best', () {
      expect(
        calculator.isNewBestScore(
          currentBest: 90,
          newScore: 80,
        ),
        false,
      );
    });

    // BEST SCORE (SCORE + TIME):
    test('equal score with faster time produces a new best', () {
      expect(
        calculator.isNewBest(
          currentBestScore: 90,
          currentBestTime: 120,
          newScore: 90,
          newTime: 100,
        ),
        true,
      );
    });

    test('equal score with slower time does not produce a new best', () {
      expect(
        calculator.isNewBest(
          currentBestScore: 90,
          currentBestTime: 100,
          newScore: 90,
          newTime: 120,
        ),
        false,
      );
    });

    test('higher score wins even when slower', () {
      expect(
        calculator.isNewBest(
          currentBestScore: 80,
          currentBestTime: 60,
          newScore: 90,
          newTime: 120,
        ),
        true,
      );
    });

    test('first attempt becomes best when no previous time exists', () {
      expect(
        calculator.isNewBest(
          currentBestScore: 0,
          currentBestTime: null,
          newScore: 80,
          newTime: 120,
        ),
        true,
      );
    });
  
    // MASTERY:
    test('mastery is zero with no attempts', () {
      expect(
        calculator.calculateMastery([]),
        0.0,
      );
    });

    test('one attempt becomes mastery', () {
      expect(
        calculator.calculateMastery([80]),
        80.0,
      );
    });

    test('two attempts use 60/40 weighting', () {
      expect(
        calculator.calculateMastery([70, 90]),
        82.0,
      );
    });

    test('three attempts use 50/30/20 weighting', () {
      expect(
        calculator.calculateMastery([70, 80, 90]),
        83.0,
      );
    });

    test('only the latest three attempts are used', () {
      expect(
        calculator.calculateMastery([40, 50, 60, 70]),
        63.0,
      );
    });
 
    // New Correct Answers:
    test('calculates new correct answers correctly', () {
      final result = calculator.calculateNewCorrectAnswers(
        previouslyCorrectQuestionIds: [
          'q1',
          'q2',
          'q4',
        ],
        currentAnswers: {
          'q1': true,
          'q2': true,
          'q3': true,
          'q4': false,
          'q5': true,
        },
      );

      expect(result, 2);
    });
  
    test('returns zero when there are no new correct answers', () {
      final result = calculator.calculateNewCorrectAnswers(
        previouslyCorrectQuestionIds: [
          'q1',
          'q2',
        ],
        currentAnswers: {
          'q1': true,
          'q2': true,
          'q3': false,
        },
      );

      expect(result, 0);
    });
  });
}
