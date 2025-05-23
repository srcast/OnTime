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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _summaryRow(
              Labels.hours,
              '${minutesWorked ~/ 60} h ${minutesWorked % 60} min',
            ),
            _summaryRow(
              Labels.hourValue,
              '${NumberFormat.simpleCurrency(locale: 'pt-Pt').format(hourValue)}/h',
            ),
            _summaryRow(
              Labels.profit,
              NumberFormat.simpleCurrency(locale: 'pt-Pt').format(profit),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _summaryRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text(value)],
    ),
  );
}
