import 'package:drift/drift.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';

class PointsService {
  final AppDatabase db;

  PointsService(this.db);

  Future<List<Ponto>> getPointsSession(DateTime sessionDate) async {
    var id = GenericHelper.getSessionId(sessionDate);

    return await (db.select(db.pontos)
          ..where((p) => p.sessionId.equals(id))
          ..orderBy([
            (p) => OrderingTerm(expression: p.date, mode: OrderingMode.asc),
          ]))
        .get();
  }

  Future<List<Ponto>> getDayPointsForUI(DateTime sessionDate) async {
    return await (db.select(db.pontos)
          ..where(
            (p) =>
                p.date.isBiggerOrEqualValue(sessionDate) &
                p.date.isSmallerOrEqualValue(
                  sessionDate.add(Duration(hours: 23, minutes: 59)),
                ),
          )
          ..orderBy([
            (p) => OrderingTerm(expression: p.date, mode: OrderingMode.asc),
          ]))
        .get();
  }

  // Future<Ponto?> getLastPointSession(DateTime session) async {
  //   return await (db.select(db.pontos)
  //         ..where((p) => p.sessionId.equals(session))
  //         ..orderBy([
  //           (p) => OrderingTerm(expression: p.date, mode: OrderingMode.desc),
  //         ])
  //         ..limit(1))
  //       .getSingleOrNull();
  // }

  Future<void> insertPoint(DateTime date) async {
    try {
      // verify session with last point
      DateTime interval = date.add(Duration(hours: -6));

      var lastPoint =
          await (db.select(db.pontos)
                ..orderBy([(t) => OrderingTerm.desc(t.date)])
                ..limit(1))
              .getSingleOrNull();
      bool newSession = true;
      bool getIn = true;
      var sessionId = GenericHelper.getSessionId(date);
      if (lastPoint != null) {
        // verify if the last point is more than 6 hours ago -> case of same day and when session goes through 00h
        newSession = lastPoint.date.isBefore(interval);

        if (newSession) {
          //verify if last session was closed, if not close it
          if (lastPoint.getIn) {
            await db
                .into(db.pontos)
                .insert(
                  PontosCompanion(
                    date: Value(lastPoint.date),
                    sessionId: Value(lastPoint.sessionId),
                    getIn: Value(false),
                  ),
                );
          }
        } else {
          sessionId = lastPoint.sessionId;
          getIn = !lastPoint.getIn;
        }
      }

      await db
          .into(db.pontos)
          .insert(
            PontosCompanion(
              date: Value(date),
              sessionId: Value(sessionId),
              getIn: Value(getIn),
            ),
          );
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

  Future<void> updateSessionPointsCrono(DateTime sessionDate) async {
    var id = GenericHelper.getSessionId(sessionDate);

    var points =
        await (db.select(db.pontos)
              ..where((p) => p.sessionId.equals(id))
              ..orderBy([
                (p) => OrderingTerm(expression: p.date, mode: OrderingMode.asc),
              ]))
            .get();

    var getIn = true;

    for (var point in points) {
      await (db.update(db.pontos)..where(
        (p) => p.id.equals(point.id),
      )).write(PontosCompanion(getIn: Value(getIn)));

      getIn = !getIn; // change value for next
    }
  }

  Future<void> insertUpdateSession(
    DateTime sessionDate,
    int minutesWorked,
    double hourValue,
    double profit,
  ) async {
    var id = GenericHelper.getSessionId(sessionDate);

    final existing =
        await (db.select(db.session)
          ..where((s) => s.sessionId.equals(id))).get();

    if (existing.isEmpty) {
      await db
          .into(db.session)
          .insert(
            SessionCompanion.insert(
              sessionId: id,
              day: sessionDate,
              minutesWorked: minutesWorked,
              hourValue: Value(hourValue),
              profit: Value(profit),
              workId: Value(''),
            ),
          );
    } else {
      await (db.update(db.session)
        ..where((s) => s.sessionId.equals(id))) // supondo que o id fixo é 1
      .write(
        SessionCompanion(
          minutesWorked: Value(minutesWorked),
          hourValue: Value(hourValue),
          profit: Value(profit),
        ),
      );
    }
  }

  Future<SessionData?> getSessionData(DateTime session) async =>
      await (db.select(db.session)
            ..where((s) => s.day.equals(session))
            ..limit(1))
          .getSingleOrNull();

  Future<Map<DateTime, Map<AnalysisMapEntriesEnum, dynamic>>> getProfitsAsMap(
    String mode,
    DateTime start,
    DateTime end,
  ) async {
    switch (mode) {
      case AnalysisViewMode.year:
        final result =
            await db
                .customSelect(
                  '''
  SELECT day, profit, minutes_worked
  FROM session
  WHERE day BETWEEN ? AND ?
  ORDER BY day
  ''',
                  variables: [
                    Variable.withInt(start.millisecondsSinceEpoch),
                    Variable.withInt(end.millisecondsSinceEpoch),
                  ],
                )
                .get();

        final Map<DateTime, Map<AnalysisMapEntriesEnum, dynamic>>
        groupedByMonth = {};

        for (final row in result) {
          final dayMillis = row.read<int>('day');
          final date = DateTime.fromMillisecondsSinceEpoch(dayMillis);
          final monthKey = DateTime(date.year, date.month);

          groupedByMonth.putIfAbsent(
            monthKey,
            () => {
              AnalysisMapEntriesEnum.profit: 0.0,
              AnalysisMapEntriesEnum.minutesWorked: 0,
            },
          );

          groupedByMonth[monthKey]![AnalysisMapEntriesEnum.profit] += row
              .read<double>('profit');
          groupedByMonth[monthKey]![AnalysisMapEntriesEnum.minutesWorked] += row
              .read<int>('minutes_worked');
        }

        return groupedByMonth;

      case AnalysisViewMode.week:
        final result =
            await db
                .customSelect(
                  '''
        SELECT day, profit, minutes_worked
        FROM session
        WHERE day BETWEEN ? AND ?
        ''',
                  variables: [
                    Variable.withDateTime(start),
                    Variable.withDateTime(end),
                  ],
                )
                .get();

        return {
          for (final row in result)
            row.read<DateTime>('day'): {
              AnalysisMapEntriesEnum.profit: row.read<double>('profit'),
              AnalysisMapEntriesEnum.minutesWorked: row.read<int>(
                'minutes_worked',
              ),
            },
        };

      case AnalysisViewMode.month:
      default:
        final result =
            await db
                .customSelect(
                  '''
        SELECT day, profit, minutes_worked
        FROM session
        WHERE day BETWEEN ? AND ?
        ORDER BY day
        ''',
                  variables: [
                    Variable.withDateTime(start),
                    Variable.withDateTime(end),
                  ],
                )
                .get();

        return {
          for (final row in result)
            if (row.read<int>('minutes_worked') > 0)
              row.read<DateTime>('day'): {
                AnalysisMapEntriesEnum.profit: row.read<double>('profit'),
                AnalysisMapEntriesEnum.minutesWorked: row.read<int>(
                  'minutes_worked',
                ),
              },
        };
    }
  }
}
