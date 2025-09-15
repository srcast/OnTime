import 'package:drift/drift.dart';
import 'package:on_time/database/database.dart';

class ConfigsService {
  final AppDatabase db;

  ConfigsService(this.db);

  Future<void> ensureConfigExists() async {
    final existing = await db.select(db.configurations).get();

    if (existing.isEmpty) {
      await db
          .into(db.configurations)
          .insert(
            ConfigurationsCompanion.insert(
              id: Value(1),
              hourValueBase: Value(0),
              extraValue: Value(0),
              taxesPercentage: Value(0),
              valuesNotTaxable: Value(0),
            ),
          );
    }
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
}
