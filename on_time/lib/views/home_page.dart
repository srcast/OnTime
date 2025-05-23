import 'package:flutter/material.dart';
import 'package:on_time/layout/widgets/activity_card.dart';
import 'package:on_time/layout/widgets/day_summary.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomePageViewModel>();

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
                          vm.formatedDate,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.defaultText,
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
                                    'Hoje',
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
                  onPressed: () => vm.changeDate('+'),
                  icon: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 10),

                  vm.pontos.isEmpty
                      ? Expanded(
                        child: Center(child: Text('Sem pontos registados.')),
                      )
                      : Expanded(
                        child: ListView.builder(
                          controller: vm.scrollController,
                          itemCount: vm.pontos.length,
                          itemBuilder: (context, index) {
                            final ponto = vm.pontos[index];
                            return ActivityCard(ponto: ponto, index: index);
                          },
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
