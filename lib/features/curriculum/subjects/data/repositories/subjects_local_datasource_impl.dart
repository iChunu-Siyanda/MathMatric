import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/curriculum/subject_queries.dart';
import 'package:math_matric/features/curriculum/subjects/data/datasource/local/subjects_local_datasource.dart';
import 'package:math_matric/features/curriculum/subjects/data/models/subjects_model.dart';

class SubjectsLocalDatasourceImpl implements SubjectsLocalDataSource{
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
  
  @override
  Future<int> clearSubjects() {
    return db.clearSubjects();
  }
  
  @override
  Future<void> saveSubjects(List<SubjectsModel> subjects) async {
    await db.insertSubjects(
      subjects.map((s) => s.toCompanion(version: 1, updatedAt: DateTime.now())).toList()
    );
  }
}
