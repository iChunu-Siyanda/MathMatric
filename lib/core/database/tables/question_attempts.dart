import 'package:drift/drift.dart';

class QuestionAttempts extends Table {
  TextColumn get id => text().unique()();

  TextColumn get levelId => text()();
  TextColumn get questionId => text()();

  BoolColumn get correct => boolean()();

  IntColumn get timeTaken => integer()(); // seconds
  DateTimeColumn get answeredAt => dateTime()();
}
