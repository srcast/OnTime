import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/helpers/points_helper.dart';
import 'package:on_time/layout/widgets/dialog.dart';
import 'package:on_time/layout/widgets/point_modal.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/utils/labels.dart';

class HomePageVM extends ChangeNotifier {
  final PointsService _pointsService;
  final ConfigsService _configsService;
  late DateTime _date;
  late Timer _timer;
  bool _timerVisible = true;
  late DateTime _today;
  int _sessionMinutes = 0;
  double _hourValue = 0;
  double _sessionProfit = 0;
  List<Ponto> _pontos = [];
  final ScrollController _scrollController = ScrollController();

  HomePageVM(this._pointsService, this._configsService) {
    timerRunning(true);
    _today = DatesHelper.getDatetimeToday();
    getSessionPoints(dataFromSession: true);
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

  double get hourValueBase => _hourValue;

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

    getSessionPoints(dataFromSession: true);
  }

  // just when initializing and change data
  Future<void> getSessionPoints({bool dataFromSession = false}) async {
    DateTime sessionDate = DatesHelper.getSessionFromDate(_date);
    _pontos = await _pointsService.getPointsSession(sessionDate);
    await updateDaySummary(sessionDate, dataFromSession);

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

  Future<void> updateDaySummary(
    DateTime sessionDate,
    bool dataFromSession,
  ) async {
    _sessionMinutes = 0;
    _hourValue = 0;
    _sessionProfit = 0;

    // when initializing or when date is changed
    if (dataFromSession) {
      var session = await _pointsService.getSessionData(sessionDate);

      if (session != null) {
        _sessionMinutes = session.minutesWorked;
        _hourValue = session.hourValue;
        _sessionProfit = session.profit;
      }
    } else {
      if (_pontos.length > 1) {
        for (int i = 1; i < _pontos.length; i += 2) {
          var outD = _pontos[i].date;
          var inD = _pontos[i - 1].date;
          var dif = outD.difference(inD).inMinutes;

          _sessionMinutes += dif;
        }
      }

      // get value in use
      _hourValue =
          (await _configsService.getHourValueInUseFromRules(
            DateTime.now(),
            sessionDate,
            _pontos,
          )) ??
          0;

      // get profit
      var valueHourBase = await _configsService.getHourValueBase();
      var rules = await _configsService.getHourValuePolitics();

      _sessionProfit = PointsHelper.getSessionProfit(
        sessionDate,
        sessionMinutes,
        valueHourBase ?? 0,
        _pontos,
        rules,
      );

      //update session values
      _pointsService.insertUpdateSession(
        sessionDate,
        _sessionMinutes,
        _hourValue,
        _sessionProfit,
      );
    }

    notifyListeners();
  }

  Future<void> deletePoint(BuildContext context, Ponto pointToDelete) async {
    bool response = false;
    response = await DialogPopup.show(
      context,
      title: Labels.delete,
      message: Labels.deletePointMsg,
      negativeResponse: Labels.cancel,
      positiveResponse: Labels.delete,
    );

    if (response) {
      _pointsService.deletePoint(pointToDelete);
      getSessionPoints();
    }
  }

  Future<void> updatePoint(BuildContext context, Ponto pointToUpdate) async {
    final dateWithHourUpdate = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PointModal(date: pointToUpdate.date, isUpdate: true),
    );

    if (dateWithHourUpdate != null) {
      final updatePoint = PontosCompanion(
        id: Value(pointToUpdate.id),
        date: Value(dateWithHourUpdate),
        sessionId: Value(pointToUpdate.sessionId),
      );

      _pointsService.updatePonto(updatePoint);

      getSessionPoints();
    }
  }

  /*   @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  } */
}
