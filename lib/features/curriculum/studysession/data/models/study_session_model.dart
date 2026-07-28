import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/curriculum/studysession/domain/entities/study_session_entity.dart';

class StudySessionModel extends StudySessionEntity {
  const StudySessionModel({
    required super.id,
    required super.topicId,
    required super.startedAt,
    required super.endedAt,
    required super.questionsAnswered,
    required super.correctAnswers,
    required super.earnedXP,
  });

  factory StudySessionModel.fromFirestore(
    Map<String, dynamic> json,
  ) {
    return StudySessionModel(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      startedAt: DateTime.parse(
        json['startedAt'] as String,
      ),
      endedAt: DateTime.parse(
        json['endedAt'] as String,
      ),
      questionsAnswered: json['questionsAnswered'] as int,
      correctAnswers: json['correctAnswers'] as int,
      earnedXP: json['earnedXP'] as int,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'topicId': topicId,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt.toIso8601String(),
      'questionsAnswered': questionsAnswered,
      'correctAnswers': correctAnswers,
      'earnedXP': earnedXP,
    };
  }

  StudySessionEntity toEntity() {
    return StudySessionEntity(
      id: id,
      topicId: topicId,
      startedAt: startedAt,
      endedAt: endedAt,
      questionsAnswered: questionsAnswered,
      correctAnswers: correctAnswers,
      earnedXP: earnedXP,
    );
  }

  factory StudySessionModel.fromEntity(
    StudySessionEntity session,
  ) {
    return StudySessionModel(
      id: session.id,
      topicId: session.topicId,
      startedAt: session.startedAt,
      endedAt: session.endedAt,
      questionsAnswered: session.questionsAnswered,
      correctAnswers: session.correctAnswers,
      earnedXP: session.earnedXP,
    );
  }

  factory StudySessionModel.fromDrift(
    StudySessionData session,
  ) {
    return StudySessionModel(
      id: session.id,
      topicId: session.topicId,
      startedAt: session.startedAt,
      endedAt: session.endedAt,
      questionsAnswered: session.questionsAnswered,
      correctAnswers: session.correctAnswers,
      earnedXP: session.earnedXP,
    );
  }

  StudySessionCompanion toCompanion() {
    return StudySessionCompanion.insert(
      id: id,
      topicId: topicId,
      startedAt: startedAt,
      endedAt: endedAt,
      questionsAnswered: questionsAnswered,
      correctAnswers: correctAnswers,
      earnedXP: earnedXP,
    );
  }
}
