import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/app_feedback.dart';
import 'package:on_time/helpers/tutorial_helper.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DefineHourValueConfigPageVM extends ChangeNotifier {
  final ConfigsService _configsService;
  List<HourValuePolitic> _rules = [];
  double? _baseHourValue = 0;
  double? _originalBaseHourValue = 0;
  TutorialCoachMark _tutorial = TutorialCoachMark(targets: []);
  bool _tutorialManualClose = false;

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

  final GlobalKey keyHourValueInput = GlobalKey();
  final GlobalKey keySaveHourValue = GlobalKey();
  final GlobalKey keySpecialRules = GlobalKey();

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

  void checkTutorial(BuildContext context) {
    if (!TutorialHelper.hasSeenTutorial) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _closeTutorial();
        _startTutorial(context);
      });
    }
  }

  void _closeTutorial() {
    _tutorialManualClose = false;
    _tutorial.finish();
    _tutorialManualClose = true;
  }

  void _startTutorial(BuildContext context) {
    _tutorial = TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: TutorialIdentifiers.hourValueInput,
          keyTarget: keyHourValueInput,
          shape: ShapeLightFocus.RRect,
          radius: 16,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TutorialLabels.configHourValueInput.tr(),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: TutorialIdentifiers.saveHourValue,
          keyTarget: keySaveHourValue,
          shape: ShapeLightFocus.RRect,
          radius: 16,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TutorialLabels.configSaveHourValue.tr(),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: TutorialIdentifiers.specialRules,
          keyTarget: keySpecialRules,
          shape: ShapeLightFocus.RRect,
          radius: 16,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TutorialLabels.configSpecialRules.tr(),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ],
      colorShadow: Colors.black54,
      textSkip: TutorialLabels.skip.tr(),
      opacityShadow: 0.6,
      onFinish: () async {
        await _cancelTutorial(context);
        return true;
      },
      onSkip: () {
        _cancelTutorial(context);
        return true;
      },
    );
    _tutorial.show(context: Overlay.of(context).context);
  }

  Future<void> _cancelTutorial(BuildContext context) async {
    if (_tutorialManualClose) {
      await TutorialHelper.cancelTutorial();
      context.read<HomePageVM>().initPage();

      final shell = StatefulNavigationShell.of(context);
      // clean current branch
      shell.goBranch(2, initialLocation: true);
      await Future.delayed(const Duration(milliseconds: 300));
      shell.goBranch(0);
    }
  }
}
