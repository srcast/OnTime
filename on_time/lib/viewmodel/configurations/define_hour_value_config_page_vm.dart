import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/layout/widgets/numeric_keyboard.dart';
import 'package:on_time/layout/widgets/value_rule_modal.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/labels.dart';

class DefineHourValueConfigPageVM extends ChangeNotifier {
  final ConfigsService _configsService;
  bool baseValueHasChanged = false;
  List<HourValuePolitic> _rules = [];
  double? _baseHourValue = 0;
  double? _originalBaseHourValue = 0;

  DefineHourValueConfigPageVM(this._configsService) {
    getHourValuePoliticRules();
    getHourValueBase();
  }

  // Public Properties
  String get baseHourValue =>
      NumberFormat.simpleCurrency(locale: 'pt_PT').format(_baseHourValue);

  String get baseHourValueToSet => _baseHourValue.toString();

  List<HourValuePolitic> get rules => _rules;

  bool get valueHasChanged => _baseHourValue != _originalBaseHourValue;

  ///

  Future<void> getHourValueBase() async {
    _baseHourValue = await _configsService.getHourValueBase();
    _originalBaseHourValue = _baseHourValue;
  }

  Future<void> saveHourValueBase(BuildContext context) async {
    if (valueHasChanged) {
      await _configsService.updateHourValueBase(_baseHourValue!);
      _originalBaseHourValue = _baseHourValue;
      updateUI();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Labels.valueSaved),
          backgroundColor: AppColors.greenDisabled,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> getHourValuePoliticRules() async {
    _rules = await _configsService.getHourValuePolitics();
    updateUI();
  }

  Future<void> setHourValueBase(double val) async {
    _baseHourValue = val;
    //await saveHourValueBase();
    updateUI();
  }

  void updateUI() {
    notifyListeners();
  }

  void openNumericKeyboard(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 24,
            left: 16,
            right: 16,
          ),
          child: NumericKeyboard(
            value: baseHourValueToSet,
            onSetValue: (value) => setHourValueBase(value),
          ),
        );
      },
    );
  }

  Future<void> openRuleModal(
    BuildContext context,
    HourValuePolitic? currentRule,
  ) async {
    final rule = await showModalBottomSheet<HourValuePoliticsCompanion>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ValueRuleModal(currentRule: currentRule),
    );

    if (rule != null) {
      String message = '';

      // update
      if (currentRule != null) {
        _configsService.updateRule(rule);
        message = HourValueRules.updateRuleMsg;
      }
      // insert
      else {
        _configsService.insertRule(rule);
        message = HourValueRules.insertRuleMsg;
      }

      getHourValuePoliticRules();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.greenDisabled,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void deleteRule(BuildContext context, HourValuePolitic rule) async {
    bool? response = false;
    response = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(Labels.warning),
            content: Text(HourValueRules.deleteRuleMsg),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(Labels.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(Labels.delete),
              ),
            ],
          ),
    );

    if (response!) {
      _configsService.deleteRule(rule);
      _rules.remove(rule);
      updateUI();
    }
  }
}
