import 'package:drift/drift.dart';

class UserLevelProgresses extends Table {
  TextColumn get id => text().unique()();
  TextColumn get levelId => text().unique()();
  TextColumn get topicId => text()();

  BoolColumn get completed => boolean()();
  IntColumn get earnedXP => integer()();
  RealColumn get bestScore => real()();
  IntColumn get attempts => integer()();

  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get lastPlayed => dateTime()();

  BoolColumn get synced => boolean().withDefault(
    const Constant(false),
  )();
  DateTimeColumn get updatedAt => dateTime()();
}
