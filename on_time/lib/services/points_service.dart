import 'package:drift/drift.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';

class PointsService {
  final AppDatabase db;

  PointsService(this.db);

  Future<List<Ponto>> getPointsSession(String sessionId) async {
    return await (db.select(db.pontos)
          ..where((p) => p.sessionId.equals(sessionId))
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

  Future<String> insertPoint(DateTime date) async {
    // verify session with last point
    DateTime interval = date.add(Duration(hours: -6));

    var lastPoint =
        await (db.select(db.pontos)
              ..where((p) => p.date.isSmallerThanValue(date))
              ..orderBy([(t) => OrderingTerm.desc(t.date)])
              ..limit(1))
            .getSingleOrNull();
    bool sameSession = false;
    bool getIn = true;
    var sessionId = GenericHelper.getSessionId(date);

    if (lastPoint != null) {
      // verify if the last point is less than 6 hours ago ant it was get in-> case of same day and when session goes through 00h
      sameSession =
          lastPoint.sessionId != sessionId &&
          !lastPoint.date.isBefore(interval);

      if (sameSession) {
        sessionId = lastPoint.sessionId; // aqui para dias diferentes
        getIn = !lastPoint.getIn;
      }
    }

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion(
            date: Value(
              DateTime(date.year, date.month, date.day, date.hour, date.minute),
            ), // ignore seconds
            sessionId: Value(sessionId),
            getIn: Value(getIn),
          ),
        );

    return sessionId;
  }

  Future<String> deletePoint(Ponto pointToDelete) async {
    await (db.delete(db.pontos)
      ..where((p) => p.id.equals(pointToDelete.id))).go();

    return pointToDelete.sessionId;
  }

  Future<String> updatePonto(Ponto pointToUpdate, DateTime newDate) async {
    // aqui a sessao pode nao ser a mesma -> a data pode ter mudado
    await (db.update(db.pontos)
      ..where((p) => p.id.equals(pointToUpdate.id))).write(
      PontosCompanion(
        date: Value(
          DateTime(
            newDate.year,
            newDate.month,
            newDate.day,
            newDate.hour,
            newDate.minute,
          ),
        ),
      ),
    );

    return pointToUpdate.sessionId;
  }

  Future<void> updateSessionPointsCrono(String sessionId) async {
    var points =
        await (db.select(db.pontos)
              ..where((p) => p.sessionId.equals(sessionId))
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
    String sessionId,
    DateTime sessionDate,
    int minutesWorked,
    double hourValue,
    double profit,
  ) async {
    final existing =
        await (db.select(db.session)
          ..where((s) => s.sessionId.equals(sessionId))).get();

    if (existing.isEmpty) {
      await db
          .into(db.session)
          .insert(
            SessionCompanion.insert(
              sessionId: sessionId,
              day: sessionDate,
              minutesWorked: minutesWorked,
              hourValue: Value(hourValue),
              profit: Value(profit),
              workId: Value(''),
            ),
          );
    } else {
      await (db.update(db.session)..where(
        (s) => s.sessionId.equals(sessionId),
      )) // supondo que o id fixo é 1
      .write(
        SessionCompanion(
          minutesWorked: Value(minutesWorked),
          hourValue: Value(hourValue),
          profit: Value(profit),
        ),
      );
    }
  }

  Future<SessionData?> getSessionData(String sessionId) async =>
      await (db.select(db.session)
            ..where((s) => s.sessionId.equals(sessionId))
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
  WHERE session_id LIKE ?
  ORDER BY day
  ''',
                  variables: [Variable.withString('${start.year}%')],
                )
                .get();

        final Map<DateTime, Map<AnalysisMapEntriesEnum, dynamic>>
        groupedByMonth = {};

        for (final row in result) {
          final date = row.read<DateTime>('day');
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
                    Variable.withDateTime(
                      end.add(Duration(days: 1)).add(Duration(seconds: -1)),
                    ), // end of the day
                  ],
                )
                .get();

        return {
          for (final row in result)
            DatesHelper.getSessionFromDate(row.read<DateTime>('day')): {
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
                    Variable.withDateTime(
                      end.add(Duration(days: 1)).add(Duration(seconds: -1)),
                    ), // end of the day
                  ],
                )
                .get();

        return {
          for (final row in result)
            if (row.read<int>('minutes_worked') > 0)
              DatesHelper.getSessionFromDate(row.read<DateTime>('day')): {
                AnalysisMapEntriesEnum.profit: row.read<double>('profit'),
                AnalysisMapEntriesEnum.minutesWorked: row.read<int>(
                  'minutes_worked',
                ),
              },
        };
    }
  }
}
