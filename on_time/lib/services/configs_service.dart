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
    try {
      var config =
          await (db.selectOnly(db.configurations)
            ..addColumns([db.configurations.hourValueBase])).getSingleOrNull();

      return config?.read<double>(db.configurations.hourValueBase);
    } catch (e, _) {
      return 0;
    }
  }

  Future<void> updateHourValueBase(double value) async {
    try {
      await (db.update(db.configurations)
        ..where((c) => c.id.equals(1))) // there is only one record
      .write(ConfigurationsCompanion(hourValueBase: Value(value)));
    } catch (e, _) {}
  }

  Future<List<HourValuePolitic>> getHourValuePolitics() async {
    try {
      return await (db.select(db.hourValuePolitics)
        ..orderBy([(r) => OrderingTerm(expression: r.id)])).get();
    } catch (e, _) {
      return [];
    }
  }

  Future<void> insertRule(HourValuePoliticsCompanion rule) async {
    try {
      await db.into(db.hourValuePolitics).insert(rule);
    } catch (e, _) {}
  }

  Future<void> deleteRule(HourValuePolitic ruleToDelete) async {
    try {
      (db.delete(db.hourValuePolitics)
        ..where((p) => p.id.equals(ruleToDelete.id))).go();
    } catch (e, _) {}
  }

  Future<int> updateRule(HourValuePoliticsCompanion ruleToUpdate) async {
    try {
      return await (db.update(db.hourValuePolitics)
        ..where((p) => p.id.equals(ruleToUpdate.id.value))).write(ruleToUpdate);
    } catch (e, _) {
      return 0;
    }
  }

  Future<Configuration?> getConfigs() async {
    try {
      return await db.select(db.configurations).getSingleOrNull();
    } catch (e, _) {
      return null;
    }
  }

  Future<void> setTheme(AppThemeMode themeMode) async {
    try {
      var theme = GenericHelper.getAppThemeAsString(themeMode);
      final config = await db.select(db.configurations).getSingleOrNull();
      if (config != null) {
        await (db.update(db.configurations)..where(
          (c) => c.id.equals(config.id),
        )).write(ConfigurationsCompanion(themeMode: Value(theme)));
      }
    } catch (e, _) {}
  }

  Future<void> setLanguage(LanguageOptions lang) async {
    try {
      var language = GenericHelper.getLanguageOptAsString(lang);
      final config = await db.select(db.configurations).getSingleOrNull();
      if (config != null) {
        await (db.update(db.configurations)..where(
          (c) => c.id.equals(config.id),
        )).write(ConfigurationsCompanion(language: Value(language)));
      }
    } catch (e, _) {}
  }

  Future<bool> hasSeenTutorial() async {
    try {
      final config = await db.select(db.configurations).getSingleOrNull();

      return config != null ? config.hasSeenTutorial : false;
    } catch (e, _) {
      return true;
    }
  }

  Future<void> updateHasSeenTutorial(bool hasSeenTutorial) async {
    try {
      await (db.update(db.configurations)..where((c) => c.id.equals(1))).write(
        ConfigurationsCompanion(hasSeenTutorial: Value(hasSeenTutorial)),
      );
    } catch (e, _) {}
  }

  Future<void> updateShowAds(bool showInterstitialAds) async {
    try {
      await (db.update(db.configurations)..where(
        (c) => c.id.equals(1),
      )).write(ConfigurationsCompanion(showAds: Value(showInterstitialAds)));
    } catch (e, _) {}
  }
}
