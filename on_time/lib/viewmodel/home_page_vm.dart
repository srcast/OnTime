import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/helpers/points_helper.dart';
import 'package:on_time/layout/widgets/dialog.dart';
import 'package:on_time/layout/widgets/point_modal.dart';
import 'package:on_time/router/routes.dart';
import 'package:on_time/services/configs_service.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomePageVM extends ChangeNotifier {
  final PointsService _pointsService;
  final ConfigsService _configsService;
  late DateTime _date; // date selected in screen
  late Timer _timer;
  bool _timerVisible = true;
  late DateTime _today; // current day
  int _sessionMinutes = 0;
  double _hourValue = 0;
  double _sessionProfit = 0;
  List<Ponto> _pointsUI =
      []; // points of the day -> its used to show on screen day's points. It can has points from diferent sessions
  List<Ponto> _pointsSession =
      []; // points for the session -> its used to update summary
  final ScrollController _scrollController = ScrollController();
  bool _hasSeenTutorial = false;
  bool _tutorialOngoing = false;
  bool _isLoading = false;

  HomePageVM(this._pointsService, this._configsService) {
    getHasSeenTutorialConfig();
    _today = DatesHelper.getDatetimeToday();
    timerRunning(true);
    _getSessionPoints();
  }

  // Public Properties
  DateTime get date => _date;

  String get hour => DateFormat('HH:mm:ss').format(_date);

  bool get timerVisible => _timerVisible;

  int get sessionMinutes => _sessionMinutes;

  double get hourValueBase => _hourValue;

  double get sessionProfit => _sessionProfit;

  List<Ponto> get points => _pointsUI;

  ScrollController get scrollController => _scrollController;

  bool get isLoading => _isLoading;

  final GlobalKey keyCheckIn = GlobalKey();
  final GlobalKey keyListItem = GlobalKey();
  final GlobalKey keyListItemContent = GlobalKey();
  final GlobalKey keyPointEdit = GlobalKey();
  final GlobalKey keyPointDelete = GlobalKey();

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

      var sessionIdToUpdate = await _pointsService.insertPoint(_date);
      await _pointsService.updateSessionPointsCrono(sessionIdToUpdate);
      await _updateCurrentSessionData(sessionIdToUpdate);

      _getSessionPoints();
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
    _getSessionPoints();
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

    _getSessionPoints();
  }

  // just when initializing and change data
  Future<void> _getSessionPoints() async {
    if (!_hasSeenTutorial) return;

    DateTime sessionDate = DatesHelper.getSessionFromDate(_date);
    String sessionId = GenericHelper.getSessionId(sessionDate);
    _pointsSession = await _pointsService.getPointsSession(sessionId);
    _pointsUI = await _pointsService.getDayPointsForUI(sessionDate);

    await _updateDaySummary(sessionDate, sessionId);

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

  Future<void> deletePoint(BuildContext context, Ponto pointToDelete) async {
    bool response = false;
    response = await DialogPopup.show(
      context,
      title: Labels.delete.tr(),
      message: Labels.deletePointMsg.tr(),
      negativeResponse: Labels.cancel.tr(),
      positiveResponse: Labels.delete.tr(),
    );

    if (response) {
      var sessionIdToUpdate = await _pointsService.deletePoint(pointToDelete);
      await _pointsService.updateSessionPointsCrono(sessionIdToUpdate);
      await _updateCurrentSessionData(sessionIdToUpdate);
      _getSessionPoints();
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
      _date = dateWithHourUpdate;
      var sessionIdToUpdate = await _pointsService.updatePonto(
        pointToUpdate,
        dateWithHourUpdate,
      );
      await _pointsService.updateSessionPointsCrono(sessionIdToUpdate);
      await _updateCurrentSessionData(sessionIdToUpdate);
      _getSessionPoints();
    }
  }

  Future<void> _updateCurrentSessionData(String sessionId) async {
    var sessionData = await _pointsService.getSessionData(sessionId);
    _pointsSession = await _pointsService.getPointsSession(sessionId);
    DateTime day = sessionData != null ? sessionData.day : _date;

    _sessionMinutes = 0;
    if (_pointsSession.length > 1) {
      for (int i = 1; i < _pointsSession.length; i += 2) {
        var outD = _pointsSession[i].date;
        var inD = _pointsSession[i - 1].date;
        var dif = outD.difference(inD).inMinutes;

        _sessionMinutes += dif;
      }
    }

    // get value in use
    var rules = await _configsService.getHourValuePolitics();
    var hourValueBaseFromConfigs = await _configsService.getHourValueBase();

    _hourValue = PointsHelper.getHourValueInUseFromRules(
      DateTime.now(),
      day,
      _pointsSession,
      rules,
      hourValueBaseFromConfigs ?? 0,
    );

    // get profit
    _sessionProfit = PointsHelper.getSessionProfit(
      day,
      hourValueBaseFromConfigs ?? 0,
      _pointsSession,
      rules,
    );

    //update session values
    await _pointsService.insertUpdateSession(
      sessionId,
      day,
      _sessionMinutes,
      _hourValue,
      _sessionProfit,
    );
  }

  void refreshDayFromCalendarAnalysis(DateTime selectedDay) {
    _date = selectedDay;
    verifyDate();
  }

  void getHasSeenTutorialConfig() async {
    _isLoading = true;
    _hasSeenTutorial = await _configsService.hasSeenTutorial();
    _hasSeenTutorial = false;
    _isLoading = false;
    if (!_hasSeenTutorial) {
      _preparePointsTutorial();
    }
  }

  void checkTutorial(BuildContext context) async {
    if (!_hasSeenTutorial && !_tutorialOngoing) {
      _tutorialOngoing = true;
      _prepareFirstFaseTutorial(context);
    }
  }

  void _preparePointsTutorial() {
    _pointsUI.add(
      Ponto(
        id: 1,
        date: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          10,
          0,
        ),
        sessionId: "1",
        getIn: true,
      ),
    );

    notifyListeners();
  }

  void _prepareFirstFaseTutorial(BuildContext context) {
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: TutorialIdentifiers.checkIn,
          keyTarget: keyCheckIn,
          shape: ShapeLightFocus.RRect,
          radius: 16,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Text(
                TutorialLabels.point.tr(),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: TutorialIdentifiers.listItem,
          keyTarget: keyListItem,
          shape: ShapeLightFocus.RRect,
          radius: 16,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TutorialLabels.pointList.tr(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
      colorShadow: Colors.black54,
      textSkip: TutorialLabels.skip.tr(),
      opacityShadow: 0.6,
      onFinish: () => _openSlidableAndShowActions(context),
      onSkip: () {
        _cancelTutorial();
        return true;
      },
    ).show(context: Overlay.of(context).context);
  }

  Future<void> _openSlidableAndShowActions(BuildContext context) async {
    if (keyListItem.currentContext != null) {
      await Scrollable.ensureVisible(
        keyListItem.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.4,
      );
    }

    await Future.delayed(const Duration(milliseconds: 200));

    final slidable =
        keyListItemContent.currentContext == null
            ? null
            : Slidable.of(keyListItemContent.currentContext!);

    if (slidable != null) {
      slidable.openEndActionPane(duration: const Duration(milliseconds: 300));
      await Future.delayed(const Duration(milliseconds: 360));
    }

    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: TutorialIdentifiers.editPoint,
          keyTarget: keyPointEdit,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          paddingFocus: 6,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                children: [
                  Text(
                    TutorialLabels.pointEdit.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: TutorialIdentifiers.deletePoint,
          keyTarget: keyPointDelete,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          paddingFocus: 6,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                children: [
                  Text(
                    TutorialLabels.pointDelete.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      colorShadow: Colors.black54,
      textSkip: TutorialLabels.skip.tr(),
      opacityShadow: 0.6,
      onFinish: () => _navigateToConfigPage(context),
      onSkip: () {
        _cancelTutorial();
        return true;
      },
    ).show(context: Overlay.of(context).context);
  }

  Future<void> _cancelTutorial() async {
    _cleanTutorialData();
    await _configsService.updateHasSeenTutorial(_hasSeenTutorial);
  }

  bool _navigateToConfigPage(BuildContext context) {
    _cleanTutorialData();
    context.go('${Routes.configurationsPage}?startTutorial=true');
    return false;
  }

  void _cleanTutorialData() {
    _pointsUI = [];
    _sessionMinutes = 0;
    _hasSeenTutorial = true;
    _tutorialOngoing = false;
    notifyListeners();
  }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }
}
