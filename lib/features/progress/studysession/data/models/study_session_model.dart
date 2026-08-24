import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';

class StudySessionModel extends StudySessionEntity {
  final bool synced;
  final DateTime updatedAt;

  const StudySessionModel({
    required super.id,
    required super.topicId,
    required super.startedAt,
    super.endedAt,
    required super.questionsAnswered,
    required super.correctAnswers,
    required super.earnedXP, 
    required super.activity, 
    required this.synced, 
    required this.updatedAt,
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
      endedAt: json['endedAt'] == null
              ? null
              : DateTime.parse(json['endedAt'] as String,),
      questionsAnswered: json['questionsAnswered'] as int,
      correctAnswers: json['correctAnswers'] as int,
      earnedXP: json['earnedXP'] as int, 
      activity: json['activity'] ?? '',
      synced: true,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'topicId': topicId,
      'activity': activity,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt!.toIso8601String(),
      'questionsAnswered': questionsAnswered,
      'correctAnswers': correctAnswers,
      'earnedXP': earnedXP,
      'updatedAt': updatedAt.toIso8601String(),
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
      activity: activity,
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
      activity: session.activity,
      synced: false,
      updatedAt: DateTime.now(),
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
      activity: session.activity,
      synced: session.synced,
      updatedAt: session.updatedAt,
    );
  }

  StudySessionCompanion toCompanion() {
    return StudySessionCompanion.insert(
      id: id,
      topicId: topicId,
      startedAt: startedAt,
      endedAt: Value(endedAt),
      questionsAnswered: questionsAnswered,
      correctAnswers: correctAnswers,
      earnedXP: earnedXP, 
      activity: activity,
      synced: Value(synced),
      updatedAt: updatedAt,
    );
  }
}
