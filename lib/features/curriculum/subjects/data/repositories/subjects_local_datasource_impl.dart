import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/subject_queries.dart';
import 'package:math_matric/features/curriculum/subjects/data/datasource/local/subjects_local_datasource.dart';
import 'package:math_matric/features/curriculum/subjects/data/models/subjects_model.dart';

class SubjectsLocalDatasourceImpl implements SubjectsLocalDatasource{
  final AppDatabase db;
  SubjectsLocalDatasourceImpl(this.db);

  @override
  Future<List<SubjectsModel>> getAllSubjects() async {
    final models = await db.getAllSubjects();
    return models.map((m) => SubjectsModel.fromDrift(m)).toList();
  }

  @override
  Future<SubjectsModel> getSubject(String subjectId) async {
    final model = await db.getSubject(subjectId);
    return SubjectsModel.fromDrift(model!);
  }
}
