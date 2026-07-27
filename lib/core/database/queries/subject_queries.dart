import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';

extension SubjectQueries on AppDatabase{
  Future<bool> hasSubjects() async {
    final count = await (selectOnly(subjects)
          ..addColumns([subjects.id.count()])).getSingle();

    return count.read(subjects.id.count())! > 0;
  }

  //getAllSubjects
  Future<List<Subject>> getAllSubjects(){
    return select(subjects).get();
  }

  //getSubject
  Future<Subject?> getSubject(String subjectId) {
    return (select(subjects)..where((s)=> s.id.equals(subjectId))).getSingleOrNull();
  }

  //insertSubject
  Future<void> insertSubject(SubjectsCompanion subjectsCompanion) {
    return into(subjects).insert(subjectsCompanion);
  }

  //insertSubjects
  Future<void> insertSubjects(List<SubjectsCompanion> subjectCompanionList) {
    return batch((batch){
      batch.insertAll(subjects, subjectCompanionList);
    });
  }

  //updateSubjects
  Future<void> updateSubject(Subject subject){
    return update(subjects).replace(subject);
  }

  //deleteSubject
  Future<int> deleteSubject(String subjectId){
    return (delete(subjects)..where((s) => s.id.equals(subjectId))).go();
  }

  //clear subject table
  Future<void> clearSubject(){
    return delete(subjects).go(); 
  }
}
