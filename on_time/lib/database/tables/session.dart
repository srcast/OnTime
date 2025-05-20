import 'package:drift/drift.dart';

class Session extends Table {
  DateTimeColumn get day => dateTime().unique()();
  IntColumn get minutesWorked => integer()();
  RealColumn get hourValue => real().withDefault(const Constant(0))();
  RealColumn get profit => real().withDefault(const Constant(0))();
  TextColumn get workId => text().nullable()();
}
