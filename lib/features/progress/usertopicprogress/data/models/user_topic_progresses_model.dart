import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/entities/user_topic_progresses_entity.dart';

class UserTopicProgressModel extends UserTopicProgressEntity {
  final bool synced;
  final DateTime updatedAt;

  const UserTopicProgressModel({
    required super.id,
    required super.topicId,
    required super.earnedXP,
    required super.mastery,
    required super.lastPlayed,
    required super.favorite, 
    required this.synced, 
    required this.updatedAt,
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
      synced: true,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
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
      'updatedAt': updatedAt.toIso8601String(),
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
      synced: false,
      updatedAt: DateTime.now(),
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
      synced: progress.synced,
      updatedAt: progress.updatedAt,
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
      synced: Value(synced),
      updatedAt: updatedAt,
    );
  }
}
