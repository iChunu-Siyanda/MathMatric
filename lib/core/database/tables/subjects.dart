import 'package:drift/drift.dart';

class Subjects extends Table {
  TextColumn get id => text().unique()();
  TextColumn get name => text()();
  IntColumn get grade => integer()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer()();
}
