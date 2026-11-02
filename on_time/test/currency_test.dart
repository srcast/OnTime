import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/services/configs_service.dart';

void main() {
  tearDown(() => GenericHelper.selectedCurrencyCode = null);

  test('Moeda do pais do dispositivo', () {
    expect(
      GenericHelper.getDeviceCurrencyCode(const Locale('pt', 'PT')),
      'EUR',
    );
    expect(
      GenericHelper.getDeviceCurrencyCode(const Locale('en', 'US')),
      'USD',
    );
    expect(
      GenericHelper.getDeviceCurrencyCode(const Locale('en', 'GB')),
      'GBP',
    );
  });

  test('Regiao desconhecida nao rebenta e usa EUR', () {
    expect(
      GenericHelper.getDeviceCurrencyCode(const Locale('es', '419')),
      'EUR',
    );
  });

  test('Moeda escolhida tem prioridade sobre a do dispositivo', () {
    GenericHelper.selectedCurrencyCode = 'JPY';
    expect(GenericHelper.getCurrencyCode(), 'JPY');
    expect(GenericHelper.getCurrencyFormat(10), contains('¥'));

    GenericHelper.selectedCurrencyCode = null;
    expect(
      GenericHelper.getCurrencyCode(),
      GenericHelper.getDeviceCurrencyCode(),
    );
  });

  test(
    'Migracao v2 -> v3 acrescenta a moeda sem perder configuracoes',
    () async {
      final dir = await Directory.systemTemp.createTemp('ontime_migration_v3');
      final file = File('${dir.path}/db.sqlite');

      var db = AppDatabase(executor: NativeDatabase(file));
      await db
          .into(db.configurations)
          .insert(
            ConfigurationsCompanion.insert(
              id: Value(1),
              hourValueBase: Value(12.5),
              language: Value('portuguese'),
            ),
          );
      // v2 schema had no currency_code
      await db.customStatement(
        'ALTER TABLE configurations DROP COLUMN currency_code',
      );
      await db.customStatement('PRAGMA user_version = 2');
      await db.close();

      // reopen -> upgrade runs
      db = AppDatabase(executor: NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      var config = await db.select(db.configurations).getSingle();
      expect(config.hourValueBase, 12.5);
      expect(config.language, 'portuguese');
      expect(config.currencyCode, isNull);

      await ConfigsService(db).setCurrency('GBP');
      config = await db.select(db.configurations).getSingle();
      expect(config.currencyCode, 'GBP');
    },
  );
}
