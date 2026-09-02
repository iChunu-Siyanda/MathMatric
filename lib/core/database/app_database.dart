import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:math_matric/core/database/tables/class_notes.dart';
import 'package:math_matric/core/database/tables/downloaded_bundle.dart';
import 'package:math_matric/core/database/tables/exam_papers.dart';
import 'package:math_matric/core/database/tables/levels.dart';
import 'package:math_matric/core/database/tables/question_attempts.dart';
import 'package:math_matric/core/database/tables/questions.dart';
import 'package:math_matric/core/database/tables/study_session.dart';
import 'package:math_matric/core/database/tables/user_level_progress.dart';
import 'package:math_matric/core/database/tables/user_topic_progress.dart';
import 'package:math_matric/features/ui/streak/domain/entities/activities.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables/topics.dart';
import 'tables/subjects.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Topics,
    Subjects,
    Questions,
    Levels,
    ExamPapers,
    QuestionAttempts,
    UserLevelProgresses,
    UserTopicProgresses,
    StudySession,
    DownloadedBundle,
    ClassNotes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.test(super.executor);

  Future<bool> hasCurriculumData() async {
    final subjectsCount = await select(subjects).get().then((rows) => rows.length);
    final topicsCount = await select(topics).get().then((rows) => rows.length);
    final papersCount = await select(examPapers).get().then((rows) => rows.length);

    debugPrint('[DB Check] Subjects count: $subjectsCount | Topics count: $topicsCount | Exam Papers count: $papersCount');

    return subjectsCount > 0 && topicsCount > 0 && papersCount > 0;
  }

  Future<void> debugDumpExamPapers() async {
    final allPapers = await select(examPapers).get();
    debugPrint('--- DRIFT DB DUMP (${allPapers.length} total rows) ---');
    for (final paper in allPapers) {
      debugPrint(
        'ID: ${paper.id} | Subject: ${paper.subjectId} | Session: ${paper.session} | Type: ${paper.paperType} | Year: ${paper.year}',
      );
    }
  }
  
  @override
  int get schemaVersion => 4; 
}
//Bump up schemaVersion by +1 if:
// Adding/removing a table
// Adding/removing a column
// Changing a column's definition/type
// Adding/changing indexes or constraints where migration is required

//Not when:
// Adding a query
// Changing a query
// Adding a Dart extension
// Changing repository code
// Changing datasource code
// Changing model conversion logic

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(
      p.join(dir.path, 'math_matric.db'),
    );

    return NativeDatabase.createInBackground(
      file,
      logStatements: true,
    );
  });
}
