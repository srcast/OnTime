import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/layout/widgets/dialog.dart';
import 'package:on_time/layout/widgets/numeric_keyboard.dart';
import 'package:on_time/layout/widgets/value_rule_modal.dart';
import 'package:on_time/router/routes.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
  double? get baseHourValue => _baseHourValue;

  String get baseHourValueToSet => _baseHourValue.toString();

  List<HourValuePolitic> get rules => _rules;

  bool get valueHasChanged => _baseHourValue != _originalBaseHourValue;

  final GlobalKey keyHourValueInput = GlobalKey();
  final GlobalKey keySaveHourValue = GlobalKey();
  final GlobalKey keySpecialRules = GlobalKey();

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
          content: Text(Labels.valueSaved.tr()),
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
    final result = await NumericKeyboard.show(
      context,
      value: baseHourValueToSet,
    );

    if (result != null) {
      setHourValueBase(result);
    }
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
        message = HourValueRules.updateRuleMsg.tr();
      }
      // insert
      else {
        _configsService.insertRule(rule);
        message = HourValueRules.insertRuleMsg.tr();
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
    bool response = false;

    response = await DialogPopup.show(
      context,
      title: Labels.warning.tr(),
      message: HourValueRules.deleteRuleMsg.tr(),
      negativeResponse: Labels.cancel.tr(),
      positiveResponse: Labels.delete.tr(),
    );

    if (response) {
      _configsService.deleteRule(rule);
      _rules.remove(rule);
      updateUI();
    }
  }

  void goBack(BuildContext context) async {
    if (valueHasChanged) {
      bool response = await DialogPopup.show(
        context,
        title: Labels.warning.tr(),
        message: HourValueRules.unsavedChangesMsg.tr(),
      );

      if (response) {
        resetUnsavingChanges();
        context.pop();
      }
    } else {
      context.pop();
    }
  }

  void resetUnsavingChanges() {
    _baseHourValue = _originalBaseHourValue;
  }

  void checkTutorial(BuildContext context) {
    final uri = Uri.parse(GoRouterState.of(context).uri.toString());
    final startTutorial = uri.queryParameters['startTutorial'] == 'true';

    if (startTutorial) {
      _startTutorial(context);
    }
  }

  void _startTutorial(BuildContext context) {
    TutorialCoachMark(
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
    ).show(context: Overlay.of(context).context);
  }

  Future<void> _cancelTutorial(BuildContext context) async {
    await _configsService.updateHasSeenTutorial(true);
    context.pop();
    context.go(Routes.homePage);
  }
}
