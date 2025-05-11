import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

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

  /*   @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  } */
}
