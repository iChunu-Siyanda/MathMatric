import 'package:drift/drift.dart';

class Topics extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get topicId => text().unique()();
  TextColumn get subjectId => text()();

  TextColumn get title => text()();
  TextColumn get description => text()();

  IntColumn get order => integer()();
  IntColumn get totalLevels => integer()();
  IntColumn get totalXp => integer()();
  
  TextColumn get colorHex => text()();
  IntColumn get version => integer()();

  DateTimeColumn get updatedAt => dateTime()();
}
