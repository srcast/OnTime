import 'package:drift/drift.dart';

class Pontos extends Table {
  IntColumn get id => integer().autoIncrement().unique()();
  DateTimeColumn get date => dateTime()();
  TextColumn get sessionId => text()();
  BoolColumn get getIn => boolean()();
}
