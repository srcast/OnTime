// import 'package:drift/drift.dart';
// import 'package:drift/native.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:on_time/database/database.dart';
// import 'package:on_time/helpers/points_helper.dart';
// import 'package:on_time/utils/common_objs.dart';
// import 'package:on_time/utils/labels.dart';

// void main() {
//   late AppDatabase db;

//   late List<HourValuePolitic> rules;

//   setUp(() async {
//     db = AppDatabase(executor: NativeDatabase.memory());

//     // ao domingo
//     await db
//         .into(db.hourValuePolitics)
//         .insert(
//           HourValuePoliticsCompanion.insert(
//             ruleDescription: HourValueRules.dayWeekRule,
//             dayOffWeek: Value(CommonObjs.daysOfWeek[6]),
//             hourValue: Value(27),
//           ),
//         );

//     // depois das 23h
//     await db
//         .into(db.hourValuePolitics)
//         .insert(
//           HourValuePoliticsCompanion.insert(
//             ruleDescription: HourValueRules.valueAfterXScheduleRule,
//             afterSchedule: Value(DateTime(0, 1, 1, 23, 0)),
//             workStartAt: Value(DateTime(0, 1, 1, 18, 0)),
//             hourValue: Value(23),
//           ),
//         );

//     // depois das 01h
//     await db
//         .into(db.hourValuePolitics)
//         .insert(
//           HourValuePoliticsCompanion.insert(
//             ruleDescription: HourValueRules.valueAfterXScheduleRule,
//             afterSchedule: Value(DateTime(0, 1, 1, 1, 0)),
//             workStartAt: Value(DateTime(0, 1, 1, 18, 0)),
//             hourValue: Value(26),
//           ),
//         );

//     // depois de 4h
//     await db
//         .into(db.hourValuePolitics)
//         .insert(
//           HourValuePoliticsCompanion.insert(
//             ruleDescription: HourValueRules.valueAfterXHoursRule,
//             afterMinutesWorked: Value(240),
//             hourValue: Value(20),
//           ),
//         );

//     // depois de 6h
//     await db
//         .into(db.hourValuePolitics)
//         .insert(
//           HourValuePoliticsCompanion.insert(
//             ruleDescription: HourValueRules.valueAfterXHoursRule,
//             afterMinutesWorked: Value(360),
//             hourValue: Value(22),
//           ),
//         );

//     rules = await db.select(db.hourValuePolitics).get();
//   });

//   tearDown(() async {
//     await db.close();
//   });

//   test('Teste lucro ao Domingo', () async {
//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 14, 16, 0),
//             sessionId: DateTime(2025, 9, 14),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 14, 18, 33),
//             sessionId: DateTime(2025, 9, 14),
//           ),
//         );

//     final points = await db.select(db.pontos).get();

//     final profit = PointsHelper.getSessionProfit(
//       DateTime(2025, 9, 14),
//       18,
//       points,
//       rules,
//     );

//     expect(double.parse(profit.toStringAsFixed(2)), 68.85);
//   });

//   test('Teste lucro dia Normal', () async {
//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 18, 0),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 20, 33),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     final points = await db.select(db.pontos).get();
//     final rules = await db.select(db.hourValuePolitics).get();

//     final profit = PointsHelper.getSessionProfit(
//       DateTime(2025, 9, 15),
//       18,
//       points,
//       rules,
//     );

//     expect(double.parse(profit.toStringAsFixed(2)), 45.9);
//   });

//   test('Teste lucro ao fim de 4h e 6h de trabalho', () async {
//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 9, 0),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 12, 30),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 13, 0),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 18, 0),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     final points = await db.select(db.pontos).get();
//     final rules = await db.select(db.hourValuePolitics).get();

//     final profit = PointsHelper.getSessionProfit(
//       DateTime(2025, 9, 15),
//       18.33,
//       points,
//       rules,
//     );

//     expect(double.parse(profit.toStringAsFixed(2)), 168.32);
//   });

//   test('Teste lucro apos as 23h', () async {
//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 18, 0),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 21, 45),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 22, 0),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 16, 0, 15),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     final points = await db.select(db.pontos).get();
//     final rules = await db.select(db.hourValuePolitics).get();

