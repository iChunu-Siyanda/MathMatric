import 'package:drift/drift.dart';

class ClassNotes extends Table {
  TextColumn get id => text()();

  TextColumn get topicId => text()();

  TextColumn get title => text()();

  TextColumn get content => text()();

  IntColumn get order => integer()();

  IntColumn get version => integer()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
