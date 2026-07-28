import 'package:math_matric/features/curriculum/subjects/data/models/subjects_model.dart';

abstract class SubjectsLocalDataSource {
  Future<List<SubjectsModel>> getAllSubjects();
  Future<SubjectsModel> getSubject(String subjectId);
  Future<void> saveSubjects(List<SubjectsModel> subjects);
  Future<int> clearSubjects();
}
