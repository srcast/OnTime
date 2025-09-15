import 'package:drift/drift.dart';

class HourValuePolitics extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ruleDescription => text()();
  RealColumn get hourValue => real().nullable()();
  TextColumn get dayOffWeek => text().nullable()();
  IntColumn get afterMinutesWorked => integer().nullable()();
  DateTimeColumn get afterSchedule => dateTime().nullable()();
  DateTimeColumn get workStartAt =>
      dateTime().nullable()(); // in use with afterSchedule
}
