import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/helpers/tutorial_helper.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late HomePageVM vm;

  setUp(() async {
    db = AppDatabase(executor: NativeDatabase.memory());
    final configsService = ConfigsService(db);
    await configsService.ensureConfigExists();
    TutorialHelper.hasSeenTutorial = true;
    vm = HomePageVM(PointsService(db), configsService);
  });

  tearDown(() async {
    vm.dispose();
    await db.close();
  });

  test('Ao iniciar consegue ir para o dia anterior', () async {
    vm.changeDate('-');
    await Future.delayed(const Duration(milliseconds: 1500)); // timer ticks

    final yesterday = DatesHelper.getDatetimeToday().subtract(
      const Duration(days: 1),
    );
    expect(DatesHelper.getSessionFromDate(vm.date), yesterday);
    expect(vm.timerVisible, false);
  });

  group('Acoes sobre pontos', () {
    final today = DatesHelper.getDatetimeToday();
    final pastDay = DatesHelper.addDays(today, -3);
    DateTime at(DateTime day, int hour) =>
        DateTime(day.year, day.month, day.day, hour);

    setUp(() => ConfigsService(db).updateHourValueBase(10));

    test('Registar hoje mostra os pontos e o resumo do dia', () async {
      await vm.addPoint(at(today, 8));
      await vm.addPoint(at(today, 12));

      expect(vm.points.length, 2);
      expect(vm.sessionMinutes, 240);
      expect(vm.sessionProfit, 40);
      expect(vm.timerVisible, true);
    });

    test('Registar noutro dia mostra esse dia e para o relogio', () async {
      await vm.addPoint(at(pastDay, 9));
      await vm.addPoint(at(pastDay, 17));

      expect(DatesHelper.getSessionFromDate(vm.date), pastDay);
      expect(vm.timerVisible, false);
      expect(vm.points.length, 2);
      expect(vm.sessionMinutes, 480);
      expect(vm.sessionProfit, 80);
      expect(vm.hourValueBase, 10);
    });

    test('Editar e apagar atualizam o resumo', () async {
      await vm.addPoint(at(pastDay, 9));
      await vm.addPoint(at(pastDay, 17));

      await vm.updatePoint(vm.points[1], at(pastDay, 13));
      expect(vm.points.map((p) => p.date.hour), [9, 13]);
      expect(vm.sessionMinutes, 240);

      await vm.deletePoint(vm.points[1]);
      expect(vm.points.length, 1);
      expect(vm.sessionMinutes, 0);
    });

    test('Erro ao gravar nao rebenta e nao mostra dados falsos', () async {
      await db.close();

      await vm.addPoint(at(pastDay, 9)); // must not throw

      expect(vm.points, isEmpty);
      expect(vm.sessionMinutes, 0);
    });
  });
}
