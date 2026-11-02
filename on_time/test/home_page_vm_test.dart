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
}
