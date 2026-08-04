import 'package:drift/drift.dart';
import 'package:math_matric/features/streak/domain/entities/activities.dart';

class StudySession extends Table {
  TextColumn get id => text().unique()();
  TextColumn get topicId => text()();
  TextColumn get activity => textEnum<StudyActivity>()();

  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();

  IntColumn get questionsAnswered => integer()();
  IntColumn get correctAnswers => integer()();
  IntColumn get earnedXP => integer()();
}
