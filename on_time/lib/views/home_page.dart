import 'package:flutter/material.dart';
import 'package:on_time/layout/widgets/activity_card.dart';
import 'package:on_time/layout/widgets/day_summary.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/labels.dart';
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
    final homeVM = context.watch<HomePageViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(homeVM.formatedDate, style: TextStyle(fontSize: 20)),
            ),
            Center(
              child: Text(
                homeVM.hour,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            ActivityCard(label: Labels.getIn, value: '09:12'),
            ActivityCard(label: Labels.getOut, value: '17:45'),
            SizedBox(height: 10),
            Spacer(),
            DaySummary(
              hoursWorked: '8h 33min',
              hourValue: 25.43,
              dayProfit: 79.43,
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              backgroundColor: AppColors.softGreen, // verde suave, do design
              foregroundColor: AppColors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () => homeVM.openPointModal(context),
              child: Icon(Icons.add, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
