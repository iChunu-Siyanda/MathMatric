import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/curriculum/levels/domain/entities/levels_entity.dart';

class LevelsModel extends LevelsEntity {
  const LevelsModel({
    required super.id,
    required super.topicId,
    required super.title,
    required super.subtitle,
    required super.order,
    required super.xpReward,
  });

  factory LevelsModel.fromFirestore(Map<String, dynamic> json) {
    return LevelsModel(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      order: json['order'] as int,
      xpReward: json['xpReward'] as int,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'topicId': topicId,
      'title': title,
      'subtitle': subtitle,
      'order': order,
      'xpReward': xpReward,
    };
  }

  LevelsEntity toEntity() {
    return LevelsEntity(
      id: id,
      topicId: topicId,
      title: title,
      subtitle: subtitle,
      order: order,
      xpReward: xpReward,
    );
  }

  factory LevelsModel.fromEntity(LevelsEntity level) {
    return LevelsModel(
      id: level.id,
      topicId: level.topicId,
      title: level.title,
      subtitle: level.subtitle,
      order: level.order,
      xpReward: level.xpReward,
    );
  }

  factory LevelsModel.fromDrift(Level level) {
    return LevelsModel(
      id: level.id,
      topicId: level.topicId,
      title: level.title,
      subtitle: level.subtitle,
      order: level.order,
      xpReward: level.xpReward,
    );
  }

  // Model -> Drift
  LevelsCompanion toCompanion({
    required int version,
    required DateTime updatedAt,
  }) {
    return LevelsCompanion.insert(
      id: id,
      topicId: topicId,
      title: title,
      subtitle: subtitle,
      order: order,
      xpReward: xpReward,
      version: version,
      updatedAt: updatedAt,
    );
  }
}
