import 'package:drift/drift.dart';

class DownloadedBundle extends Table{
  TextColumn get id => text().unique()();
  IntColumn get version => integer()();
  DateTimeColumn get downloadedAt => dateTime()();
}
