import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/points_helper.dart';
import 'package:on_time/utils/common_objs.dart';
import 'package:on_time/utils/labels.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(executor: NativeDatabase.memory());

    // ao domingo
    await db
        .into(db.hourValuePolitics)
        .insert(
          HourValuePoliticsCompanion.insert(
            ruleDescription: HourValueRules.dayWeekRule,
            dayOffWeek: Value(CommonObjs.daysOfWeek[6]),
            hourValue: Value(25.89),
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  test('Teste lucro ao Domingo', () async {
    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 13, 16, 0),
            sessionId: DateTime(2025, 7, 13),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 13, 18, 33),
            sessionId: DateTime(2025, 7, 13),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 13, 22, 33),
            sessionId: DateTime(2025, 7, 13),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 14, 01, 15),
            sessionId: DateTime(2025, 7, 13),
          ),
        );

    final points = await db.select(db.pontos).get();
    final rules = await db.select(db.hourValuePolitics).get();

    final profit = PointsHelper.getSessionProfit(
      DateTime(2025, 7, 13),
      PointsHelper.getMinutesWorkedSession(points),
      18,
      points,
      rules,
    );

    expect(double.parse(profit.toStringAsFixed(2)), 135.92);
  });

  test('Teste lucro ao fim de 4h e 6h de trabalho', () async {
    // depois de 4h
    await db
        .into(db.hourValuePolitics)
        .insert(
          HourValuePoliticsCompanion.insert(
            ruleDescription: HourValueRules.valueAfterXHoursRule,
            afterMinutesWorked: Value(240),
            hourValue: Value(21.53),
          ),
        );

    // depois de 6h
    await db
        .into(db.hourValuePolitics)
        .insert(
          HourValuePoliticsCompanion.insert(
            ruleDescription: HourValueRules.valueAfterXHoursRule,
            afterMinutesWorked: Value(360),
            hourValue: Value(23.32),
          ),
        );
    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 15, 9, 0),
            sessionId: DateTime(2025, 7, 15),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 15, 12, 30),
            sessionId: DateTime(2025, 7, 15),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 15, 13, 0),
            sessionId: DateTime(2025, 7, 15),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 15, 18, 0),
            sessionId: DateTime(2025, 7, 15),
          ),
        );

    final points = await db.select(db.pontos).get();
    final rules = await db.select(db.hourValuePolitics).get();

    final profit = PointsHelper.getSessionProfit(
      DateTime(2025, 7, 15),
      PointsHelper.getMinutesWorkedSession(points),
      18.33,
      points,
      rules,
    );

    expect(double.parse(profit.toStringAsFixed(2)), 174.68);
  });

  test('Teste lucro apos as 23h', () async {
    // depois das 23h
    await db
        .into(db.hourValuePolitics)
        .insert(
          HourValuePoliticsCompanion.insert(
            ruleDescription: HourValueRules.valueAfterXScheduleRule,
            afterSchedule: Value(DateTime(0, 1, 1, 23, 0)),
            hourValue: Value(20.35),
          ),
        );

    // depois das 01h
    await db
        .into(db.hourValuePolitics)
        .insert(
          HourValuePoliticsCompanion.insert(
            ruleDescription: HourValueRules.valueAfterXScheduleRule,
            afterSchedule: Value(DateTime(0, 1, 1, 1, 0)),
            hourValue: Value(25.89),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 15, 18, 0),
            sessionId: DateTime(2025, 7, 15),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 15, 21, 45),
            sessionId: DateTime(2025, 7, 15),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 15, 22, 0),
            sessionId: DateTime(2025, 7, 15),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 16, 0, 15),
            sessionId: DateTime(2025, 7, 15),
          ),
        );

    final points = await db.select(db.pontos).get();
    final rules = await db.select(db.hourValuePolitics).get();

    final profit = PointsHelper.getSessionProfit(
      DateTime(2025, 7, 15),
      PointsHelper.getMinutesWorkedSession(points),
      18.33,
      points,
      rules,
    );

    expect(double.parse(profit.toStringAsFixed(2)), 112.5);
  });

  test('Teste lucro apos as 01h', () async {
    // depois das 23h
    await db
        .into(db.hourValuePolitics)
        .insert(
          HourValuePoliticsCompanion.insert(
            ruleDescription: HourValueRules.valueAfterXScheduleRule,
            afterSchedule: Value(DateTime(0, 1, 1, 23, 0)),
            hourValue: Value(20.35),
          ),
        );

    // depois das 01h
    await db
        .into(db.hourValuePolitics)
        .insert(
          HourValuePoliticsCompanion.insert(
            ruleDescription: HourValueRules.valueAfterXScheduleRule,
            afterSchedule: Value(DateTime(0, 1, 1, 1, 0)),
            hourValue: Value(25.89),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 15, 18, 0),
            sessionId: DateTime(2025, 7, 15),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 15, 21, 45),
            sessionId: DateTime(2025, 7, 15),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 15, 22, 0),
            sessionId: DateTime(2025, 7, 15),
          ),
        );

    await db
        .into(db.pontos)
        .insert(
          PontosCompanion.insert(
            date: DateTime(2025, 7, 16, 2, 30),
            sessionId: DateTime(2025, 7, 15),
          ),
        );

    final points = await db.select(db.pontos).get();
    final rules = await db.select(db.hourValuePolitics).get();

    final profit = PointsHelper.getSessionProfit(
      DateTime(2025, 7, 15),
      PointsHelper.getMinutesWorkedSession(points),
      18.33,
      points,
      rules,
    );

    expect(double.parse(profit.toStringAsFixed(2)), 166.6);
  });
}
