import 'package:drift/drift.dart';

class Pontos extends Table {
  DateTimeColumn get date => dateTime().unique()();
  BoolColumn get getIn => boolean().withDefault(const Constant(true))();
  DateTimeColumn get sessionId => dateTime()();
}
