import 'package:drift/drift.dart';

class Work extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get designation => text().nullable()();
}
