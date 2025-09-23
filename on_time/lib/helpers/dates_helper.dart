import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      ),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (pickedDate != null) {
      date = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
    }

    return date;
  }

  static Future<DateTime> pickTime(BuildContext context, DateTime date) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(date),
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

    return date;
  }

  static DateTime getDatetimeToday() {
    var now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  static String getTimeFromDate(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static DateTime getSessionFromDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
