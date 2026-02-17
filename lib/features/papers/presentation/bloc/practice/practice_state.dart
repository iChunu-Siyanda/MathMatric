import 'package:math_matric/features/papers/domain/entities/pactice_level.dart';
import 'package:math_matric/features/papers/domain/entities/practice_topic.dart';

abstract class PracticeState {
    const PracticeState();
}

class PracticeInitial extends PracticeState {
    const PracticeInitial();
}

class PracticeLoading extends PracticeState {
    const PracticeLoading();
}

class PracticeLoaded extends PracticeState {
  final PracticeTopic practiceTopic;
  final List<PracticeLevel> levels;
  final int earnedXp;
  final int totalXp;
  final double progress; // 0.0 → 1.0

  PracticeLoaded({
    required this.practiceTopic,
    required this.levels,
    required this.earnedXp,
    required this.totalXp,
    required this.progress, 
  });
}

class PracticeError extends PracticeState {
  final String message;

  PracticeError(this.message);
}
