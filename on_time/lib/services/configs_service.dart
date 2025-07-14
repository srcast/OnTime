import 'package:drift/drift.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/points_helper.dart';
import 'package:on_time/utils/common_objs.dart';

class ConfigsService {
  final AppDatabase db;

  ConfigsService(this.db);

  Future<void> ensureConfigExists() async {
    final existing = await db.select(db.configurations).get();

    if (existing.isEmpty) {
      await db
          .into(db.configurations)
          .insert(
            ConfigurationsCompanion.insert(
              id: Value(1),
              hourValueBase: Value(0),
              extraValue: Value(0),
              taxesPercentage: Value(0),
              valuesNotTaxable: Value(0),
            ),
          );
    }
  }

  Future<double?> getHourValueBase() async {
    var config =
        await (db.selectOnly(db.configurations)
          ..addColumns([db.configurations.hourValueBase])).getSingleOrNull();

    return config?.read<double>(db.configurations.hourValueBase);
  }

  Future<void> updateHourValueBase(double value) async {
    await (db.update(db.configurations)
      ..where((c) => c.id.equals(1))) // supondo que o id fixo é 1
    .write(ConfigurationsCompanion(hourValueBase: Value(value)));
  }

  Future<List<HourValuePolitic>> getHourValuePolitics() async =>
      await (db.select(db.hourValuePolitics)
        ..orderBy([(r) => OrderingTerm(expression: r.id)])).get();

  Future<void> insertRule(HourValuePoliticsCompanion rule) async {
    try {
      await db.into(db.hourValuePolitics).insert(rule);
    } catch (e, s) {
      print('Exception details:\n $e');
      print('Stack trace:\n $s');
    }
  }

  Future<void> deleteRule(HourValuePolitic ruleToDelete) async {
    (db.delete(db.hourValuePolitics)
      ..where((p) => p.id.equals(ruleToDelete.id))).go();
  }

  Future<int> updateRule(HourValuePoliticsCompanion ruleToUpdate) async {
    return await (db.update(db.hourValuePolitics)
      ..where((p) => p.id.equals(ruleToUpdate.id.value))).write(ruleToUpdate);
  }

  Future<double?> getHourValueInUseFromRules(
    DateTime now,
    DateTime sessionDate,
    List<Ponto> sessionPoints,
  ) async {
    // first by day
    String day = CommonObjs.daysOfWeek[sessionDate.weekday];
    var dayValue =
        await (db.select(db.hourValuePolitics)
              ..where((r) => r.dayOffWeek.equals(day))
              ..orderBy([(r) => OrderingTerm(expression: r.id)])
              ..limit(1))
            .getSingleOrNull();

    if (dayValue != null) return dayValue.hourValue;

    // after schedule

    if (sessionPoints.isNotEmpty) {
      final start = sessionPoints[0].date;
      final end = sessionPoints.last.date;

      final rulesSchedule =
          await (db.select(db.hourValuePolitics)
            ..where((r) => r.afterSchedule.isNotNull())).get();

      for (int i = 0; i < rulesSchedule.length; i++) {
        DateTime regraDateTime = DateTime(
          start.year,
          start.month,
          start.day,
          rulesSchedule[i].afterSchedule!.hour,
          rulesSchedule[i].afterSchedule!.minute,
        );

        if (regraDateTime.isBefore(start)) {
          regraDateTime = regraDateTime.add(const Duration(days: 1));
        }

        if (regraDateTime.isAfter(start) && regraDateTime.isBefore(end)) {
          rulesSchedule[i].copyWith(afterSchedule: Value(regraDateTime));
        } else {
          rulesSchedule.remove(rulesSchedule[i]);
        }
      }

      // desc order
      if (rulesSchedule.isNotEmpty) {
        rulesSchedule.sort(
          (a, b) => b.afterSchedule!.compareTo(a.afterSchedule!),
        );
        return rulesSchedule[0].hourValue;
      }
    }

    // after X hours
    int minWorkedSession = PointsHelper.getMinutesWorkedSession(sessionPoints);

    var afterXHours =
        await (db.select(db.hourValuePolitics)
              ..where(
                (r) => r.afterMinutesWorked.isSmallerOrEqual(
                  Variable(minWorkedSession),
                ),
              )
              ..orderBy([
                (r) => OrderingTerm(
                  expression: r.afterMinutesWorked,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(1))
            .getSingleOrNull();

    if (afterXHours != null) return dayValue!.hourValue;

    // base
    return getHourValueBase();
  }
}
