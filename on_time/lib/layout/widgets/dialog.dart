import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:on_time/utils/labels.dart';

class DialogPopup {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String negativeResponse = Labels.no,
    String positiveResponse = Labels.yes,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // dont close when touching out
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(negativeResponse.tr()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(positiveResponse.tr()),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
