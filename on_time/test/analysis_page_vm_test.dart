import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/analysis_page_vm.dart';

void main() {
  late AppDatabase db;
  late PointsService pointsService;
  late AnalysisPageVM vm;

  setUp(() async {
    db = AppDatabase(executor: NativeDatabase.memory());
    await ConfigsService(db).ensureConfigExists();
    pointsService = PointsService(db);
    vm = AnalysisPageVM(pointsService);
    vm.setFirstDayOfWeek(1); // monday
  });

  tearDown(() async {
    vm.dispose();
    await db.close();
  });

  Future<void> work(DateTime day, int fromHour, int toHour) async {
    await pointsService.insertPoint(
      DateTime(day.year, day.month, day.day, fromHour),
    );
    await pointsService.insertPoint(
      DateTime(day.year, day.month, day.day, toHour),
    );
  }

  test('Semana: 7 barras com as horas de cada dia', () async {
    vm.updateViewMode(AnalysisViewMode.week);
    final monday = vm.startDate;
    await work(monday, 9, 16); // 7h
    await work(DatesHelper.addDays(monday, 2), 9, 11); // 2h

    await vm.getData();

    expect(vm.chartValues.map((v) => v.date).toList(), [
      for (int i = 0; i < 7; i++) DatesHelper.addDays(monday, i),
    ]);
    expect(vm.chartValues.map((v) => v.hours), [7, 0, 2, 0, 0, 0, 0]);
    expect(vm.totalMinutes, 540);
  });

  test('Ano: 12 barras com as horas somadas por mes', () async {
    final year = DateTime.now().year;
    await work(DateTime(year, 1, 10), 9, 12); // 3h
    await work(DateTime(year, 1, 11), 9, 11); // 2h
    await work(DateTime(year, 3, 5), 9, 10); // 1h

    vm.updateViewMode(AnalysisViewMode.year);
    await vm.getData();

    expect(vm.chartValues.length, 12);
    expect(vm.chartValues.first.date, DateTime(year, 1));
    expect(vm.chartValues.map((v) => v.hours).take(4), [5, 0, 1, 0]);
    expect(vm.totalMinutes, 360);
  });

  group('Escala do grafico (5 passos de horas inteiras)', () {
    test('Maximo de 7h -> passos de 2h ate 10h', () async {
      vm.updateViewMode(AnalysisViewMode.week);
      await work(vm.startDate, 9, 16);
      await vm.getData();

      expect(vm.stepY, 2);
      expect(vm.maxY, 10);
    });

    test('Maximo de 10h -> passos de 2h ate 10h', () async {
      vm.updateViewMode(AnalysisViewMode.week);
      await work(vm.startDate, 8, 18);
      await vm.getData();

      expect(vm.stepY, 2);
      expect(vm.maxY, 10);
    });

    test('Sem dados -> passos de 1h ate 5h', () async {
      vm.updateViewMode(AnalysisViewMode.week);
      await vm.getData();

      expect(vm.stepY, 1);
      expect(vm.maxY, 5);
    });
  });
}
