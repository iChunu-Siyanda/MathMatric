import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/curriculum/subjects/domain/entities/subjects_entity.dart';

class SubjectsModel extends SubjectsEntity{
  const SubjectsModel({
    required super.id, 
    required super.name, 
    required super.grade,
  });

  Map<String,dynamic> toFirestore(){
    return {
      'id': id,
      'name': name,
      'grade': grade,
    };
  }

  factory SubjectsModel.fromFirestore(Map<String,dynamic> json){
    return SubjectsModel(
      id: json['id'] ?? '', 
      name: json['name'] ?? '', 
      grade: json['grade'] ?? '',
    );
  }

  SubjectsEntity toEntity() {
    return SubjectsEntity(id: id, name: name, grade: grade);
  }

  factory SubjectsModel.fromEntity(SubjectsEntity subject) {
    return SubjectsModel(id: subject.id, name: subject.name, grade: subject.grade);
  }

  factory SubjectsModel.fromDrift(Subject subject){
    return SubjectsModel(id: subject.id, name: subject.name, grade: subject.grade);
  }

  SubjectsCompanion toCompanion({
    required int version,
    required DateTime updatedAt,
  }){
    return SubjectsCompanion.insert(
      id: id, 
      name: name, 
      grade: grade, 
      updatedAt: updatedAt, 
      version: version,
    );
  }
}
