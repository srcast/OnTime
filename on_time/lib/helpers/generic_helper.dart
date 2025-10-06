import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:on_time/utils/enums.dart';

extension StringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
}

class GenericHelper {
  static String getSessionId(DateTime sessionDate) =>
      sessionDate.year.toString() +
      sessionDate.month.toString() +
      sessionDate.day.toString();

  static String getAppThemeAsString(AppThemeMode theme) =>
      theme.toString().split('.').last;

  static AppThemeMode getAppThemefromString(String? value) {
    return AppThemeMode.values.firstWhere(
      (theme) => getAppThemeAsString(theme) == value,
      orElse: () => AppThemeMode.system,
    );
  }

  static String getLanguageOptAsString(LanguageOptions lang) =>
      lang.toString().split('.').last;

  static LanguageOptions getALanguageOptfromString(String? value) {
    return LanguageOptions.values.firstWhere(
      (lang) => getLanguageOptAsString(lang) == value,
      orElse: () => LanguageOptions.english,
    );
  }

  static Locale getLocaleFromDBLang(LanguageOptions lang) {
    return switch (lang) {
      LanguageOptions.english => Locale('en'),
      LanguageOptions.portuguese => Locale('pt', 'PT'),
      LanguageOptions.french => Locale('fr'),
    };
  }

  static String getDeviceLocale() {
    final deviceLocale = PlatformDispatcher.instance.locale; // locale do SO
    final localeStr =
        deviceLocale.countryCode != null
            ? '${deviceLocale.languageCode}_${deviceLocale.countryCode}'
            : deviceLocale.languageCode;

    return localeStr;
  }
}
