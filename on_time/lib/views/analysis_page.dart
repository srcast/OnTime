import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/layout/widgets/analysis_summary.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/analysis_page_vm.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  String _title(BuildContext context, AnalysisPageVM vm) {
    switch (vm.viewMode) {
      case AnalysisViewMode.week:
        final format = DateFormat(
          'dd/MM/yyyy',
          GenericHelper.getDeviceLocale(),
        );
        return '${format.format(vm.startDate)} - ${format.format(vm.endDate)}';
      case AnalysisViewMode.month:
        return DateFormat.yMMMM(
          Localizations.localeOf(context).toString(),
        ).format(vm.focusedDate);
      default:
        return vm.focusedDate.year.toString();
    }
  }

  List<BarChartGroupData> _barGroups(AnalysisPageVM vm) {
    return [
      for (final (index, value) in vm.chartValues.indexed)
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: value.hours,
              width: 20,
              color: AppColors.strongBlueLight,
              borderRadius: BorderRadius.circular(0),
            ),
          ],
        ),
    ];
  }

  String _barLabel(BuildContext context, AnalysisPageVM vm, int index) {
    if (index < 0 || index >= vm.chartValues.length) return '';

    final date = vm.chartValues[index].date;
    final locale = Localizations.localeOf(context).toString();

    return vm.viewMode == AnalysisViewMode.year
        ? DateFormat.MMM(locale).format(date) // Jan, Feb, Mar...
        : DateFormat.EEEEE(locale).format(date); // M, T, W...
  }

  void _goToSelectedDay(BuildContext context, DateTime selectedDay) {
    context.read<HomePageVM>().refreshDay(selectedDay);
    StatefulNavigationShell.of(context).goBranch(0);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AnalysisPageVM>();
    // first day of week follows the app language (same as the date picker)
    vm.setFirstDayOfWeek(MaterialLocalizations.of(context).firstDayOfWeekIndex);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 8),
                // Selector
                Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: context.colors.analysisSelectorBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // week
                      Expanded(
                        child: GestureDetector(
                          onTap: () => vm.updateViewMode(AnalysisViewMode.week),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  vm.viewMode == AnalysisViewMode.week
                                      ? AppColors.softGreen
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              AnalysisViewMode.week.tr(),
                              style: TextStyle(
                                color:
                                    vm.viewMode == AnalysisViewMode.week
                                        ? AppColors.white
                                        : AppColors.softGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Month
                      Expanded(
                        child: GestureDetector(
                          onTap:
                              () => vm.updateViewMode(AnalysisViewMode.month),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  vm.viewMode == AnalysisViewMode.month
                                      ? AppColors.softGreen
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              AnalysisViewMode.month.tr(),
                              style: TextStyle(
                                color:
                                    vm.viewMode == AnalysisViewMode.month
                                        ? AppColors.white
                                        : AppColors.softGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Year
                      Expanded(
                        child: GestureDetector(
                          onTap: () => vm.updateViewMode(AnalysisViewMode.year),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  vm.viewMode == AnalysisViewMode.year
                                      ? AppColors.softGreen
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              AnalysisViewMode.year.tr(),
                              style: TextStyle(
                                color:
                                    vm.viewMode == AnalysisViewMode.year
                                        ? AppColors.white
                                        : AppColors.softGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // arrows and title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => vm.goBackDate(),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: context.colors.focusColor,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _title(context, vm),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => vm.advanceDate(),
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: context.colors.focusColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                vm.viewMode == AnalysisViewMode.month
                    ? Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TableCalendar(
                            locale: Localizations.localeOf(context).toString(),
                            startingDayOfWeek:
                                StartingDayOfWeek.values[vm.firstDayOfWeek - 1],
                            firstDay: DateTime.utc(
                              vm.focusedDate.year - 5,
                              1,
                              1,
                            ),
                            lastDay: DateTime.utc(vm.focusedDate.year, 12, 31),
                            focusedDay: vm.focusedDate,
                            calendarFormat: CalendarFormat.month,
                            headerVisible: false,
                            calendarStyle: CalendarStyle(
                              todayDecoration: BoxDecoration(
                                color: AppColors.softBlue,
                                shape: BoxShape.circle,
                              ),
                              cellMargin: const EdgeInsets.all(2),
                              cellPadding: const EdgeInsets.only(bottom: 12),
                            ),
                            calendarBuilders: CalendarBuilders(
                              defaultBuilder: (context, day, _) {
                                final key = DateTime(
                                  day.year,
                                  day.month,
                                  day.day,
                                );
                                final value = vm.entries[key];
                                final minutes =
                                    value != null &&
                                            value[AnalysisMapEntriesEnum
                                                    .minutesWorked] !=
                                                null
                                        ? value[AnalysisMapEntriesEnum
                                                .minutesWorked] %
                                            60
                                        : 0;
                                final minutesTxt =
                                    minutes == 0
                                        ? ''
                                        : (minutes < 10)
                                        ? '0$minutes'
                                        : minutes;
                                return Container(
                                  margin: const EdgeInsets.all(2),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Column(
                                      children: [
                                        Text(
                                          '${day.day}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        value != null
                                            ? Text(
                                              '${value[AnalysisMapEntriesEnum.minutesWorked] ~/ 60}h$minutesTxt',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppColors.strongBlueLight,
                                              ),
                                            )
                                            : const SizedBox(
                                              height: 19,
                                            ), // saves space
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            onDaySelected:
                                (selectedDay, focusedDay) =>
                                    _goToSelectedDay(context, selectedDay),
                          ),
                        ),
                      ),
                    )
                    : // case its not month
                    // graph
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: BarChart(
                          BarChartData(
                            barGroups: _barGroups(vm),
                            maxY: vm.maxY,
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipItem: (
                                  group,
                                  groupIndex,
                                  rod,
                                  rodIndex,
                                ) {
                                  final value = rod.toY;
                                  return BarTooltipItem(
                                    '${value ~/ 1}h${((value % 1) * 60).toStringAsFixed(0)}',
                                    TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  );
                                },
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  interval: vm.stepY,
                                  getTitlesWidget:
                                      (value, _) => Text('${value.toInt()}h'),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, _) {
                                    final label = _barLabel(
                                      context,
                                      vm,
                                      value.toInt(),
                                    );
                                    return Text(
                                      label,
                                      style: TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(show: false),
                          ),
                        ),
                      ),
                    ),
                const SizedBox(height: 10),

                AnalysisSummary(
                  minutesWorked: vm.totalMinutes,
                  profit: vm.totalProfit,
                ),
              ],
            ),

            // Overlay de loading
            if (vm.isLoading)
              Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    color: context.colors.focusColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
