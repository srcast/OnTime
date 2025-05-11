import 'package:flutter/material.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/labels.dart';

class ActivityCard extends StatelessWidget {
  final String label;
  final String value;

  const ActivityCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          label == Labels.getIn ? Icons.login : Icons.logout,
          color: label == Labels.getOut ? AppColors.softGreen : Colors.red,
        ),
        title: Text(label),
        trailing: Text(value),
      ),
    );
  }
}
