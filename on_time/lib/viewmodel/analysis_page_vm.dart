import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:on_time/helpers/app_feedback.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';
import 'package:on_time/viewmodel/home_page_vm.dart';
import 'package:provider/provider.dart';

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
  List<BarChartGroupData> _barGroups = [];
  double _maxY = 0;
  double _stepY = 0;
  int _firstDayOfWeek =
      DateTime
          .sunday; // DateTime.weekday convention, set by the view from the locale

  AnalysisPageVM(this._pointsService) {
    _focusedDate = DateTime.now();
    updateViewMode(AnalysisViewMode.month);
    getData();
  }

  // Public Properties
  DateTime get focusedDate => _focusedDate;
  int get totalMinutes => _totalMinutes;
  double get totalProfit => _totalProfit;
  String get viewMode => _viewMode;
  bool get isLoading => _isLoading;
  Map<DateTime, Map<AnalysisMapEntriesEnum, dynamic>> get entries => _entries;
  List<BarChartGroupData> get barGroups => _barGroups;
  double get maxY => _maxY;
  double get stepY => _stepY;
  int get firstDayOfWeek => _firstDayOfWeek;

  //////////

  // firstDayOfWeekIndex from MaterialLocalizations -> 0 = sunday, 1 = monday (same as the date picker)
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

  String getViewModeTitle(BuildContext context) {
    var title = '';

    switch (_viewMode) {
      case AnalysisViewMode.week:
        title = _getWeekRange();
        break;

      case AnalysisViewMode.month:
        title = DateFormat.yMMMM(
          Localizations.localeOf(context).toString(),
        ).format(_focusedDate);
        break;

      case AnalysisViewMode.year:
        title = _focusedDate.year.toString();
        break;
    }

    return title;
  }

  String _getWeekRange() {
    final format = DateFormat('dd/MM/yyyy', GenericHelper.getDeviceLocale());

    return '${format.format(_startDate)} - ${format.format(_endDate)}';
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
      _setBarGroups();
    }

    _updateDaySummary();

    _isLoading = false;

    notifyListeners();
  }

  void _setBarGroups() {
    _barGroups = [];
    _stepY = 0;
    _maxY = 0;
    final entriesAux = _entries.entries.toList();
    entriesAux.sort((a, b) => a.key.compareTo(b.key)); // order by date

    _barGroups = List.generate(entriesAux.length, (index) {
      final entry = entriesAux[index];
      final minutes = entry.value[AnalysisMapEntriesEnum.minutesWorked] ?? 0;
      final hours = minutes / 60;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: hours,
            width: 20,
            color: AppColors.strongBlueLight,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
      );
    });

    final yValues = _barGroups.map((e) => e.barRods.first.toY).toList();

    double maxVal =
        yValues.isNotEmpty ? yValues.reduce((a, b) => a > b ? a : b) : 0;

    _stepY = (maxVal / 5) % 1 == 0 ? maxVal / 5 : (maxVal / 5) + 1;
    _maxY = stepY * 5;

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

  String getLabelForIndex(int index, BuildContext context) {
    final entries = _entries.entries.toList();
    if (index >= entries.length) return '';

    final date = entries[index].key;

    switch (_viewMode) {
      case AnalysisViewMode.week:
        // Mon, Tus, Wed...
        return DateFormat.EEEEE(
          Localizations.localeOf(context).toString(),
        ).format(date);
      case AnalysisViewMode.year:
        // Jan, Feb, Mar...
        return DateFormat.MMM(
          Localizations.localeOf(context).toString(),
        ).format(date);
      default:
        return DateFormat.d(
          Localizations.localeOf(context).toString(),
        ).format(date);
    }
  }

  void _updateDaySummary() {
    _totalMinutes = 0;
    _totalProfit = 0;
    _entries.forEach((date, result) {
      _totalMinutes += (result[AnalysisMapEntriesEnum.minutesWorked] as int);
      _totalProfit += (result[AnalysisMapEntriesEnum.profit] as double);
    });
  }

  void goToSelectedDay(BuildContext context, DateTime selectedDay) {
    context.read<HomePageVM>().refreshDay(selectedDay);
    final shell = StatefulNavigationShell.of(context);
    shell.goBranch(0);
  }

  /*   @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  } */
}
