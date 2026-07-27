import 'package:drift/drift.dart';

class Levels extends Table {
  TextColumn get id => text().unique()();
  TextColumn get topicId => text()();

  TextColumn get title => text()();
  TextColumn get subtitle => text()();

  IntColumn get order => integer()();
  IntColumn get xpReward => integer()();

  IntColumn get version => integer()();
  DateTimeColumn get updatedAt => dateTime()();
}
