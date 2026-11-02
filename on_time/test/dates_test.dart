import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/analysis_page_vm.dart';

// DST cases only fail with Duration(days) in a timezone with DST (ex: Portugal)
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('addDays mantem a meia-noite na mudanca de hora', () {
    // october: day with 25h
    expect(
      DatesHelper.addDays(DateTime(2026, 10, 19), 7),
      DateTime(2026, 10, 26),
    );
    // march: day with 23h
    expect(
      DatesHelper.addDays(DateTime(2026, 3, 23), 7),
      DateTime(2026, 3, 30),
    );
    expect(
      DatesHelper.addDays(DateTime(2026, 3, 30), -7),
      DateTime(2026, 3, 23),
    );
  });

  test('addDays nao salta dias e mantem a hora', () {
    expect(
      DatesHelper.addDays(DateTime(2026, 3, 28, 23, 30), 1),
      DateTime(2026, 3, 29, 23, 30),
    );
    expect(
      DatesHelper.addDays(DateTime(2028, 2, 28), 1),
      DateTime(2028, 2, 29),
    );
    expect(
      DatesHelper.addDays(DateTime(2026, 12, 31), 1),
      DateTime(2027, 1, 1),
    );
  });

  // firstDayOfWeekIndex from MaterialLocalizations: 0 = sunday (en), 1 = monday (pt, fr)
  for (final (index, firstDay) in [
    (0, DateTime.sunday),
    (1, DateTime.monday),
  ]) {
    test(
      'Analise semanal: 7 dias a meia-noite, a comecar no dia $firstDay',
      () async {
        final db = AppDatabase(executor: NativeDatabase.memory());
        final vm = AnalysisPageVM(PointsService(db));
        addTearDown(() async {
          vm.dispose();
          await db.close();
        });

        vm.setFirstDayOfWeek(index);
        vm.updateViewMode(AnalysisViewMode.week);

        // > 1 year -> goes through both DST changes
        for (int i = 0; i < 60; i++) {
          vm.advanceDate();
          await vm.getData();

          final days = vm.entries.keys.toList()..sort();
          expect(days.length, 7, reason: 'semana ${i + 1}');
          expect(days.first.weekday, firstDay, reason: 'semana ${i + 1}');
          expect(
            days.every((d) => d.hour == 0 && d.minute == 0),
            true,
            reason: 'semana ${i + 1}',
          );
        }
      },
    );
  }

  test('Analise semanal: mudar o idioma recalcula a semana atual', () async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final vm = AnalysisPageVM(PointsService(db));
    addTearDown(() async {
      vm.dispose();
      await db.close();
    });

    vm.setFirstDayOfWeek(0);
    vm.updateViewMode(AnalysisViewMode.week);
    await vm.getData();
    expect((vm.entries.keys.toList()..sort()).first.weekday, DateTime.sunday);

    vm.setFirstDayOfWeek(1);
    await vm.getData();
    final days = vm.entries.keys.toList()..sort();
    expect(days.length, 7); // previous week's days are not kept
    expect(days.first.weekday, DateTime.monday);
  });
}
