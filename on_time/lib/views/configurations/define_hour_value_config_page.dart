import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/configurations/define_hour_value_config_page_vm.dart';
import 'package:provider/provider.dart';

class DefineHourValueConfigPage extends StatefulWidget {
  const DefineHourValueConfigPage({super.key});

  @override
  State<DefineHourValueConfigPage> createState() =>
      _DefineHourValueConfigPage();
}

class _DefineHourValueConfigPage extends State<DefineHourValueConfigPage> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DefineHourValueConfigPageVM>();

    return Scaffold(
      appBar: AppBar(
        title: Text(Labels.configsListHourValue),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => vm.goBack(context),
        ),
        backgroundColor: AppColors.backgroundLightGray,
        foregroundColor: AppColors.labelMediumGray,
        elevation: 0,
      ),
      backgroundColor: AppColors.backgroundLightGray, // cor de fundo clara
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Labels.defineBaseValueHour,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.defaultText,
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () => vm.openNumericKeyboard(context),
              child: Container(
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
                    Text(vm.baseHourValue, style: TextStyle(fontSize: 16)),
                    const Icon(Icons.edit, color: Colors.grey),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => vm.saveHourValueBase(context),
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
              child: Text(Labels.save),
            ),
            SizedBox(height: 24),
            Text(
              Labels.specialRules,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.defaultText,
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => vm.openRuleModal(context, null),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.softGreen,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(Labels.addNewRule),
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
                      color: AppColors.white,
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
                                regra.ruleDescription,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                regra.ruleDescription ==
                                        HourValueRules.dayWeekRule
                                    ? 'Dia: ${regra.dayOffWeek}\nValor: ${NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(regra.hourValue)}'
                                    : (regra.ruleDescription ==
                                            HourValueRules
                                                .valueAfterXScheduleRule
                                        ? 'Após horário: ${regra.afterSchedule!.hour}h ${regra.afterSchedule!.minute < 10 ? '0' : ''}${regra.afterSchedule!.minute}min \nValor: ${NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(regra.hourValue)}'
                                        : 'Após X horas: ${regra.afterMinutesWorked! ~/ 60}h ${regra.afterMinutesWorked! % 60 < 10 ? '0' : ''}${regra.afterMinutesWorked! % 60}min \nValor: ${NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(regra.hourValue)}'),
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
                              onPressed: () => vm.openRuleModal(context, regra),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: AppColors.deleteButton,
                              ),
                              onPressed: () => vm.deleteRule(context, regra),
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
    );
  }
}
