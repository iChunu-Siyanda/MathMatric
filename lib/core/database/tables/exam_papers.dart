import 'package:drift/drift.dart';

class ExamPapers extends Table {
  TextColumn get id => text().unique()();
  TextColumn get parentPaperId => text().nullable()();

  TextColumn get paperType => text()();
  TextColumn get session => text()();
  TextColumn get title => text()();
  BoolColumn get isMemo => boolean()();

  TextColumn get storagePath => text()();
  TextColumn get province => text().nullable()();
  BoolColumn get isNational => boolean()();
  IntColumn get year => integer()();
  IntColumn get pageCount => integer()();

  IntColumn get version => integer()();
  BoolColumn get downloaded => boolean()();
}
