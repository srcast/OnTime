import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/services/points_service.dart';

void main() {
  late AppDatabase db;
  late PointsService service;

  setUp(() async {
    db = AppDatabase(executor: NativeDatabase.memory());
    service = PointsService(db);
    await db
        .into(db.configurations)
        .insert(
          ConfigurationsCompanion.insert(
            id: Value(1),
            hourValueBase: Value(10),
          ),
        );
  });

  tearDown(() => db.close());

  Future<List<Ponto>> allPoints() =>
      (db.select(db.pontos)..orderBy([(p) => OrderingTerm.asc(p.date)])).get();

  test('Registar pontos recalcula a sessao', () async {
    await service.insertPoint(
      DateTime(2026, 11, 3, 9, 0, 45),
    ); // seconds ignored
    await service.insertPoint(DateTime(2026, 11, 3, 13));

    final points = await allPoints();
    expect(points.map((p) => p.getIn), [true, false]);
    expect(points.first.date, DateTime(2026, 11, 3, 9));

    final session = (await service.getSessionData('20261103'))!;
    expect(session.day, DateTime(2026, 11, 3)); // midnight
    expect(session.minutesWorked, 240);
    expect(session.profit, 40);
    expect(session.hourValue, 10);
  });

  test('Sessao que passa a meia-noite fica no dia em que comecou', () async {
    await service.insertPoint(DateTime(2026, 11, 3, 22));
    await service.insertPoint(DateTime(2026, 11, 4, 2));

    final points = await allPoints();
    expect(points.map((p) => p.sessionId), ['20261103', '20261103']);
    expect((await service.getSessionData('20261103'))!.minutesWorked, 240);
    expect(await service.getSessionData('20261104'), isNull);
  });

  test('Apagar pontos recalcula e apaga a sessao vazia', () async {
    await service.insertPoint(DateTime(2026, 11, 3, 9));
    await service.insertPoint(DateTime(2026, 11, 3, 13));
    await service.insertPoint(DateTime(2026, 11, 3, 14));

    // deletes the 13:00 -> 14:00 becomes the get out
    await service.deletePoint((await allPoints())[1]);
    var points = await allPoints();
    expect(points.map((p) => p.getIn), [true, false]);
    expect((await service.getSessionData('20261103'))!.minutesWorked, 300);

    for (final point in points) {
      await service.deletePoint(point);
    }
    expect(await service.getSessionData('20261103'), isNull);
  });

  // the edit modal only changes the hour -> session only changes around 00h (6 hours rule)
  test(
    'Editar a hora de um ponto apos a meia-noite reavalia a sessao',
    () async {
      await service.insertPoint(DateTime(2026, 11, 3, 22));
      await service.insertPoint(DateTime(2026, 11, 4, 2)); // session of day 3
      await service.insertPoint(DateTime(2026, 11, 4, 9)); // 7h later -> day 4

      // 02:00 -> 08:00: 10h after 22:00 -> belongs to day 4
      final out = (await allPoints())[1];
      await service.updatePoint(out, DateTime(2026, 11, 4, 8));

      var points = await allPoints();
      expect(points.map((p) => p.sessionId), [
        '20261103',
        '20261104',
        '20261104',
      ]);
      expect(points.map((p) => p.getIn), [true, true, false]);
      expect((await service.getSessionData('20261103'))!.minutesWorked, 0);
      final day4 = (await service.getSessionData('20261104'))!;
      expect(day4.minutesWorked, 60);
      expect(day4.profit, 10);

      // back to 01:00: 3h after 22:00 -> belongs to day 3 again
      await service.updatePoint(points[1], DateTime(2026, 11, 4, 1));

      points = await allPoints();
      expect(points.map((p) => p.sessionId), [
        '20261103',
        '20261103',
        '20261104',
      ]);
      expect((await service.getSessionData('20261103'))!.minutesWorked, 180);
      expect((await service.getSessionData('20261104'))!.minutesWorked, 0);
    },
  );

  test('Erro no calculo desfaz tudo (rollback)', () async {
    await service.insertPoint(DateTime(2026, 11, 3, 9));

    // after schedule rule without "work starts at" -> calculation fails
    await db
        .into(db.hourValuePolitics)
        .insert(
          HourValuePoliticsCompanion.insert(
            ruleDescription: 'invalid',
            hourValue: Value(15),
            afterSchedule: Value(DateTime(2026, 1, 1, 22)),
          ),
        );

    await expectLater(
      service.insertPoint(DateTime(2026, 11, 3, 13)),
      throwsA(anything),
    );

    // only the first point, session as before
    expect((await allPoints()).length, 1);
    expect((await service.getSessionData('20261103'))!.minutesWorked, 0);
  });
}
