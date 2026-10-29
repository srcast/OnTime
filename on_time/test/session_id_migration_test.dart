import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/database/migrations/session_id_migration.dart';
import 'package:on_time/helpers/generic_helper.dart';

void main() {
  test('Session id unico para 11 janeiro e 1 novembro', () {
    expect(GenericHelper.getSessionId(DateTime(2025, 1, 11)), '20250111');
    expect(GenericHelper.getSessionId(DateTime(2025, 11, 1)), '20251101');
  });

  test('Datas possiveis de um session id antigo', () {
    expect(SessionIdMigration.legacyCandidates('2025111'), [
      DateTime(2025, 1, 11),
      DateTime(2025, 11, 1),
    ]);
    expect(SessionIdMigration.legacyCandidates('2025110'), [
      DateTime(2025, 1, 10),
    ]);
    expect(SessionIdMigration.legacyCandidates('202515'), [
      DateTime(2025, 1, 5),
    ]);
    expect(SessionIdMigration.legacyCandidates('20251115'), isEmpty);
  });

  test('Migracao v1 -> v2 separa sessoes que colidiram', () async {
    final dir = await Directory.systemTemp.createTemp('ontime_migration');
    final file = File('${dir.path}/db.sqlite');

    // v1 data
    var db = AppDatabase(executor: NativeDatabase(file));
    await db
        .into(db.configurations)
        .insert(
          ConfigurationsCompanion.insert(
            id: Value(1),
            hourValueBase: Value(10),
          ),
        );

    Future<void> point(DateTime date, String sessionId, bool getIn) => db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: date,
            sessionId: sessionId,
            getIn: getIn,
          ),
        );

    // 2025-01-11 and 2025-11-01 share '2025111'
    await point(DateTime(2025, 1, 11, 9), '2025111', true);
    await point(DateTime(2025, 1, 11, 13), '2025111', false);
    await point(DateTime(2025, 11, 1, 9), '2025111', true);
    await point(DateTime(2025, 11, 1, 11), '2025111', false);
    // session through 00h
    await point(DateTime(2025, 1, 5, 22), '202515', true);
    await point(DateTime(2025, 1, 6, 1), '202515', false);
    // already yyyyMMdd
    await point(DateTime(2025, 11, 15, 9), '20251115', true);
    await point(DateTime(2025, 11, 15, 10), '20251115', false);

    Future<void> session(
      String id,
      DateTime day,
      int min,
      double hv,
      double profit,
    ) => db
        .into(db.session)
        .insert(
          SessionCompanion.insert(
            sessionId: id,
            day: day,
            minutesWorked: min,
            hourValue: Value(hv),
            profit: Value(profit),
          ),
        );

    await session('2025111', DateTime(2025, 1, 11), 360, 10, 60); // overwritten
    await session('202515', DateTime(2025, 1, 5), 180, 12, 99);
    await session('20251115', DateTime(2025, 11, 15), 60, 10, 10);

    await db.customStatement('PRAGMA user_version = 1');
    await db.close();

    // reopen -> upgrade runs
    db = AppDatabase(executor: NativeDatabase(file));
    addTearDown(() async {
      await db.close();
      await dir.delete(recursive: true);
    });

    final points =
        await (db.select(db.pontos)
          ..orderBy([(p) => OrderingTerm.asc(p.date)])).get();
    expect(points.map((p) => p.sessionId).toList(), [
      '20250105',
      '20250105',
      '20250111',
      '20250111',
      '20251101',
      '20251101',
      '20251115',
      '20251115',
    ]);
    expect(points.map((p) => p.getIn).toList(), [
      true,
      false,
      true,
      false,
      true,
      false,
      true,
      false,
    ]);

    final sessions = {
      for (final s in await db.select(db.session).get()) s.sessionId: s,
    };
    expect(sessions.keys.toSet(), {
      '20250105',
      '20250111',
      '20251101',
      '20251115',
    });

    // collided -> recalculated
    expect(sessions['20250111']!.minutesWorked, 240);
    expect(sessions['20250111']!.profit, 40);
    expect(sessions['20250111']!.day, DateTime(2025, 1, 11));
    expect(sessions['20251101']!.minutesWorked, 120);
    expect(sessions['20251101']!.profit, 20);
    expect(sessions['20251101']!.day, DateTime(2025, 11, 1));

    // not collided -> stored values kept
    expect(sessions['20250105']!.minutesWorked, 180);
    expect(sessions['20250105']!.hourValue, 12);
    expect(sessions['20250105']!.profit, 99);
    expect(sessions['20251115']!.profit, 10);
  });
}
