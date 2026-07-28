import 'package:drift/drift.dart';

class StudySession extends Table {
  TextColumn get id => text().unique()();
  TextColumn get topicId => text()();

  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();

  IntColumn get questionsAnswered => integer()();
  IntColumn get correctAnswers => integer()();
  IntColumn get earnedXP => integer()();
}
