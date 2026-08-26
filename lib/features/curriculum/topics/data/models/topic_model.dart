import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/ui/practice/domain/entities/practice_topic.dart';

class TopicModel extends PracticeTopic {
  const TopicModel({
    required super.id,
    required super.subjectId,
    required super.title,
    required super.description,
    required super.order,
    required super.totalLevels,
    required super.totalXp,
    required super.colorHex,
  });

  factory TopicModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return TopicModel(
      id: (json['id'] as String?) ?? docId,
      subjectId: (json['subjectId'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      totalLevels: (json['totalLevels'] as num?)?.toInt() ?? 0,
      totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
      colorHex: (json['colorHex'] as String?) ?? '#000000',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'subjectId': subjectId,
      'title': title,
      'description': description,
      'order': order,
      'totalLevels': totalLevels,
      'totalXp': totalXp,
      'colorHex': colorHex,
    };
  }

  PracticeTopic toEntity() {
    return PracticeTopic(
      id: id,
      subjectId: subjectId,
      title: title,
      description: description,
      order: order,
      totalLevels: totalLevels,
      totalXp: totalXp,
      colorHex: colorHex,
    );
  }
  
  factory TopicModel.fromEntity(PracticeTopic topic) {
    return TopicModel(
      id: topic.id, 
      subjectId: topic.subjectId, 
      title: topic.title, 
      description: topic.description, 
      order: topic.order, 
      totalLevels: topic.totalLevels, 
      totalXp: topic.totalXp, 
      colorHex: topic.colorHex,
    );
  }

  factory TopicModel.fromDrift(Topic topic) {
    return TopicModel(
      id: topic.topicId,
      subjectId: topic.subjectId,
      title: topic.title,
      description: topic.description,
      order: topic.order,
      totalLevels: topic.totalLevels,
      totalXp: topic.totalXp,
      colorHex: topic.colorHex,
    );
  }

  //Model -> Drift
  TopicsCompanion toCompanion({
    required int version,
    required DateTime updatedAt,
  }) {
    return TopicsCompanion.insert(
      topicId: id,
      subjectId: subjectId,
      title: title,
      description: description,
      order: order,
      totalLevels: totalLevels,
      totalXp: totalXp,
      colorHex: colorHex,
      version: version,
      updatedAt: updatedAt,
    );
  }
}
