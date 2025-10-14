import 'package:drift/drift.dart';

class Configurations extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get hourValueBase => real().nullable()();
  TextColumn get themeMode => text().nullable()();
  TextColumn get language => text().nullable()();
  BoolColumn get hasSeenTutorial =>
      boolean().withDefault(const Constant(false))();
}
