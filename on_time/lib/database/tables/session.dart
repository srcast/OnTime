import 'package:drift/drift.dart';

class Session extends Table {
  TextColumn get sessionId => text().unique()();
  DateTimeColumn get day => dateTime()();
  IntColumn get minutesWorked => integer()();
  RealColumn get hourValue => real().withDefault(const Constant(0))();
  RealColumn get profit => real().withDefault(const Constant(0))();
  TextColumn get workId => text().nullable()();
}
