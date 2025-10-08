import 'package:drift/drift.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/utils/enums.dart';

class ConfigsService {
  final AppDatabase db;

  ConfigsService(this.db);

  Future<Configuration> ensureConfigExists() async {
    var existing = await db.select(db.configurations).get();

    if (existing.isEmpty) {
      await db
          .into(db.configurations)
          .insert(
            ConfigurationsCompanion.insert(
              id: Value(1),
              hourValueBase: Value(0),
              themeMode: Value(
                GenericHelper.getAppThemeAsString(AppThemeMode.light),
              ),
              language: Value(
                GenericHelper.getLanguageOptAsString(LanguageOptions.english),
              ),
            ),
          );
    }

    existing = await db.select(db.configurations).get();

    return existing.first;
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

  Future<Configuration?> getConfigs() async {
    return await db.select(db.configurations).getSingleOrNull();
  }

  Future<void> setTheme(AppThemeMode themeMode) async {
    var theme = GenericHelper.getAppThemeAsString(themeMode);
    final config = await db.select(db.configurations).getSingleOrNull();
    if (config != null) {
      await (db.update(db.configurations)..where(
        (c) => c.id.equals(config.id),
      )).write(ConfigurationsCompanion(themeMode: Value(theme)));
    }
  }

  Future<void> setLanguage(LanguageOptions lang) async {
    var language = GenericHelper.getLanguageOptAsString(lang);
    final config = await db.select(db.configurations).getSingleOrNull();
    if (config != null) {
      await (db.update(db.configurations)..where(
        (c) => c.id.equals(config.id),
      )).write(ConfigurationsCompanion(language: Value(language)));
    }
  }
}
