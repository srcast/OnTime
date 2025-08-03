import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';

class AnalysisPageVM extends ChangeNotifier {
  final PointsService _pointsService;
  late DateTime _focusedDate;
  int _totalMinutes = 0;
  double _totalProfit = 0;
  Map<DateTime, Map<Enum, dynamic>> _entries = {};
  String _viewMode = '';
  String _viewModeTitle = '';
  bool _isLoading = false;
  late DateTime _startDate;
  late DateTime _endDate;

  AnalysisPageVM(this._pointsService) {
    _focusedDate = DateTime.now();
    updateViewMode(AnalysisViewMode.month);
    _getData();
  }

  // Public Properties
  DateTime get focusedDate => _focusedDate;
  int get totalMinutes => _totalMinutes;
  double get totalProfit => _totalProfit;
  String get viewMode => _viewMode;
  String get viewModeTitle => _viewModeTitle;
  bool get isLoading => _isLoading;
  Map<DateTime, Map<Enum, dynamic>> get entries => _entries;

  //////////

  void updateViewMode(String mode) {
    if (mode != _viewMode) {
      _focusedDate =
          DateTime.now(); // better controller when advance and go back in date
      _viewMode = mode;
      _setViewModeTitle();
      handelsStartEndDate();
      _getData();
    }
  }

  void _setViewModeTitle() {
    switch (_viewMode) {
      case AnalysisViewMode.week:
        _viewModeTitle = _getWeekRange(
          _focusedDate,
        ); // handles enddate and startdate
        break;

      case AnalysisViewMode.month:
        _viewModeTitle = DateFormat.yMMMM('pt_PT').format(_focusedDate);
        break;

      case AnalysisViewMode.year:
        _viewModeTitle = _focusedDate.year.toString();
        break;
    }
  }

  String _getWeekRange(DateTime date) {
    final int weekday = date.weekday; // 1 = monday, 7 = sunday
    final DateTime sunday = date.subtract(Duration(days: weekday % 7));
    final DateTime saturday = sunday.add(const Duration(days: 6));

    return '${DateFormat('dd/MM/yyyy', 'pt_PT').format(sunday)} - ${DateFormat('dd/MM/yyyy', 'pt_PT').format(saturday)}';
  }

  void advanceDate() {
    switch (_viewMode) {
      case AnalysisViewMode.week:
        _focusedDate = _focusedDate.add(Duration(days: 7));
        break;

      case AnalysisViewMode.month:
        if (_focusedDate.month == 12) {
          _focusedDate = DateTime(_focusedDate.year + 1, 1, 1);
        } else {
          _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1, 1);
        }
        break;

      case AnalysisViewMode.year:
        _focusedDate = _focusedDate.add(Duration(days: 365));
        break;
    }

    _setViewModeTitle();
    handelsStartEndDate();
    _getData();
  }

  void goBackDate() {
    switch (_viewMode) {
      case AnalysisViewMode.week:
        _focusedDate = _focusedDate.subtract(Duration(days: 7));
        break;

      case AnalysisViewMode.month:
        if (_focusedDate.month == 1) {
          _focusedDate = DateTime(_focusedDate.year - 1, 12, 1);
        } else {
          _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1, 1);
        }
        break;

      case AnalysisViewMode.year:
        _focusedDate = _focusedDate.subtract(Duration(days: 365));
        break;
    }

    _setViewModeTitle();
    handelsStartEndDate();
    _getData();
  }

  void handelsStartEndDate() {
    switch (_viewMode) {
      case AnalysisViewMode.week:
        _startDate = _focusedDate.subtract(
          Duration(days: _focusedDate.weekday % 7),
        );
        _endDate = _startDate.add(const Duration(days: 6));
        break;

      case AnalysisViewMode.month:
        _startDate = DateTime(_focusedDate.year, _focusedDate.month, 1);
        _endDate = DateTime(
          _focusedDate.year,
          _focusedDate.month + 1,
          0,
        ); // obtem o ultimo dia do mes -> 0 vai assumir antes do 1  e assim o dia antes do inicio do proximo mes
        break;

      case AnalysisViewMode.year:
        _startDate = DateTime(_focusedDate.year, 1, 1);
        _endDate = DateTime(_focusedDate.year, 12, 31);
        break;
    }
  }

  Future<void> _getData() async {
    _isLoading = true;

    _entries = await _pointsService.getProfitsAsMap(
      _viewMode,
      _startDate,
      _endDate,
    );
    _prepareCalendarOrGraph();
    _updateDaySummary();

    _isLoading = false;

    notifyListeners();
  }

  void _prepareCalendarOrGraph() {}

  void _updateDaySummary() {
    _totalMinutes = 0;
    _totalProfit = 0;
    _entries.forEach((date, result) {
      _totalMinutes += (result[AnalysisMapEntriesEnum.minutesWorked] as int);
      _totalProfit += (result[AnalysisMapEntriesEnum.profit] as double);
    });
  }

  /*   @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  } */
}
