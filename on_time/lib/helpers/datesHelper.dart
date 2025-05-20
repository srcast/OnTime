import 'package:flutter/material.dart';
import 'package:on_time/utils/labels.dart';

class DatesHelper {
  static Future<DateTime> pickDate(BuildContext context, DateTime date) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        date.hour,
        date.minute,
      ),
      cancelText: Labels.cancel,
    );
    if (pickedDate != null) {
      date = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
    }

    return date;
  }

  static Future<void> pickTime(BuildContext context, DateTime date) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(date),
      cancelText: Labels.cancel,
    );
    if (pickedTime != null) {
      date = DateTime(
        date.year,
        date.month,
        date.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
  }

  static DateTime getDatetimeToday() {
    var now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }
}
