import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/layout/widgets/dialog.dart';
import 'package:on_time/layout/widgets/numeric_keyboard.dart';
import 'package:on_time/layout/widgets/value_rule_modal.dart';
import 'package:on_time/tutorial/configurations_tutorials.dart';
import 'package:on_time/tutorial/tutorial_flow.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/configurations/define_hour_value_config_page_vm.dart';
import 'package:provider/provider.dart';

class DefineHourValueConfigPage extends StatefulWidget {
  const DefineHourValueConfigPage({super.key});

  @override
  State<DefineHourValueConfigPage> createState() =>
      _DefineHourValueConfigPageState();
}

class _DefineHourValueConfigPageState extends State<DefineHourValueConfigPage> {
  Future<void> _openNumericKeyboard(DefineHourValueConfigPageVM vm) async {
    final value = await NumericKeyboard.show(
      context,
      value: vm.baseHourValueToSet,
    );
    if (value != null) vm.setBaseHourValue(value);
  }

  Future<void> _openRuleModal(
    DefineHourValueConfigPageVM vm,
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
      await vm.saveRule(rule, isUpdate: currentRule != null);
    }
  }

  Future<void> _deleteRule(
    DefineHourValueConfigPageVM vm,
    HourValuePolitic rule,
  ) async {
    final confirmed = await DialogPopup.show(
      context,
      title: Labels.warning.tr(),
      message: HourValueRules.deleteRuleMsg.tr(),
      negativeResponse: Labels.cancel.tr(),
      positiveResponse: Labels.delete.tr(),
    );
    if (confirmed) await vm.deleteRule(rule);
  }

  final _tutorialKeys = HourValueTutorialKeys();
  bool _tutorialStarted = false;

  // tutorial at this page -> shown once, after the page transition
  void _startTutorialOnce(TutorialFlow tutorial) {
    if (!tutorial.isAt(TutorialStep.hourValue)) {
      _tutorialStarted = false;
      return;
    }
    if (_tutorialStarted) return;
    _tutorialStarted = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) showHourValueTutorial(context, _tutorialKeys, tutorial);
    });
  }

  // leaving with unsaved value -> asks before discarding it
  Future<void> _confirmLeave(DefineHourValueConfigPageVM vm) async {
    final confirmed = await DialogPopup.show(
      context,
      title: Labels.warning.tr(),
      message: HourValueRules.unsavedChangesMsg.tr(),
    );
    if (!confirmed || !mounted) return;

    vm.discardChanges();
    Navigator.of(context).pop(); // pop ignores PopScope
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DefineHourValueConfigPageVM>();
    _startTutorialOnce(context.watch<TutorialFlow>());

    // all the ways of leaving go through here:
    // app bar arrow (maybePop), android back button/gesture (also predictive back)
    // iOS: swipe back is disabled while there are unsaved changes (canPop false), the arrow asks
    return PopScope(
      canPop: !vm.valueHasChanged,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave(vm);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(Labels.configsListHourValue.tr()),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          backgroundColor: context.colors.scaffoldBackground,
          foregroundColor: context.colors.titleText,
          elevation: 0,
        ),
        backgroundColor: context.colors.scaffoldBackground,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                Labels.defineBaseValueHour.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.colors.defaultText,
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => _openNumericKeyboard(vm),
                child: Container(
                  key: _tutorialKeys.hourValueInput,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        GenericHelper.getCurrencyFormat(vm.baseHourValue ?? 0),
                        style: TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.edit, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                key: _tutorialKeys.saveHourValue,
                onPressed: () => vm.saveHourValueBase(),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      vm.valueHasChanged
                          ? AppColors.softGreen
                          : AppColors.greenDisabled,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(Labels.save.tr()),
              ),
              SizedBox(height: 24),
              Text(
                Labels.specialRules.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.colors.defaultText,
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                key: _tutorialKeys.specialRules,
                onPressed: () => _openRuleModal(vm, null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.softGreen,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(Labels.addNewRule.tr()),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: vm.rules.length,
                  separatorBuilder: (_, _) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final regra = vm.rules[index];
                    return Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            regra.ruleDescription == HourValueRules.dayWeekRule
                                ? Icons.calendar_today
                                : Icons.access_time,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  regra.ruleDescription.tr(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  regra.ruleDescription ==
                                          HourValueRules.dayWeekRule
                                      ? '${HourValueRules.day.tr()}: ${regra.dayOffWeek!.tr()}\n${HourValueRules.value.tr()}: ${GenericHelper.getCurrencyFormat(regra.hourValue ?? 0)}'
                                      : (regra.ruleDescription ==
                                              HourValueRules
                                                  .valueAfterXScheduleRule
                                          ? '${HourValueRules.afterSchedule.tr()}: ${regra.afterSchedule!.hour}h ${regra.afterSchedule!.minute < 10 ? '0' : ''}${regra.afterSchedule!.minute}min \n${HourValueRules.value.tr()}: ${GenericHelper.getCurrencyFormat(regra.hourValue ?? 0)}'
                                          : '${HourValueRules.afterHours.tr()}: ${regra.afterMinutesWorked! ~/ 60}h ${regra.afterMinutesWorked! % 60 < 10 ? '0' : ''}${regra.afterMinutesWorked! % 60}min \n${HourValueRules.value.tr()}: ${GenericHelper.getCurrencyFormat(regra.hourValue ?? 0)}'),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: AppColors.editButton,
                                ),
                                onPressed: () => _openRuleModal(vm, regra),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: AppColors.deleteButton,
                                ),
                                onPressed: () => _deleteRule(vm, regra),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
