import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';

class QuestionAttemptModel extends QuestionAttemptEntity {
  const QuestionAttemptModel({
    required super.id,
    required super.levelId,
    required super.questionId,
    required super.correct,
    required super.timeTaken,
    required super.answeredAt,
  });

  factory QuestionAttemptModel.fromFirestore(
    Map<String, dynamic> json,
  ) {
    return QuestionAttemptModel(
      id: json['id'] as String,
      levelId: json['levelId'] as String,
      questionId: json['questionId'] as String,
      correct: json['correct'] as bool,
      timeTaken: json['timeTaken'] as int,
      answeredAt: DateTime.parse(
        json['answeredAt'] as String,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'levelId': levelId,
      'questionId': questionId,
      'correct': correct,
      'timeTaken': timeTaken,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }

  QuestionAttemptEntity toEntity() {
    return QuestionAttemptEntity(
      id: id,
      levelId: levelId,
      questionId: questionId,
      correct: correct,
      timeTaken: timeTaken,
      answeredAt: answeredAt,
    );
  }

  factory QuestionAttemptModel.fromEntity(
    QuestionAttemptEntity attempt,
  ) {
    return QuestionAttemptModel(
      id: attempt.id,
      levelId: attempt.levelId,
      questionId: attempt.questionId,
      correct: attempt.correct,
      timeTaken: attempt.timeTaken,
      answeredAt: attempt.answeredAt,
    );
  }

  factory QuestionAttemptModel.fromDrift(
    QuestionAttempt attempt,
  ) {
    return QuestionAttemptModel(
      id: attempt.id,
      levelId: attempt.levelId,
      questionId: attempt.questionId,
      correct: attempt.correct,
      timeTaken: attempt.timeTaken,
      answeredAt: attempt.answeredAt,
    );
  }

  QuestionAttemptsCompanion toCompanion() {
    return QuestionAttemptsCompanion.insert(
      id: id,
      levelId: levelId,
      questionId: questionId,
      correct: correct,
      timeTaken: timeTaken,
      answeredAt: answeredAt,
    );
  }
}
