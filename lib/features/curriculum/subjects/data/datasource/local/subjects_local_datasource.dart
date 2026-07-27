import 'package:math_matric/features/curriculum/subjects/data/models/subjects_model.dart';

abstract class SubjectsLocalDatasource {
  Future<List<SubjectsModel>> getAllSubjects();
  Future<SubjectsModel> getSubject(String subjectId);
}
