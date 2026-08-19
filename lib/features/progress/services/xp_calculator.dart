import 'package:math_matric/features/progress/services/xp_results.dart';

class XPCalculator {
  const XPCalculator();

  XPResult calculate({
    required bool firstPass,
    required int correctAnswers,
    required int newCorrectAnswers,
    required bool newBestTime,
    required bool perfect,
  }) {
    if (firstPass) {
      final baseXP = 50;
      final accuracyXP = correctAnswers * 10;
      final perfectXP = perfect ? 50 : 0;

      return XPResult(
        xp: baseXP + accuracyXP + perfectXP,
        firstPass: true,
        newCorrectAnswers: newCorrectAnswers,
        newBestTime: newBestTime,
      );
    }

    final replayXP = (newCorrectAnswers * 5) + (newBestTime ? 5 : 0);

    return XPResult(
      xp: replayXP,
      firstPass: false,
      newCorrectAnswers: newCorrectAnswers,
      newBestTime: newBestTime,
    );
  }
}
