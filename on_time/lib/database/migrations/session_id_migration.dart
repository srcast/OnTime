import 'package:drift/drift.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/helpers/points_helper.dart';

// Schema v1 -> v2
// Legacy session ids were year + month + day without zero padding, so dates like
// 2025-01-11 and 2025-11-01 shared the id "2025111" (points mixed and session overwritten).
// Moves points and sessions to the yyyyMMdd id. Only the sessions that collided are
// recalculated, the others keep their stored values.
class SessionIdMigration {
  static Future<void> run(AppDatabase db) async {
    final points =
        await (db.select(db.pontos)
          ..orderBy([(p) => OrderingTerm.asc(p.date)])).get();

    // legacy id -> new id -> points of that session
    final groups = <String, Map<String, List<Ponto>>>{};
    for (final point in points) {
      final candidates = legacyCandidates(point.sessionId);
      if (candidates.isEmpty) continue; // already in the new format

      groups
          .putIfAbsent(point.sessionId, () => {})
          .putIfAbsent(_newIdForPoint(point, candidates), () => [])
          .add(point);
    }

    // points
    for (final byNewId in groups.values) {
      final collided = byNewId.length > 1;

      for (final entry in byNewId.entries) {
        for (int i = 0; i < entry.value.length; i++) {
          await (db.update(db.pontos)
            ..where((p) => p.id.equals(entry.value[i].id))).write(
            PontosCompanion(
              sessionId: Value(entry.key),
              // collided sessions had in/out computed with both days mixed
              getIn: collided ? Value(i.isEven) : const Value.absent(),
            ),
          );
        }
      }
    }

    // sessions
    final configs = await db.select(db.configurations).get();
    final hourValueBase = configs.firstOrNull?.hourValueBase ?? 0;
    final rules = await db.select(db.hourValuePolitics).get();

    for (final session in await db.select(db.session).get()) {
      final candidates = legacyCandidates(session.sessionId);
      if (candidates.isEmpty) continue;

      final byNewId = groups[session.sessionId] ?? {};
      if (byNewId.length > 1) continue; // handled below

      final newId =
          byNewId.keys.firstOrNull ??
          GenericHelper.getSessionId(
            candidates.length == 1 ? candidates.first : session.day,
          );

      await (db.update(db.session)..where(
        (s) => s.sessionId.equals(session.sessionId),
      )).write(SessionCompanion(sessionId: Value(newId)));
    }

    for (final legacyId in groups.keys) {
      final byNewId = groups[legacyId]!;
      if (byNewId.length < 2) continue;

      // stored values mix both days -> rebuild each session from its points
      await (db.delete(db.session)
        ..where((s) => s.sessionId.equals(legacyId))).go();

      for (final entry in byNewId.entries) {
        await _insertRecalculatedSession(
          db,
          entry.key,
          entry.value,
          rules,
          hourValueBase,
        );
      }
    }
  }

  // possible dates of a legacy id ("2025111" -> 2025-01-11 and 2025-11-01). Empty if not legacy
  static List<DateTime> legacyCandidates(String sessionId) {
    if (!RegExp(r'^\d{6,7}$').hasMatch(sessionId)) return [];

    final year = int.parse(sessionId.substring(0, 4));
    final monthDay = sessionId.substring(4);
    final splits = [
      for (int monthDigits = 1; monthDigits <= 2; monthDigits++)
        if (monthDay.length - monthDigits >= 1 &&
            monthDay.length - monthDigits <= 2)
          (
            int.parse(monthDay.substring(0, monthDigits)),
            int.parse(monthDay.substring(monthDigits)),
          ),
    ];

    return [
      for (final (month, day) in splits)
        if (month >= 1 &&
            month <= 12 &&
            day >= 1 &&
            DateTime(year, month, day).month == month)
          DateTime(year, month, day),
    ];
  }

  static String _newIdForPoint(Ponto point, List<DateTime> candidates) {
    final pointDay = DateTime(
      point.date.year,
      point.date.month,
      point.date.day,
    );

    for (final candidate in candidates) {
      final nextDay = DateTime(
        candidate.year,
        candidate.month,
        candidate.day + 1,
      );

      // sessions going through 00h keep the id of the day they started
      if (pointDay == candidate || pointDay == nextDay) {
        return GenericHelper.getSessionId(candidate);
      }
    }

    return GenericHelper.getSessionId(pointDay);
  }

  static Future<void> _insertRecalculatedSession(
    AppDatabase db,
    String sessionId,
    List<Ponto> points,
    List<HourValuePolitic> rules,
    double hourValueBase,
  ) async {
    final day = DateTime(
      int.parse(sessionId.substring(0, 4)),
      int.parse(sessionId.substring(4, 6)),
      int.parse(sessionId.substring(6, 8)),
    );
    final minutesWorked = PointsHelper.getMinutesWorkedSession(points);
    var hourValue = hourValueBase;
    var profit = minutesWorked * hourValueBase / 60;

    try {
      hourValue = PointsHelper.getHourValueInUseFromRules(
        points.last.date,
        day,
        points,
        rules,
        hourValueBase,
      );
      profit = PointsHelper.getSessionProfit(day, hourValueBase, points, rules);
    } catch (_) {
      // an invalid rule can't block the app from opening -> keeps base value
    }

    await db
        .into(db.session)
        .insert(
          SessionCompanion.insert(
            sessionId: sessionId,
            day: day,
            minutesWorked: minutesWorked,
            hourValue: Value(hourValue),
            profit: Value(profit),
            workId: const Value(''),
          ),
        );
  }
}
