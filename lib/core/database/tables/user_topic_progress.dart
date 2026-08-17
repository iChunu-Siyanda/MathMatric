import 'package:drift/drift.dart';

class UserTopicProgresses extends Table {
  TextColumn get id => text().unique()();
  TextColumn get topicId => text().unique()();

  IntColumn get earnedXP => integer()();
  RealColumn get mastery => real()();
  DateTimeColumn get lastPlayed => dateTime()();
  BoolColumn get favorite => boolean()();

  BoolColumn get synced => boolean().withDefault(
    const Constant(false),
  )();
  DateTimeColumn get updatedAt => dateTime()();
}
