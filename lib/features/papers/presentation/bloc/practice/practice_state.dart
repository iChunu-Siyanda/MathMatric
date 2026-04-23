import 'package:math_matric/features/papers/domain/usercases/practice_topic_data.dart';

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
  final PracticeTopicData data;

  PracticeLoaded(this.data);
}

class PracticeError extends PracticeState {
  final String message;

  PracticeError(this.message);
}
