import 'package:drift/drift.dart';
import 'package:on_time/database/database.dart';

class PointsService {
  final AppDatabase db;

  PointsService(this.db);

  Future<List<Ponto>> getPointsSession(DateTime session) async =>
      await (db.select(db.pontos)
            ..where((p) => p.sessionId.equals(session))
            ..orderBy([
              (p) => OrderingTerm(expression: p.date, mode: OrderingMode.asc),
            ]))
          .get();

  Future<Ponto?> getLastPointSession(DateTime session) async {
    return await (db.select(db.pontos)
          ..where((p) => p.sessionId.equals(session))
          ..orderBy([
            (p) => OrderingTerm(expression: p.date, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> insertPoint(PontosCompanion ponto) async {
    try {
      await db.into(db.pontos).insert(ponto);
    } catch (e, s) {
      print('Exception details:\n $e');
      print('Stack trace:\n $s');
    }
  }

  Future<void> deletePoint(Ponto pointToDelete) async {
    (db.delete(db.pontos)..where((p) => p.id.equals(pointToDelete.id))).go();
  }

  Future<int> updatePonto(PontosCompanion pointToUpdate) async {
    return await (db.update(db.pontos)
      ..where((p) => p.id.equals(pointToUpdate.id.value))).write(pointToUpdate);
  }

  Future<void> insertUpdateSession(
    DateTime sessionDay,
    int minutesWorked,
    double hourValue,
    double profit,
  ) async {
    final existing =
        await (db.select(db.session)
          ..where((s) => s.day.equals(sessionDay))).get();

    if (existing.isEmpty) {
      await db
          .into(db.session)
          .insert(
            SessionCompanion.insert(
              day: sessionDay,
              minutesWorked: minutesWorked,
              hourValue: Value(hourValue),
              profit: Value(profit),
              workId: Value(''),
            ),
          );
    } else {
      await (db.update(db.session)
        ..where((s) => s.day.equals(sessionDay))) // supondo que o id fixo é 1
      .write(
        SessionCompanion(
          minutesWorked: Value(minutesWorked),
          hourValue: Value(hourValue),
          profit: Value(profit),
        ),
      );
    }
  }
}
