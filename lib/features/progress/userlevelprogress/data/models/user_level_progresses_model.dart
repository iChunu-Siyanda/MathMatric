import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';

class UserLevelProgressModel extends UserLevelProgressEntity {
  final bool synced;
 final DateTime updatedAt;

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
    required this.synced, 
    required this.updatedAt,
    super.bestTime,
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
      synced: true,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      bestTime: json['bestTime'] as int,
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
      'updatedAt': updatedAt.toIso8601String(),
      'bestTime': bestTime,
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
      bestTime: bestTime,
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
      synced: false,
      updatedAt: DateTime.now(),
      bestTime: progress.bestTime,
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
      synced: progress.synced,
      updatedAt: progress.updatedAt,
      bestTime: progress.bestTime,
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
      synced: Value(synced),
      updatedAt: updatedAt,
      bestTime: Value(bestTime!),
    );
  }
}
