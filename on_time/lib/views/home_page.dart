import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/layout/widgets/activity_card.dart';
import 'package:on_time/layout/widgets/day_summary.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomePageVM>();
    vm.checkTutorial(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => vm.changeDate('-'),
                  icon: Icon(Icons.arrow_back_ios),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => vm.openCalendar(context),
                        child: Text(
                          toBeginningOfSentenceCase(
                                DateFormat(
                                  "E, d MMMM y",
                                  Localizations.localeOf(context).toString(),
                                ).format(vm.date),
                              ) ??
                              '',
                          style: TextStyle(
                            fontSize: 16,
                            color: context.colors.defaultText,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35, // altura igual para ambos
                        child:
                            vm.timerVisible
                                ? Text(
                                  vm.hour,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                : OutlinedButton(
                                  onPressed: () => vm.goToToday(),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: AppColors.softGreen,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    side: BorderSide(
                                      color:
                                          AppColors
                                              .softGreen, // cor do contorno
                                    ),
                                  ),
                                  child: Text(
                                    Labels.today.tr(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed:
                      vm.timerVisible
                          ? null
                          : () => vm.changeDate(
                            '+',
                          ), // timer visible, is today, cant go further on date
                  icon: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 10),

                  vm.points.isEmpty
                      ? Expanded(
                        child: Center(child: Text(Labels.noPointsDayMsg.tr())),
                      )
                      : Expanded(
                        child: SlidableAutoCloseBehavior(
                          child: ListView.builder(
                            controller: vm.scrollController,
                            itemCount: vm.points.length,
                            itemBuilder: (context, index) {
                              final ponto = vm.points[index];

                              final bool showText = ponto.getIn && index > 0;
                              final String textToShow =
                                  showText
                                      ? (ponto.sessionId !=
                                              vm.points[index - 1].sessionId
                                          ? Labels.workBegins.tr()
                                          : Labels.pause.tr())
                                      : '';
                              //aqui se for mudança de sessao acrescentar fim de dia
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (showText)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        textToShow,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),

                                  Slidable(
                                    key: vm.keyListItem,
                                    endActionPane: ActionPane(
                                      motion: const DrawerMotion(),
                                      extentRatio: 0.4,
                                      children: [
                                        SlidableAction(
                                          key: vm.keyPointEdit,
                                          onPressed:
                                              (context) => vm.updatePoint(
                                                context,
                                                ponto,
                                              ),
                                          backgroundColor:
                                              context.colors.editPointButton,
                                          foregroundColor: AppColors.editButton,
                                          icon: Icons.edit,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        SlidableAction(
                                          key: vm.keyPointDelete,
                                          onPressed:
                                              (context) => vm.deletePoint(
                                                context,
                                                ponto,
                                              ),
                                          backgroundColor:
                                              context.colors.deletePointButton,
                                          foregroundColor:
                                              AppColors.deleteButton,
                                          icon: Icons.delete_outline,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: ActivityCard(
                                      key: vm.keyListItemContent,
                                      ponto: ponto,
                                      index: index,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                  SizedBox(height: 10),
                ],
              ),
            ),
            DaySummary(
              minutesWorked: vm.sessionMinutes,
              hourValue: vm.hourValueBase,
              profit: vm.sessionProfit,
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              key: vm.keyCheckIn,
              backgroundColor: AppColors.softGreen, // verde suave, do design
              foregroundColor: AppColors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () => vm.openPointModal(context),
              child: Icon(Icons.add, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
