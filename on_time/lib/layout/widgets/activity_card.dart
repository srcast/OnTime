import 'package:flutter/material.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/labels.dart';

class ActivityCard extends StatelessWidget {
  final Ponto ponto;
  final int index;

  const ActivityCard({super.key, required this.ponto, required this.index});

  @override
  Widget build(BuildContext context) {
    bool getIn = index % 2 == 0;

    return Column(
      children: [
        if (getIn && index > 0) ...[
          SizedBox(height: 10),
          Center(child: Text(Labels.pause)),
          SizedBox(height: 10),
        ],

        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              getIn ? Icons.login : Icons.logout,
              color: getIn ? AppColors.softGreen : Colors.red,
            ),
            title: Text(getIn ? Labels.getIn : Labels.getOut),
            trailing: Text(
              DatesHelper.getTimeFromDate(ponto.date),
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
