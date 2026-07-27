import 'package:math_matric/features/curriculum/subjects/data/models/subjects_model.dart';

abstract class SubjectsRemoteDataSource {
  Future<List<SubjectsModel>> downloadSubjects();
}
