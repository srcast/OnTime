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
}
