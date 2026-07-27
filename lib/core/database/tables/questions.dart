import 'package:drift/drift.dart';

class Questions extends Table {
  TextColumn get id => text().unique()();
  TextColumn get levelId => text()();

  TextColumn get question => text()();
  TextColumn get optionA => text()();
  TextColumn get optionB => text()();
  TextColumn get optionC => text()();
  TextColumn get optionD => text()();

  TextColumn get correctAnswer => text()();
  RealColumn get difficulty => real()();
  TextColumn get explanation => text()();

  IntColumn get version => integer()();
  DateTimeColumn get updatedAt => dateTime()();
}
