import 'package:drift/drift.dart';

class HourValuePolitics extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get hourValue => real().nullable()();
  IntColumn get percentage => integer().nullable()();
  TextColumn get dayOffWeek => text().nullable()();
  IntColumn get afterMinutesWorked => integer().nullable()();
  DateTimeColumn get afterSchedule => dateTime().nullable()();
}
