import 'package:flutter/material.dart';
import 'package:on_time/utils/labels.dart';

class DaySummary extends StatelessWidget {
  final String hoursWorked;
  final double hourValue;
  final double dayProfit;

  const DaySummary({
    super.key,
    required this.hoursWorked,
    required this.hourValue,
    required this.dayProfit,
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
            _summaryRow(Labels.hours, hoursWorked),
            _summaryRow(Labels.hourValue, '$hourValue €/h'),
            _summaryRow(Labels.profit, '$dayProfit €'),
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
