import 'package:math_matric/features/curriculum/subjects/domain/entities/subjects_entity.dart';

abstract class SubjectsRepository {
  Future<List<SubjectsEntity>> getAllSubjects();
  Future<SubjectsEntity> getSubject(String subjectId);
}
