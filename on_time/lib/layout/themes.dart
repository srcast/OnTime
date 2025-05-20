import 'package:flutter/material.dart';
import 'package:on_time/utils/colors.dart';

// Theme.of(context).textTheme.headlineSmall chamar assim na app

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  textTheme: TextTheme(
    titleMedium: TextStyle(fontSize: 16, color: AppColors.defaultText),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    titleSmall: TextStyle(fontSize: 16, color: AppColors.white),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: AppColors.softGreen,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: BorderSide(
        color: AppColors.softGreen, // cor do contorno
      ),
    ),
  ),
);
