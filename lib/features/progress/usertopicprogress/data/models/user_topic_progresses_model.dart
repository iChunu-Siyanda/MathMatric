import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';

class UserTopicProgressModel extends UserTopicProgressEntity {
  const UserTopicProgressModel({
    required super.id,
    required super.topicId,
    required super.earnedXP,
    required super.mastery,
    required super.lastPlayed,
    required super.favorite,
  });

  factory UserTopicProgressModel.fromFirestore(
    Map<String, dynamic> json,
  ) {
    return UserTopicProgressModel(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      earnedXP: json['earnedXP'] as int,
      mastery: (json['mastery'] as num).toDouble(),
      lastPlayed: DateTime.parse(
        json['lastPlayed'] as String,
      ),
      favorite: json['favorite'] as bool,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'topicId': topicId,
      'earnedXP': earnedXP,
      'mastery': mastery,
      'lastPlayed': lastPlayed.toIso8601String(),
      'favorite': favorite,
    };
  }

  UserTopicProgressEntity toEntity() {
    return UserTopicProgressEntity(
      id: id,
      topicId: topicId,
      earnedXP: earnedXP,
      mastery: mastery,
      lastPlayed: lastPlayed,
      favorite: favorite,
    );
  }

  factory UserTopicProgressModel.fromEntity(
    UserTopicProgressEntity progress,
  ) {
    return UserTopicProgressModel(
      id: progress.id,
      topicId: progress.topicId,
      earnedXP: progress.earnedXP,
      mastery: progress.mastery,
      lastPlayed: progress.lastPlayed,
      favorite: progress.favorite,
    );
  }

  factory UserTopicProgressModel.fromDrift(
    UserTopicProgressesData progress,
  ) {
    return UserTopicProgressModel(
      id: progress.id,
      topicId: progress.topicId,
      earnedXP: progress.earnedXP,
      mastery: progress.mastery,
      lastPlayed: progress.lastPlayed,
      favorite: progress.favorite,
    );
  }

  UserTopicProgressesCompanion toCompanion() {
    return UserTopicProgressesCompanion.insert(
      id: id,
      topicId: topicId,
      earnedXP: earnedXP,
      mastery: mastery,
      lastPlayed: lastPlayed,
      favorite: favorite,
    );
  }
}
