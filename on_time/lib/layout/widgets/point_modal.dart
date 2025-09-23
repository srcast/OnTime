import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/labels.dart';

// ignore: must_be_immutable
class PointModal extends StatefulWidget {
  DateTime date;
  bool isUpdate;
  PointModal({super.key, required this.date, this.isUpdate = false});

  @override
  State<PointModal> createState() => _PointModal();
}

class _PointModal extends State<PointModal> {
  late DateTime selectedDateTime = widget.date;
  late bool isUpdate = widget.isUpdate;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickDate() async {
    final pickedDate = await DatesHelper.pickDate(context, selectedDateTime);
    if (pickedDate != null) {
      setState(() {
        selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          selectedDateTime.hour,
          selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final pickedTime = await DatesHelper.pickTime(context, selectedDateTime);

    if (pickedTime != null) {
      setState(() {
        selectedDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat.yMMMMd("pt_PT").format(selectedDateTime);
    final timeFormatted = DateFormat.Hm().format(selectedDateTime);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Ponto",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Visibility(
            visible: !isUpdate,
            child: ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(dateFormatted),
              onTap: _pickDate,
            ),
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text(timeFormatted),
            onTap: _pickTime,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  Labels.cancel,
                  style: TextStyle(color: AppColors.darkGray),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, selectedDateTime),
                child: Text(
                  Labels.save,
                  style: TextStyle(color: AppColors.strongBlue),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
