import 'package:flutter/foundation.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/app_feedback.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/utils/labels.dart';

class DefineHourValueConfigPageVM extends ChangeNotifier {
  final ConfigsService _configsService;
  List<HourValuePolitic> _rules = [];
  double? _baseHourValue = 0;
  double? _originalBaseHourValue = 0;

  DefineHourValueConfigPageVM(this._configsService) {
    loaded = Future.wait([_getHourValuePoliticRules(), _getHourValueBase()]);
  }

  // completes when the initial data is loaded
  late final Future<void> loaded;

  // Public Properties
  double? get baseHourValue => _baseHourValue;

  String get baseHourValueToSet => _baseHourValue.toString();

  List<HourValuePolitic> get rules => _rules;

  bool get valueHasChanged => _baseHourValue != _originalBaseHourValue;

  ///

  Future<void> _getHourValueBase() async {
    try {
      _baseHourValue = await _configsService.getHourValueBase();
      _originalBaseHourValue = _baseHourValue;
    } catch (e, s) {
      AppFeedback.showError(
        'DefineHourValueConfigPageVM._getHourValueBase',
        e,
        s,
        label: Labels.loadErrorMsg,
      );
    }

    _updateUI();
  }

  Future<void> _getHourValuePoliticRules() async {
    try {
      _rules = await _configsService.getHourValuePolitics();
    } catch (e, s) {
      AppFeedback.showError(
        'DefineHourValueConfigPageVM._getHourValuePoliticRules',
        e,
        s,
        label: Labels.loadErrorMsg,
      );
    }

    _updateUI();
  }

  void _updateUI() {
    notifyListeners();
  }

  void setBaseHourValue(double value) {
    _baseHourValue = value;
    _updateUI();
  }

  Future<void> saveHourValueBase() async {
    if (!valueHasChanged) return;

    try {
      await _configsService.updateHourValueBase(_baseHourValue!);
    } catch (e, s) {
      AppFeedback.showError(
        'DefineHourValueConfigPageVM.saveHourValueBase',
        e,
        s,
      );
      return; // keeps the value as unsaved
    }

    _originalBaseHourValue = _baseHourValue;
    _updateUI();
    AppFeedback.showSuccess(Labels.valueSaved);
  }

  Future<void> saveRule(
    HourValuePoliticsCompanion rule, {
    required bool isUpdate,
  }) async {
    String message = '';

    try {
      if (isUpdate) {
        var res = await _configsService.updateRule(rule);
        if (res > 0) message = HourValueRules.updateRuleMsg;
      } else {
        await _configsService.insertRule(rule);
        message = HourValueRules.insertRuleMsg;
      }
    } catch (e, s) {
      AppFeedback.showError('DefineHourValueConfigPageVM.saveRule', e, s);
    }

    await _getHourValuePoliticRules();

    if (message.isNotEmpty) AppFeedback.showSuccess(message);
  }

  Future<void> deleteRule(HourValuePolitic rule) async {
    try {
      await _configsService.deleteRule(rule);
      _rules.remove(rule);
      _updateUI();
    } catch (e, s) {
      AppFeedback.showError('DefineHourValueConfigPageVM.deleteRule', e, s);
    }
  }

  // leaving the page without saving -> back to the saved value
  void discardChanges() {
    _baseHourValue = _originalBaseHourValue;
    _updateUI();
  }
}
