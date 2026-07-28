import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';

class UserLevelProgressModel extends UserLevelProgressEntity {
  const UserLevelProgressModel({
    required super.id,
    required super.levelId,
    required super.topicId,
    required super.completed,
    required super.earnedXP,
    required super.bestScore,
    required super.attempts,
    required super.completedAt,
    required super.lastPlayed,
  });

  factory UserLevelProgressModel.fromFirestore(
    Map<String, dynamic> json,
  ) {
    return UserLevelProgressModel(
      id: json['id'] as String,
      levelId: json['levelId'] as String,
      topicId: json['topicId'] as String,
      completed: json['completed'] as bool,
      earnedXP: json['earnedXP'] as int,
      bestScore: (json['bestScore'] as num).toDouble(),
      attempts: json['attempts'] as int,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      lastPlayed: DateTime.parse(
        json['lastPlayed'] as String,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'levelId': levelId,
      'topicId': topicId,
      'completed': completed,
      'earnedXP': earnedXP,
      'bestScore': bestScore,
      'attempts': attempts,
      'completedAt': completedAt?.toIso8601String(),
      'lastPlayed': lastPlayed.toIso8601String(),
    };
  }

  UserLevelProgressEntity toEntity() {
    return UserLevelProgressEntity(
      id: id,
      levelId: levelId,
      topicId: topicId,
      completed: completed,
      earnedXP: earnedXP,
      bestScore: bestScore,
      attempts: attempts,
      completedAt: completedAt,
      lastPlayed: lastPlayed,
    );
  }

  factory UserLevelProgressModel.fromEntity(
    UserLevelProgressEntity progress,
  ) {
    return UserLevelProgressModel(
      id: progress.id,
      levelId: progress.levelId,
      topicId: progress.topicId,
      completed: progress.completed,
      earnedXP: progress.earnedXP,
      bestScore: progress.bestScore,
      attempts: progress.attempts,
      completedAt: progress.completedAt,
      lastPlayed: progress.lastPlayed,
    );
  }

  factory UserLevelProgressModel.fromDrift(
    UserLevelProgressesData progress,
  ) {
    return UserLevelProgressModel(
      id: progress.id,
      levelId: progress.levelId,
      topicId: progress.topicId,
      completed: progress.completed,
      earnedXP: progress.earnedXP,
      bestScore: progress.bestScore,
      attempts: progress.attempts,
      completedAt: progress.completedAt,
      lastPlayed: progress.lastPlayed,
    );
  }

  UserLevelProgressesCompanion toCompanion() {
    return UserLevelProgressesCompanion.insert(
      id: id,
      levelId: levelId,
      topicId: topicId,
      completed: completed,
      earnedXP: earnedXP,
      bestScore: bestScore,
      attempts: attempts,
      completedAt: Value(completedAt),
      lastPlayed: lastPlayed,
    );
  }
}