//     final profit = PointsHelper.getSessionProfit(
//       DateTime(2025, 9, 15),
//       18.33,
//       points,
//       rules,
//     );

//     expect(double.parse(profit.toStringAsFixed(2)), 115.82);
//   });

//   test('Teste lucro apos as 01h', () async {
//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 18, 0),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 21, 45),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 22, 0),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 16, 2, 30),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     final points = await db.select(db.pontos).get();
//     final rules = await db.select(db.hourValuePolitics).get();

//     final profit = PointsHelper.getSessionProfit(
//       DateTime(2025, 9, 15),
//       18.33,
//       points,
//       rules,
//     );

//     expect(double.parse(profit.toStringAsFixed(2)), 172.07);
//   });

//   test('Teste lucro normal sem regras especiais', () async {
//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 18, 0),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 21, 45),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 22, 0),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 16, 2, 30),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );

//     final points = await db.select(db.pontos).get();
//     List<HourValuePolitic> rulesAux = List.empty();

//     final profit = PointsHelper.getSessionProfit(
//       DateTime(2025, 9, 15),
//       18.33,
//       points,
//       rulesAux,
//     );

//     expect(double.parse(profit.toStringAsFixed(2)), 151.22);
//   });

//   test('Teste valor/hora apos 23h, com pontos', () async {
//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 15, 23, 7),
//             sessionId: DateTime(2025, 9, 15),
//           ),
//         );
//     final points =
//         await (db.select(db.pontos)..orderBy([
//           (p) => OrderingTerm(expression: p.date, mode: OrderingMode.asc),
//         ])).get();
//     final rules = await db.select(db.hourValuePolitics).get();
//     final value = PointsHelper.getHourValueInUseFromRules(
//       DateTime(2025, 9, 15, 23, 20),
//       DateTime(2025, 9, 15),
//       points,
//       rules,
//       18.33,
//     );
//     expect(value, 23);
//   });

//   test('Teste valor/hora apos 23h, sem  pontos', () async {
//     final points =
//         await (db.select(db.pontos)..orderBy([
//           (p) => OrderingTerm(expression: p.date, mode: OrderingMode.asc),
//         ])).get();
//     final rules = await db.select(db.hourValuePolitics).get();
//     final value = PointsHelper.getHourValueInUseFromRules(
//       DateTime(2025, 9, 15, 23, 20),
//       DateTime(2025, 9, 15),
//       points,
//       rules,
//       18.33,
//     );
//     expect(value, 23);
//   });

//   test('Teste valor/hora normal, com pontos', () async {
//     // await db
//     //     .into(db.pontos)
//     //     .insert(
//     //       PontosCompanion.insert(
//     //         date: DateTime(2025, 9, 15, 18, 7),
//     //         sessionId: DateTime(2025, 9, 15),
//     //       ),
//     //     );
//     final points =
//         await (db.select(db.pontos)..orderBy([
//           (p) => OrderingTerm(expression: p.date, mode: OrderingMode.asc),
//         ])).get();
//     final rules = await db.select(db.hourValuePolitics).get();
//     final value = PointsHelper.getHourValueInUseFromRules(
//       DateTime(2025, 9, 15, 20, 20),
//       DateTime(2025, 9, 15),
//       points,
//       rules,
//       18.33,
//     );
//     expect(value, 18.33);
//   });

//   test('Teste valor/hora dommingo, com pontos', () async {
//     await db
//         .into(db.pontos)
//         .insert(
//           PontosCompanion.insert(
//             date: DateTime(2025, 9, 14, 18, 7),
//             sessionId: DateTime(2025, 9, 14),
//           ),
//         );
//     final points =
//         await (db.select(db.pontos)..orderBy([
//           (p) => OrderingTerm(expression: p.date, mode: OrderingMode.asc),
//         ])).get();
//     final rules = await db.select(db.hourValuePolitics).get();
//     final value = PointsHelper.getHourValueInUseFromRules(
//       DateTime(2025, 9, 14, 20, 20),
//       DateTime(2025, 9, 14),
//       points,
//       rules,
//       18.33,
//     );
//     expect(value, 27);
//   });
// }
