import 'package:flutter/material.dart';
import 'package:on_time/layout/widgets/analysis_summary.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/analysis_page_vm.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AnalysisPageVM>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 8),
                // Selector (Semana / Mês / Ano)
                Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7ECE7), // Fundo claro
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
                              AnalysisViewMode.week,
                              style: TextStyle(
                                color:
                                    vm.viewMode == AnalysisViewMode.week
                                        ? Colors.white
                                        : AppColors.softGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // month
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
                              AnalysisViewMode.month,
                              style: TextStyle(
                                color:
                                    vm.viewMode == AnalysisViewMode.month
                                        ? Colors.white
                                        : AppColors.softGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // year
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
                              AnalysisViewMode.year,
                              style: TextStyle(
                                color:
                                    vm.viewMode == AnalysisViewMode.year
                                        ? Colors.white
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
                          color: AppColors.strongBlue,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              vm.viewModeTitle,
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
                          color: AppColors.strongBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                if (vm.viewMode == AnalysisViewMode.month)
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TableCalendar(
                          locale: "pt-Pt",
                          firstDay: DateTime.utc(vm.focusedDate.year - 5, 1, 1),
                          lastDay: DateTime.utc(vm.focusedDate.year, 12, 31),
                          focusedDay: DateTime(2025, 8, 1),
                          calendarFormat: CalendarFormat.month,
                          headerVisible: false,
                          // daysOfWeekStyle: DaysOfWeekStyle(
                          //   dowTextFormatter: (date, locale) {},
                          // ),
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: AppColors.softBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, _) {
                              print(day);
                              final key = DateTime(
                                day.year,
                                day.month,
                                day.day,
                              );
                              final value = vm.entries[key];
                              return Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${day.day}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    if (value != null)
                                      Text(
                                        '${value[AnalysisMapEntriesEnum.minutesWorked] ~/ 60}h${value[AnalysisMapEntriesEnum.minutesWorked] % 60}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.strongBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
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
              const Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    color: AppColors.strongBlue,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
