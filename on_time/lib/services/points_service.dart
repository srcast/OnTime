import 'package:drift/drift.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/helpers/points_helper.dart';
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
                  DateTime(
                    sessionDate.year,
                    sessionDate.month,
                    sessionDate.day,
                    23,
                    59,
                  ),
                ),
          )
          ..orderBy([
            (p) => OrderingTerm(expression: p.date, mode: OrderingMode.asc),
          ]))
        .get();
  }

  Future<void> insertPoint(DateTime date) {
    return db.transaction(() async {
      final pointDate = _withoutSeconds(date);
      final sessionId = await _sessionIdFor(pointDate);

      await db
          .into(db.pontos)
          .insert(
            PontosCompanion.insert(
              date: pointDate,
              sessionId: sessionId,
              getIn: true, // set by _recalculateSession
            ),
          );

      await _recalculateSession(sessionId);
    });
  }

  Future<void> deletePoint(Ponto pointToDelete) {
    return db.transaction(() async {
      await (db.delete(db.pontos)
        ..where((p) => p.id.equals(pointToDelete.id))).go();

      await _recalculateSession(pointToDelete.sessionId);
    });
  }

  Future<void> updatePoint(Ponto pointToUpdate, DateTime newDate) {
    return db.transaction(() async {
      final pointDate = _withoutSeconds(newDate);
      // date may have changed to another day -> session is decided again, like a new point
      final sessionId = await _sessionIdFor(
        pointDate,
        ignorePointId: pointToUpdate.id,
      );

      await (db.update(db.pontos)
        ..where((p) => p.id.equals(pointToUpdate.id))).write(
        PontosCompanion(date: Value(pointDate), sessionId: Value(sessionId)),
      );

      await _recalculateSession(sessionId);
      if (sessionId != pointToUpdate.sessionId) {
        await _recalculateSession(pointToUpdate.sessionId);
      }
    });
  }

  DateTime _withoutSeconds(DateTime date) =>
      DateTime(date.year, date.month, date.day, date.hour, date.minute);

  // last point of another day less than 6 hours before -> same session (session going through 00h)
  // it can be a get in or a get out -> a get out followed by a point within 6h is a pause, not a new work day
  Future<String> _sessionIdFor(DateTime date, {int? ignorePointId}) async {
    final sessionId = GenericHelper.getSessionId(date);

    final query =
        db.select(db.pontos)
          ..where((p) => p.date.isSmallerThanValue(date))
          ..orderBy([(p) => OrderingTerm.desc(p.date)])
          ..limit(1);
    if (ignorePointId != null) {
      query.where((p) => p.id.isNotValue(ignorePointId));
    }
    final lastPoint = await query.getSingleOrNull();

    if (lastPoint != null &&
        lastPoint.sessionId != sessionId &&
        !lastPoint.date.isBefore(date.add(const Duration(hours: -6)))) {
      return lastPoint.sessionId;
    }

    return sessionId;
  }

  Future<void> _recalculateSession(String sessionId) async {
    final points = await getPointsSession(sessionId);

    if (points.isEmpty) {
      await (db.delete(db.session)
        ..where((s) => s.sessionId.equals(sessionId))).go();
      return;
    }

    // in / out by chronological order
    for (int i = 0; i < points.length; i++) {
      await (db.update(db.pontos)..where(
        (p) => p.id.equals(points[i].id),
      )).write(PontosCompanion(getIn: Value(i.isEven)));
    }

    final configs = await db.select(db.configurations).get();
    final hourValueBase = configs.firstOrNull?.hourValueBase ?? 0;
    final rules =
        await (db.select(db.hourValuePolitics)
          ..orderBy([(r) => OrderingTerm(expression: r.id)])).get();
    final day = GenericHelper.getDateFromSessionId(sessionId);

    final minutesWorked = PointsHelper.getMinutesWorkedSession(points);
    final hourValue = PointsHelper.getHourValueInUseFromRules(
      DateTime.now(),
      day,
      points,
      rules,
      hourValueBase,
    );
    final profit = PointsHelper.getSessionProfit(
      day,
      hourValueBase,
      points,
      rules,
    );

    final existing = await getSessionData(sessionId);
    if (existing == null) {
      await db
          .into(db.session)
          .insert(
            SessionCompanion.insert(
              sessionId: sessionId,
              day: day,
              minutesWorked: minutesWorked,
              hourValue: Value(hourValue),
              profit: Value(profit),
              workId: Value(''),
            ),
          );
    } else {
      await (db.update(db.session)
        ..where((s) => s.sessionId.equals(sessionId))).write(
        SessionCompanion(
          day: Value(day),
          minutesWorked: Value(minutesWorked),
          hourValue: Value(hourValue),
          profit: Value(profit),
        ),
      );
    }
  }

  Future<SessionData?> getSessionData(String sessionId) async {
    return await (db.select(db.session)
          ..where((s) => s.sessionId.equals(sessionId))
          ..limit(1))
        .getSingleOrNull();
  }

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
                      DatesHelper.addDays(end, 1).add(Duration(seconds: -1)),
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
                      DatesHelper.addDays(end, 1).add(Duration(seconds: -1)),
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
