import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/tutorial/tutorial_flow.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:on_time/views/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  late AppDatabase db;
  late ConfigsService configsService;

  setUp(() async {
    db = AppDatabase(executor: NativeDatabase.memory());
    configsService = ConfigsService(db);
    await configsService.ensureConfigExists();
  });

  tearDown(() => db.close());

  Future<bool> savedHasSeen() async =>
      (await configsService.getConfigs())!.hasSeenTutorial;

  group('TutorialFlow', () {
    test('Comeca na home se ainda nao foi visto', () {
      expect(
        TutorialFlow(configsService, hasSeenTutorial: false).step,
        TutorialStep.home,
      );
      expect(
        TutorialFlow(configsService, hasSeenTutorial: true).isActive,
        false,
      );
    });

    test('Passos por ordem e so fica visto no fim', () async {
      final flow = TutorialFlow(configsService, hasSeenTutorial: false);

      await flow.advance();
      expect(flow.step, TutorialStep.configurations);
      await flow.advance();
      expect(flow.step, TutorialStep.hourValue);
      expect(await savedHasSeen(), false);

      await flow.advance();
      expect(flow.step, TutorialStep.done);
      expect(await savedHasSeen(), true);

      await flow.advance(); // nothing after the end
      expect(flow.step, TutorialStep.done);
    });

    test('Saltar termina e grava como visto', () async {
      final flow = TutorialFlow(configsService, hasSeenTutorial: false);

      await flow.skip();
      expect(flow.isActive, false);
      expect(await savedHasSeen(), true);
    });

    test('Rever volta ao inicio e grava como nao visto', () async {
      await configsService.updateHasSeenTutorial(true);
      final flow = TutorialFlow(configsService, hasSeenTutorial: true);

      await flow.restart();
      expect(flow.step, TutorialStep.home);
      expect(await savedHasSeen(), false);
    });
  });

  group('Home durante o tutorial', () {
    late HomePageVM vm;

    setUp(() async {
      final pointsService = PointsService(db);
      final today = DateTime.now();
      await pointsService.insertPoint(
        DateTime(today.year, today.month, today.day, 8, 15),
      );
      vm = HomePageVM(pointsService, configsService);
      await vm.verifyDate();
    });

    tearDown(() => vm.dispose());

    Future<void> pumpHome(WidgetTester tester, TutorialFlow flow) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: vm),
            ChangeNotifierProvider.value(value: flow),
          ],
          child: MaterialApp(
            theme: lightTheme,
            home: const Scaffold(body: HomePage()),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('Tutorial visto: mostra os pontos gravados', (tester) async {
      await pumpHome(
        tester,
        TutorialFlow(configsService, hasSeenTutorial: true),
      );

      expect(find.textContaining('08:15'), findsOneWidget);
      expect(find.textContaining('10:00'), findsNothing);
    });

    testWidgets('No passo da home: mostra so o ponto de exemplo', (
      tester,
    ) async {
      await pumpHome(
        tester,
        TutorialFlow(configsService, hasSeenTutorial: false),
      );

      expect(find.textContaining('10:00'), findsOneWidget);
      expect(find.textContaining('08:15'), findsNothing);

      // overlay started by the page -> skip closes it and shows the saved points
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(find.text(TutorialLabels.skip));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('08:15'), findsOneWidget);
      expect(find.textContaining('10:00'), findsNothing);
    });

    testWidgets('Fora do passo da home: mostra os pontos gravados', (
      tester,
    ) async {
      final flow = TutorialFlow(configsService, hasSeenTutorial: false);
      await flow.advance(); // at configurations

      await pumpHome(tester, flow);

      expect(find.textContaining('08:15'), findsOneWidget);
      expect(find.textContaining('10:00'), findsNothing);
    });
  });
}
