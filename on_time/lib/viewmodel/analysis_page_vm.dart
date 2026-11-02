import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:on_time/helpers/app_feedback.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';

typedef ChartValue = ({DateTime date, double hours});

class AnalysisPageVM extends ChangeNotifier {
  final PointsService _pointsService;
  late DateTime _focusedDate;
  int _totalMinutes = 0;
  double _totalProfit = 0;
  Map<DateTime, Map<AnalysisMapEntriesEnum, dynamic>> _entries = {};
  String _viewMode = '';
  bool _isLoading = false;
  late DateTime _startDate;
  late DateTime _endDate;
  List<ChartValue> _chartValues = [];
  double _maxY = 0;
  double _stepY = 0;
  int _firstDayOfWeek = DateTime.sunday;

  AnalysisPageVM(this._pointsService) {
    _focusedDate = DateTime.now();
    updateViewMode(AnalysisViewMode.month); // already loads the data
  }

  // Public Properties
  DateTime get focusedDate => _focusedDate;
  int get totalMinutes => _totalMinutes;
  double get totalProfit => _totalProfit;
  String get viewMode => _viewMode;
  bool get isLoading => _isLoading;
  Map<DateTime, Map<AnalysisMapEntriesEnum, dynamic>> get entries => _entries;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  List<ChartValue> get chartValues => _chartValues;
  double get maxY => _maxY;
  double get stepY => _stepY;
  int get firstDayOfWeek => _firstDayOfWeek;

  //////////

  void setFirstDayOfWeek(int firstDayOfWeekIndex) {
    final weekday =
        firstDayOfWeekIndex == 0 ? DateTime.sunday : firstDayOfWeekIndex;
    if (weekday == _firstDayOfWeek) return;

    _firstDayOfWeek = weekday;
    if (_viewMode == AnalysisViewMode.week) {
      _handelsStartEndDate();
      getData();
    }
  }

  void updateViewMode(String mode) {
    if (mode != _viewMode) {
      _focusedDate = DatesHelper.getSessionFromDate(
        DateTime.now(),
      ); // better controller when advance and go back in date
      _viewMode = mode;
      _handelsStartEndDate();
      getData();
    }
  }

  void advanceDate() {
    switch (_viewMode) {
      case AnalysisViewMode.week:
        _focusedDate = DatesHelper.addDays(_focusedDate, 7);
        break;

      case AnalysisViewMode.month:
        if (_focusedDate.month == 12) {
          _focusedDate = DateTime(_focusedDate.year + 1, 1, 1);
        } else {
          _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1, 1);
        }
        break;

      case AnalysisViewMode.year:
        _focusedDate = DateTime(
          _focusedDate.year + 1,
          1,
          1,
        ); // only the year matters
        break;
    }

    _handelsStartEndDate();
    getData();
  }

  void goBackDate() {
    switch (_viewMode) {
      case AnalysisViewMode.week:
        _focusedDate = DatesHelper.addDays(_focusedDate, -7);
        break;

      case AnalysisViewMode.month:
        if (_focusedDate.month == 1) {
          _focusedDate = DateTime(_focusedDate.year - 1, 12, 1);
        } else {
          _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1, 1);
        }
        break;

      case AnalysisViewMode.year:
        _focusedDate = DateTime(
          _focusedDate.year - 1,
          1,
          1,
        ); // only the year matters
        break;
    }

    _handelsStartEndDate();
    getData();
  }

  void _handelsStartEndDate() {
    switch (_viewMode) {
      case AnalysisViewMode.week:
        // days since the first day of the week
        final daysFromStart = (_focusedDate.weekday - _firstDayOfWeek + 7) % 7;
        _startDate = DatesHelper.addDays(_focusedDate, -daysFromStart);
        _endDate = DatesHelper.addDays(_startDate, 6);
        break;

      case AnalysisViewMode.month:
        _startDate = DateTime(_focusedDate.year, _focusedDate.month, 1);
        _endDate = DateTime(
          _focusedDate.year,
          _focusedDate.month + 1,
          0,
        ); // last day of the month -> 0 forces the day before, so the last day of previous month of month + 1 (month)
        break;

      case AnalysisViewMode.year:
        _startDate = DateTime(_focusedDate.year, 1, 1);
        _endDate = DateTime(_focusedDate.year, 12, 31);
        break;
    }
  }

  Future<void> getData() async {
    _isLoading = true;

    try {
      _entries = await _pointsService.getProfitsAsMap(
        _viewMode,
        _startDate,
        _endDate,
      );
    } catch (e, s) {
      AppFeedback.showError(
        'AnalysisPageVM.getData',
        e,
        s,
        label: Labels.loadErrorMsg,
      );
      _entries = {}; // don't keep showing the previous period
    }

    if (_viewMode != AnalysisViewMode.month) {
      _prepareGraphEmptyValues();
      _setChartValues();
    } else {
      _chartValues = []; // month -> calendar, no chart
    }

    _updateDaySummary();

    _isLoading = false;

    notifyListeners();
  }

  void _setChartValues() {
    final entriesAux = _entries.entries.toList();
    entriesAux.sort((a, b) => a.key.compareTo(b.key)); // order by date

    _chartValues = [
      for (final entry in entriesAux)
        (
          date: entry.key,
          hours: (entry.value[AnalysisMapEntriesEnum.minutesWorked] ?? 0) / 60,
        ),
    ];

    final maxVal = _chartValues.fold<double>(
      0,
      (max, v) => v.hours > max ? v.hours : max,
    );

    // 5 steps of whole hours (ex: max 7h -> step 2h, axis until 10h)
    _stepY = (maxVal / 5).ceilToDouble();
    _maxY = _stepY * 5;

    // prevent error in graph construction
    if (_stepY == 0) {
      _stepY = 1;
      _maxY = 5;
    }
  }

  void _prepareGraphEmptyValues() {
    var auxInitDate = _startDate;

    // while aux date is before end date
    while (!auxInitDate.isAfter(_endDate)) {
      if (!_entries.containsKey(auxInitDate)) {
        _entries.addAll({
          auxInitDate: {
            AnalysisMapEntriesEnum.minutesWorked: 0,
            AnalysisMapEntriesEnum.profit: 0.0,
          },
        });
      }

      switch (_viewMode) {
        case AnalysisViewMode.week:
          auxInitDate = DatesHelper.addDays(auxInitDate, 1);
          break;
        case AnalysisViewMode.year:
          auxInitDate = DateTime(auxInitDate.year, auxInitDate.month + 1, 1);
          break;
      }
    }

    var sortedEntries =
        _entries.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)); // asc

    // update entries with ordered keys
    _entries = {for (var entry in sortedEntries) entry.key: entry.value};
  }

  void _updateDaySummary() {
    _totalMinutes = 0;
    _totalProfit = 0;
    _entries.forEach((date, result) {
      _totalMinutes += (result[AnalysisMapEntriesEnum.minutesWorked] as int);
      _totalProfit += (result[AnalysisMapEntriesEnum.profit] as double);
    });
  }
}
