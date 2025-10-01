import 'package:easy_localization/easy_localization.dart';
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
    //bool getIn = index % 2 == 0;

    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              ponto.getIn ? Icons.login : Icons.logout,
              color: ponto.getIn ? AppColors.softGreen : AppColors.red,
            ),
            title: Text(ponto.getIn ? Labels.getIn.tr() : Labels.getOut.tr()),
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
