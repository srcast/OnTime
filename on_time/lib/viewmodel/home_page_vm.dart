import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_time/layout/widgets/point_modal.dart';

class HomePageViewModel extends ChangeNotifier {
  late DateTime _date;
  late Timer _timer;

  HomePageViewModel() {
    _date = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _date = DateTime.now();
      notifyListeners();
    });
  }

  DateTime get date => _date;

  String get hour => DateFormat('HH:mm:ss').format(_date);

  String get formatedDate =>
      toBeginningOfSentenceCase(
        DateFormat("EEEE, d 'de' MMMM 'de' y", "pt_PT").format(_date),
      ) ??
      '';

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

  /*   @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  } */
}
