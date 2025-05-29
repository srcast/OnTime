import 'package:drift/drift.dart';

class Pontos extends Table {
  IntColumn get id => integer().autoIncrement().unique()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get sessionId => dateTime()();
}
