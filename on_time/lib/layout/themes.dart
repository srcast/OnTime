import 'package:flutter/material.dart';
import 'package:on_time/layout/app_styles.dart';

extension AppTheme on BuildContext {
  AppStyles get colors => Theme.of(this).extension<AppStyles>()!;
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  splashColor: Colors.transparent,
  primaryColor: Colors.blue,
  extensions: <ThemeExtension<AppStyles>>[
    AppStyles(
      insertButton: Colors.green,
      deleteButton: Colors.red,
      cancelButton: Colors.grey,
      saveButton: Colors.blue,
      bodyText: Colors.black,
      titleText: Colors.blueAccent,
      scaffoldBackground: Colors.pink,
      cardBackground: Colors.grey,
    ),
  ],
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  splashColor: Colors.transparent,
  primaryColor: Colors.blueAccent,
  extensions: <ThemeExtension<AppStyles>>[
    const AppStyles(
      insertButton: Colors.greenAccent,
      deleteButton: Colors.redAccent,
      cancelButton: Colors.grey,
      saveButton: Colors.blueAccent,
      bodyText: Colors.white,
      titleText: Colors.lightBlue,
      scaffoldBackground: Colors.orange,
      cardBackground: Color(0xFF1E1E1E),
    ),
  ],
);
