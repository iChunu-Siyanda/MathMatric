import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/topics.dart';
import 'dao/topic_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Topics,
  ],
  daos: [ //DAO = Data Access Object
    TopicDao,
  ]
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
