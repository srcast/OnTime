import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:on_time/database/tables/configs.dart';
import 'package:on_time/database/tables/hour_value_politics.dart';
import 'package:on_time/database/tables/pontos.dart';
import 'package:on_time/database/tables/session.dart';
import 'package:on_time/database/tables/work.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Pontos, Session, Configurations, HourValuePolitics, Work],
)
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /*   Future<List<Ponto>> obterTodosOsPontos() {
    return select(pontos).get();
  } */
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final dbFolder = Directory('${dir.path}/database');
    if (!await dbFolder.exists()) {
      await dbFolder.create(recursive: true);
    }

    final file = File('${dbFolder.path}/ontimedb.sqlite');
    return NativeDatabase(file);
  });
}
