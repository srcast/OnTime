import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/layout/widgets/point_modal.dart';
import 'package:on_time/services/points_service.dart';

class HomePageViewModel extends ChangeNotifier {
  final PointsService _pointsService;
  late DateTime _date;
  late Timer _timer;
  bool _timerVisible = true;
  late DateTime _today;
  late int _sessionMinutes;
  late double _hourValueBase;
  late double _sessionProfit;
  List<Ponto> _pontos = [];
  final ScrollController _scrollController = ScrollController();

  HomePageViewModel(this._pointsService) {
    timerRunning(true);
    _today = DatesHelper.getDatetimeToday();
    _sessionMinutes = 0;
    _hourValueBase = 25.43;
    _sessionProfit = 0;
    getSessionPoints();
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

  List<Ponto> get pontos => _pontos;

  ScrollController get scrollController => _scrollController;

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

    if (selectedDateTime != null) {
      _date = selectedDateTime;
      var lastPoint = await _pointsService.getLastPointSession(
        DatesHelper.getSessionFromDate(_date),
      );
      bool inState =
          lastPoint != null ? (lastPoint.getIn ? false : true) : true;

      _pointsService.insertPoint(
        PontosCompanion(
          date: Value(
            DateTime(
              _date.year,
              _date.month,
              _date.day,
              _date.hour,
              _date.minute,
            ),
          ), // date without seconds
          getIn: Value(inState),
          sessionId: Value(DatesHelper.getSessionFromDate(_date)),
        ),
      );

      getSessionPoints();
    }
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
    getSessionPoints();
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

    getSessionPoints();
  }

  Future<void> getSessionPoints() async {
    DateTime session = DatesHelper.getSessionFromDate(_date);
    _pontos = await _pointsService.getPointsSession(session);

    updateDaySummary();

    // animates activity list to last position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void updateDaySummary() {
    _sessionMinutes = 0;

    if (_pontos.length > 1) {
      for (int i = 1; i < _pontos.length; i += 2) {
        var outD = _pontos[i].date;
        var inD = _pontos[i - 1].date;
        var dif = outD.difference(inD).inMinutes;

        _sessionMinutes += dif;
        //_pontos[i].date.difference(_pontos[i - 1].date).inMinutes;
      }
    }

    _sessionProfit = (_hourValueBase * _sessionMinutes) / 60;

    notifyListeners();
  }

  /*   @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  } */
}
