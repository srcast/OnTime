import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_time/helpers/datesHelper.dart';
import 'package:on_time/layout/widgets/point_modal.dart';

class HomePageViewModel extends ChangeNotifier {
  late DateTime _date;
  late Timer _timer;
  bool _timerVisible = true;
  late DateTime _today;
  late int _sessionMinutes;
  late double _hourValueBase;
  late double _sessionProfit;

  HomePageViewModel() {
    timerRunning(true);
    _today = DatesHelper.getDatetimeToday();
    _sessionMinutes = 0;
    _hourValueBase = 25.43;
    _sessionProfit = 0;
  }

  // Public Properties
  DateTime get date => _date;

  String get hour => DateFormat('HH:mm:ss').format(_date);

  String get formatedDate =>
      toBeginningOfSentenceCase(
        DateFormat("E, d 'de' MMM 'de' y", "pt_PT").format(_date),
      ) ??
      '';

  bool get timerVisible => _timerVisible;

  int get sessionMinutes => _sessionMinutes;

  double get hourValueBase => _hourValueBase;

  double get sessionProfit => _sessionProfit;

  //////////

  void timerRunning(bool running) {
    if (running) {
      _timerVisible = true;
      _date = DateTime.now();
      notifyListeners();
      _timer = Timer.periodic(Duration(seconds: 1), (_) {
        _date = DateTime.now();
        notifyListeners();
      });
    } else {
      _timerVisible = false;
      _timer.cancel();
      notifyListeners();
    }
  }

  Future<void> openPointModal(BuildContext context) async {
    final selectedDateTime = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PointModal(date: _date),
    );
  }

  void changeDate(String dir) {
    int days = 0;
    switch (dir) {
      case '-':
        days = -1;
        break;
      case '+':
        days = 1;
        break;
      default:
        days = 0;
        break;
    }

    _date = _date.add(Duration(days: days));

    verifyDate();
  }

  void goToToday() {
    timerRunning(true); // already has notifyListeners
  }

  void openCalendar(BuildContext context) async {
    _date = await DatesHelper.pickDate(context, _date);
    verifyDate();
  }

  void verifyDate() {
    if (_date.day == _today.day &&
        _date.month == _today.month &&
        _date.year == _today.year) // if day selected is today
    {
      timerRunning(true);
    } else {
      timerRunning(false); // already has notifyListeners
    }
  }

  /*   @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  } */
}
