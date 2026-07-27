import 'package:math_matric/features/curriculum/subjects/data/repositories/subjects_local_datasource_impl.dart';
import 'package:math_matric/features/curriculum/subjects/domain/entities/subjects_entity.dart';
import 'package:math_matric/features/curriculum/subjects/domain/repositories/subjects_repository.dart';

class SubjectsRepositoryImpl extends SubjectsRepository{
  final SubjectsLocalDatasourceImpl local;
  SubjectsRepositoryImpl(this.local);

  @override
  Future<List<SubjectsEntity>> getAllSubjects() {
    return local.getAllSubjects();
  }

  @override
  Future<SubjectsEntity> getSubject(String subjectId) {
    return local.getSubject(subjectId);
  }
}
