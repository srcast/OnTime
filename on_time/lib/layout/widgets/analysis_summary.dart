import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_time/layout/widgets/day_summary.dart';
import 'package:on_time/utils/labels.dart';

class AnalysisSummary extends StatelessWidget {
  final int minutesWorked;
  final double profit;

  const AnalysisSummary({
    super.key,
    required this.minutesWorked,
    required this.profit,
  });

  @override
  Widget build(BuildContext context) {
    int min = minutesWorked % 60;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            summaryRow(
              Labels.hours,
              '${minutesWorked ~/ 60}h ${min < 10 ? '0' : ''}${min}min',
            ),
            summaryRow(
              Labels.profit,
              NumberFormat.simpleCurrency(
                locale: Localizations.localeOf(context).toString(),
              ).format(profit),
            ),
          ],
        ),
      ),
    );
  }
}
