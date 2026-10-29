import 'dart:developer' as developer;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/labels.dart';

class AppFeedback {
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void logError(String origin, Object error, StackTrace stackTrace) {
    developer.log(
      'Error in $origin',
      name: 'on_time',
      error: error,
      stackTrace: stackTrace,
    );
  }

  // logs the error and tells the user that the action failed
  static void showError(
    String origin,
    Object error,
    StackTrace stackTrace, {
    String label = Labels.saveErrorMsg,
  }) {
    logError(origin, error, stackTrace);

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(label.tr()),
        backgroundColor: AppColors.deleteButton,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
