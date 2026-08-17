import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/streak/domain/entities/activities.dart';

class StudySessionEntity {
  final String id;
  final String topicId;
  final StudyActivity activity;

  final DateTime startedAt;
  final DateTime endedAt;

  final int questionsAnswered;
  final int correctAnswers;
  final int earnedXP;

  const StudySessionEntity({
    required this.id,
    required this.topicId,
    required this.startedAt,
    required this.endedAt,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.earnedXP, 
    required this.activity,
  });

  StudySessionData toDrift(){
    return StudySessionData(
      id: id, 
      topicId: topicId, 
      activity: activity, 
      startedAt: startedAt, 
      endedAt: endedAt, 
      questionsAnswered: questionsAnswered, 
      correctAnswers: correctAnswers, 
      earnedXP: earnedXP, 
      synced: false, 
      updatedAt: DateTime.now(),
    );
  }
}
