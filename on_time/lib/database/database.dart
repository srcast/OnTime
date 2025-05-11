import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// when db structure is change, need to run dart run build_runner build

class Pontos extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get entrada => dateTime()();
  DateTimeColumn get saida => dateTime().nullable()();
  RealColumn get horasTrabalhadas => real().nullable()();
}

@DriftDatabase(tables: [Pontos])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'ontimedb',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  // Função para obter todos os pontos
  Future<List<Ponto>> obterTodosOsPontos() {
    return select(pontos).get();
  }
}
