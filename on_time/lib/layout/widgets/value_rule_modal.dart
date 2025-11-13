import 'package:drift/drift.dart' as drift;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/layout/widgets/numeric_keyboard.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/common_objs.dart';
import 'package:on_time/utils/labels.dart';

class ValueRuleModal extends StatefulWidget {
  final HourValuePolitic? currentRule;
  const ValueRuleModal({super.key, this.currentRule});

  @override
  State<ValueRuleModal> createState() => _ValueRuleModal();
}

class _ValueRuleModal extends State<ValueRuleModal> {
  late HourValuePolitic? currentRule = widget.currentRule;
  String? ruleDescription;
  String? ruleDay;
  double ruleValue = 0;
  TimeOfDay? ruleHour;
  TimeOfDay? workStartAtSchedule;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (currentRule != null) {
      isEdit = true;
      ruleDescription = currentRule?.ruleDescription;
      ruleDay = currentRule?.dayOffWeek;
      ruleValue = currentRule!.hourValue!;

      if (ruleDescription == HourValueRules.valueAfterXHoursRule) {
        ruleHour = TimeOfDay(
          hour: currentRule!.afterMinutesWorked! ~/ 60,
          minute: currentRule!.afterMinutesWorked! % 60,
        );
      } else if (ruleDescription == HourValueRules.valueAfterXScheduleRule) {
        ruleHour = TimeOfDay(
          hour: currentRule!.afterSchedule!.hour,
          minute: currentRule!.afterSchedule!.minute,
        );

        workStartAtSchedule = TimeOfDay(
          hour: currentRule!.workStartAt!.hour,
          minute: currentRule!.workStartAt!.minute,
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openNumericKeyboard(BuildContext context) async {
    final result = await NumericKeyboard.show(
      context,
      value: ruleValue.toString(),
    );

    if (result != null) {
      _setHourValueRule(result);
    }
  }

  Future<void> _setHourValueRule(double val) async {
    setState(() {
      ruleValue = val;
    });
  }

  Future<void> _pickTime(
    StateSetter setModalState, {
    bool isWorkStartSchedule = false,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: ruleHour ?? TimeOfDay(hour: 0, minute: 0),
    );
    if (picked != null) {
      setModalState(
        () =>
            isWorkStartSchedule
                ? workStartAtSchedule = picked
                : ruleHour = picked,
      );
    }
  }

  void _saveCurrentRule() {
    late HourValuePoliticsCompanion savedRule;
    bool canProceed = true;

    if (!ruleDescription.isNullOrEmpty && ruleValue > 0) {
      if (ruleDescription == HourValueRules.dayWeekRule) {
        if (!ruleDay.isNullOrEmpty) {
          savedRule = HourValuePoliticsCompanion(
            ruleDescription: drift.Value(ruleDescription!),
            hourValue: drift.Value(ruleValue),
            dayOffWeek: drift.Value(ruleDay),
            afterMinutesWorked: drift.Value(0),
            afterSchedule: drift.Value(null),
          );
        } else {
          canProceed = false;
        }
      } else if (ruleDescription == HourValueRules.valueAfterXHoursRule) {
        if (ruleHour != null) {
          savedRule = HourValuePoliticsCompanion(
            ruleDescription: drift.Value(ruleDescription!),
            hourValue: drift.Value(ruleValue),
            dayOffWeek: drift.Value(null),
            afterMinutesWorked: drift.Value(
              (ruleHour!.hour * 60) + ruleHour!.minute,
            ),
            afterSchedule: drift.Value(null),
          );
        } else {
          canProceed = false;
        }
      } else if (ruleDescription == HourValueRules.valueAfterXScheduleRule) {
        if (ruleHour != null && workStartAtSchedule != null) {
          savedRule = HourValuePoliticsCompanion(
            ruleDescription: drift.Value(ruleDescription!),
            hourValue: drift.Value(ruleValue),
            dayOffWeek: drift.Value(null),
            afterMinutesWorked: drift.Value(0),
            afterSchedule: drift.Value(
              DateTime(0, 1, 1, ruleHour!.hour, ruleHour!.minute),
            ),
            workStartAt: drift.Value(
              DateTime(
                0,
                1,
                1,
                workStartAtSchedule!.hour,
                workStartAtSchedule!.minute,
              ),
            ),
          );
        } else {
          canProceed = false;
        }
      }
    } else {
      canProceed = false;
    }

    if (!canProceed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            HourValueRules.newEditRuleWarning.tr(),
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.snackBarLight,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      Navigator.pop(context, savedRule);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  HourValueRules.newRule.tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // Regra
                DropdownButtonFormField<String>(
                  initialValue: ruleDescription,
                  decoration: InputDecoration(
                    labelText: HourValueRules.ruleType.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items:
                      CommonObjs.hourValueRulesDescriptions
                          .map(
                            (regra) => DropdownMenuItem(
                              value: regra,
                              child: Text(regra.tr()),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setModalState(() => ruleDescription = value);
                  },
                ),
                SizedBox(height: 16),

                // Campo condicional
                if (ruleDescription == HourValueRules.dayWeekRule) ...[
                  DropdownButtonFormField<String>(
                    initialValue: ruleDay,
                    decoration: InputDecoration(
                      labelText: HourValueRules.dayOfWeek.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items:
                        CommonObjs.daysOfWeek.map((day) {
                          return DropdownMenuItem(
                            value: day,
                            child: Text(day.tr()),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setModalState(() => ruleDay = value);
                    },
                  ),
                ] else ...[
                  InkWell(
                    onTap: () => _pickTime(setModalState),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText:
                            ruleDescription ==
                                    HourValueRules.valueAfterXHoursRule
                                ? HourValueRules.afterXHours.tr()
                                : HourValueRules.afterXSchedule.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        ruleHour != null
                            ? ruleHour!.format(context)
                            : HourValueRules.selectSchedule.tr(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 16),

                // if rule choosen is after schedule, we need to say at what time the work starts
                if (ruleDescription ==
                    HourValueRules.valueAfterXScheduleRule) ...[
                  InkWell(
                    onTap:
                        () =>
                            _pickTime(setModalState, isWorkStartSchedule: true),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: HourValueRules.workStartsAt.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        ruleHour != null
                            ? ruleHour!.format(context)
                            : HourValueRules.selectSchedule.tr(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],

                GestureDetector(
                  onTap: () => _openNumericKeyboard(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: HourValueRules.hourValue.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          GenericHelper.getCurrencyFormat(ruleValue),
                          style: TextStyle(fontSize: 16),
                        ),
                        const Icon(Icons.edit, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        Labels.cancel.tr(),
                        style: TextStyle(color: context.colors.actionsText),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _saveCurrentRule(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.softGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        Labels.save.tr(),
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
