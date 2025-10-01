import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_time/utils/labels.dart';

class DaySummary extends StatelessWidget {
  final int minutesWorked;
  final double hourValue;
  final double profit;

  const DaySummary({
    super.key,
    required this.minutesWorked,
    required this.hourValue,
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
              Labels.hours.tr(),
              '${minutesWorked ~/ 60}h ${min < 10 ? '0' : ''}${min}min',
            ),
            summaryRow(
              Labels.hourValue.tr(),
              '${NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).format(hourValue)}/h',
            ),
            summaryRow(
              Labels.profit.tr(),
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

Widget summaryRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label.tr()), Text(value)],
    ),
  );
}
