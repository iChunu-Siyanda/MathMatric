import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:math_matric/core/database/tables/downloaded_bundle.dart';
import 'package:math_matric/core/database/tables/exam_papers.dart';
import 'package:math_matric/core/database/tables/levels.dart';
import 'package:math_matric/core/database/tables/question_attempts.dart';
import 'package:math_matric/core/database/tables/questions.dart';
import 'package:math_matric/core/database/tables/study_session.dart';
import 'package:math_matric/core/database/tables/user_level_progress.dart';
import 'package:math_matric/core/database/tables/user_topic_progress.dart';
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(
      p.join(dir.path, 'math_matric.db'),
    );

    return NativeDatabase(file);
  });
}
