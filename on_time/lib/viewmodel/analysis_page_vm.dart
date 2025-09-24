import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_time/helpers/dates_helper.dart';
import 'package:on_time/services/points_service.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/enums.dart';
import 'package:on_time/utils/labels.dart';

class AnalysisPageVM extends ChangeNotifier {
  final PointsService _pointsService;
  late DateTime _focusedDate;
  int _totalMinutes = 0;
  double _totalProfit = 0;
  Map<DateTime, Map<AnalysisMapEntriesEnum, dynamic>> _entries = {};
  String _viewMode = '';
  String _viewModeTitle = '';
  bool _isLoading = false;
  late DateTime _startDate;
  late DateTime _endDate;
  List<BarChartGroupData> _barGroups = [];
  double _maxY = 0;
  double _stepY = 0;

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
  String get viewModeTitle => _viewModeTitle;
  bool get isLoading => _isLoading;
  Map<DateTime, Map<AnalysisMapEntriesEnum, dynamic>> get entries => _entries;
  List<BarChartGroupData> get barGroups => _barGroups;
  double get maxY => _maxY;
  double get stepY => _stepY;

  //////////

  void updateViewMode(String mode) {
    if (mode != _viewMode) {
      _focusedDate = DatesHelper.getSessionFromDate(
        DateTime.now(),
      ); // better controller when advance and go back in date
      _viewMode = mode;
      _setViewModeTitle();
      handelsStartEndDate();
      getData();
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
    getData();
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
    getData();
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

  Future<void> getData() async {
    _isLoading = true;

    _entries = await _pointsService.getProfitsAsMap(
      _viewMode,
      _startDate,
      _endDate,
    );

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
          auxInitDate = auxInitDate.add(Duration(days: 1));
          break;
        case AnalysisViewMode.year:
          auxInitDate = DateTime(auxInitDate.year, auxInitDate.month + 1, 1);
          break;
      }
    }

    var sortedEntries =
        _entries.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)); // crescente

    // update entries with ordered keys
    _entries = {for (var entry in sortedEntries) entry.key: entry.value};
  }

  String getLabelForIndex(int index) {
    final entries = _entries.entries.toList();
    if (index >= entries.length) return '';

    final date = entries[index].key;

    switch (_viewMode) {
      case AnalysisViewMode.week:
        // Ex: Seg, Ter, Qua...
        return DateFormat.EEEEE('pt_PT').format(date);
      case AnalysisViewMode.year:
        // Ex: Jan, Fev, Mar...
        return DateFormat.MMM('pt_PT').format(date);
      default:
        return DateFormat.d('pt_PT').format(date); // fallback: dia do mês
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
    // context.go('/home', extra: selectedDay);

    // final layoutState = context.findAncestorStateOfType<_LayoutScaffoldState>();
    // layoutState?.goToTab(
    //   0,
    //   selectedDay: selectedDay,
    // ); // vai para Home e foca no dia
  }

  /*   @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  } */
}
