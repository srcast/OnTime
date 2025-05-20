import 'package:drift/drift.dart';

class Configurations extends Table {
  IntColumn get id => integer().autoIncrement()();
  //BoolColumn get usesDarkTheme =>
  //    boolean().withDefault(const Constant(false))();
  RealColumn get hourValueBase => real().nullable()();
  RealColumn get taxesPercentage => real().nullable()();
  RealColumn get valuesNotTaxable => real().nullable()();
  RealColumn get extraValue => real().nullable()();
}
