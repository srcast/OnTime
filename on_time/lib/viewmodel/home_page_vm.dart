import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/app_feedback.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/helpers/points_helper.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/utils/labels.dart';

class HomePageVM extends ChangeNotifier {
  final PointsService _pointsService;
  final ConfigsService _configsService;
  late DateTime _date; // date selected in screen
  Timer? _timer;
  bool _timerVisible = true;
  // current day -> always calculated, the app can stay open after midnight
  DateTime get _today => DatesHelper.getDatetimeToday();
  int _sessionMinutes = 0;
  double _hourValue = 0;
  double _sessionProfit = 0;
  List<Ponto> _pointsUI =
      []; // points of the day -> its used to show on screen day's points. It can has points from diferent sessions
  List<Ponto> _pointsSession =
      []; // points for the session -> its used to update summary

  HomePageVM(this._pointsService, this._configsService) {
    initPage();
  }

  // Public Properties
  DateTime get date => _date;

  String get hour => DateFormat('HH:mm:ss').format(_date);

  bool get timerVisible => _timerVisible;

  int get sessionMinutes => _sessionMinutes;

  double get hourValueBase => _hourValue;

  double get sessionProfit => _sessionProfit;

  List<Ponto> get points => _pointsUI;

  //////////

  void initPage() {
    timerRunning(true);
    _getSessionPoints();
  }

  void timerRunning(bool running) {
    _timer?.cancel(); // only one timer at a time
    _timer = null;

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
      notifyListeners();
    }
  }

  // actions -> the view gets the values (modal, dialog) and calls these

  Future<void> addPoint(DateTime date) async {
    try {
      await _pointsService.insertPoint(date);
    } catch (e, s) {
      AppFeedback.showError('HomePageVM.addPoint', e, s);
    }

    // shows the day of the point with what is really saved
    _date = date;
    await verifyDate();

    // if (GlobalData.showInterstitialAds && AdsHelper.isInterstitialReady) {
    //   AdsHelper.showInterstitial();
    // }
  }

  Future<void> deletePoint(Ponto pointToDelete) async {
    try {
      await _pointsService.deletePoint(pointToDelete);
    } catch (e, s) {
      AppFeedback.showError('HomePageVM.deletePoint', e, s);
    }

    await _getSessionPoints();
  }

  Future<void> updatePoint(Ponto pointToUpdate, DateTime newDate) async {
    try {
      await _pointsService.updatePoint(pointToUpdate, newDate);
    } catch (e, s) {
      AppFeedback.showError('HomePageVM.updatePoint', e, s);
    }

    _date = newDate;
    await verifyDate();
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

    _date = DatesHelper.addDays(_date, days);

    verifyDate();
  }

  void goToToday() {
    timerRunning(true); // already has notifyListeners
    _getSessionPoints();
  }

  Future<void> selectDate(DateTime date) {
    _date = date;
    return verifyDate();
  }

  Future<void> verifyDate() {
    if (_date.day == _today.day &&
        _date.month == _today.month &&
        _date.year == _today.year) // if day selected is today
    {
      timerRunning(true);
    } else {
      timerRunning(false); // already has notifyListeners
    }

    return _getSessionPoints();
  }

  // just when initializing and change data
  Future<void> _getSessionPoints() async {
    DateTime sessionDate = DatesHelper.getSessionFromDate(_date);
    String sessionId = GenericHelper.getSessionId(sessionDate);

    try {
      _pointsSession = await _pointsService.getPointsSession(sessionId);
      _pointsUI = await _pointsService.getDayPointsForUI(sessionDate);

      await _updateDaySummary(sessionDate, sessionId);
    } catch (e, s) {
      AppFeedback.showError(
        'HomePageVM._getSessionPoints',
        e,
        s,
        label: Labels.loadErrorMsg,
      );

      // don't keep showing the points of the previous selected day
      _pointsUI = [];
      _pointsSession = [];
      notifyListeners();
    }
  }

  Future<void> _updateDaySummary(DateTime sessionDate, String sessionId) async {
    _sessionMinutes = 0;
    _hourValue = 0;
    _sessionProfit = 0;

    var session = await _pointsService.getSessionData(sessionId);

    if (session != null) {
      _sessionMinutes = session.minutesWorked;
      _sessionProfit = session.profit;
    }

    // if we update screen, hour value need to be updated even if there was no point change
    if (sessionDate == _today) {
      var rules = await _configsService.getHourValuePolitics();
      var hourValueBaseFromConfigs = await _configsService.getHourValueBase();
      // get value in use
      _hourValue = PointsHelper.getHourValueInUseFromRules(
        DateTime.now(),
        sessionDate,
        _pointsSession,
        rules,
        hourValueBaseFromConfigs ?? 0,
      );
    } else if (session != null) {
      _hourValue = session.hourValue;
    }

    notifyListeners();
  }

  void refreshDay(DateTime selectedDay) {
    _date = selectedDay;
    verifyDate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
