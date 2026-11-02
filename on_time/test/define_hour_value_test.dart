import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/tutorial_helper.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/configurations/define_hour_value_config_page_vm.dart';
import 'package:on_time/views/configurations/define_hour_value_config_page.dart';
import 'package:provider/provider.dart';

void main() {
  late AppDatabase db;
  late ConfigsService configsService;
  late DefineHourValueConfigPageVM vm;

  setUp(() async {
    TutorialHelper.hasSeenTutorial = true;
    db = AppDatabase(executor: NativeDatabase.memory());
    configsService = ConfigsService(db);
    await configsService.ensureConfigExists();
    await configsService.updateHourValueBase(10);
    vm = DefineHourValueConfigPageVM(configsService);
    await vm.loaded;
  });

  tearDown(() async {
    vm.dispose();
    await db.close();
  });

  HourValuePoliticsCompanion dayRule(double value) =>
      HourValuePoliticsCompanion.insert(
        ruleDescription: HourValueRules.dayWeekRule,
        hourValue: Value(value),
        dayOffWeek: Value('sunday'),
      );

  group('ViewModel do valor/hora', () {
    test('Gravar o valor base deixa de estar por guardar', () async {
      expect(vm.baseHourValue, 10);

      vm.setBaseHourValue(12.5);
      expect(vm.valueHasChanged, true);

      await vm.saveHourValueBase();
      expect(vm.valueHasChanged, false);
      expect(await configsService.getHourValueBase(), 12.5);
    });

    test('Falha ao gravar mantem o valor por guardar', () async {
      vm.setBaseHourValue(12.5);
      await db.close();

      await vm.saveHourValueBase(); // must not throw
      expect(vm.valueHasChanged, true);
    });

    test('Descartar repoe o valor gravado', () {
      vm.setBaseHourValue(99);
      vm.discardChanges();

      expect(vm.baseHourValue, 10);
      expect(vm.valueHasChanged, false);
    });

    test('Inserir, atualizar e apagar regras', () async {
      await vm.saveRule(dayRule(15), isUpdate: false);
      expect(vm.rules.length, 1);
      expect(vm.rules.first.hourValue, 15);

      final updated = vm.rules.first
          .toCompanion(true)
          .copyWith(hourValue: Value(20));
      await vm.saveRule(updated, isUpdate: true);
      expect(vm.rules.single.hourValue, 20);

      await vm.deleteRule(vm.rules.first);
      expect(vm.rules, isEmpty);
      expect(await configsService.getHourValuePolitics(), isEmpty);
    });
  });

  group('Sair com alteracoes por guardar', () {
    // home page -> pushes the hour value page
    Future<void> openPage(WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: vm,
          child: MaterialApp(
            theme: lightTheme,
            home: Builder(
              builder:
                  (context) => TextButton(
                    onPressed:
                        () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const DefineHourValueConfigPage(),
                          ),
                        ),
                    child: const Text('open'),
                  ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    final page = find.byType(DefineHourValueConfigPage);
    final dialogMessage = find.text(HourValueRules.unsavedChangesMsg);

    testWidgets('Sem alteracoes sai sem perguntar', (tester) async {
      await openPage(tester);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(dialogMessage, findsNothing);
      expect(page, findsNothing);
    });

    testWidgets('Seta: pergunta, "nao" fica, "sim" descarta e sai', (
      tester,
    ) async {
      await openPage(tester);
      vm.setBaseHourValue(99);
      await tester.pump();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(dialogMessage, findsOneWidget);

      await tester.tap(find.text(Labels.no));
      await tester.pumpAndSettle();
      expect(page, findsOneWidget);
      expect(vm.valueHasChanged, true);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await tester.tap(find.text(Labels.yes));
      await tester.pumpAndSettle();
      expect(page, findsNothing);
      expect(vm.valueHasChanged, false);
      expect(vm.baseHourValue, 10);
    });

    testWidgets(
      'iOS: gesto de voltar desligado so com alteracoes por guardar',
      (tester) async {
        await openPage(tester);
        final route = ModalRoute.of(tester.element(page))!;
        expect(route.popGestureEnabled, true);

        vm.setBaseHourValue(99);
        await tester.pump();
        expect(route.popGestureEnabled, false);

        vm.discardChanges();
        await tester.pump();
        expect(route.popGestureEnabled, true);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.iOS),
    );

    testWidgets('Voltar do sistema (Android) tambem pergunta', (tester) async {
      await openPage(tester);
      vm.setBaseHourValue(99);
      await tester.pump();

      // same as the android back button / gesture
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(dialogMessage, findsOneWidget);
      expect(page, findsOneWidget);

      await tester.tap(find.text(Labels.yes));
      await tester.pumpAndSettle();
      expect(page, findsNothing);
    });
  });
}
