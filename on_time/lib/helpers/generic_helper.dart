import 'dart:ui';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:on_time/utils/enums.dart';

extension StringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
}

class GenericHelper {
  // yyyyMMdd -> month and day must be zero padded, otherwise 2025-01-11 and 2025-11-01 share the same id
  static String getSessionId(DateTime sessionDate) =>
      sessionDate.year.toString().padLeft(4, '0') +
      sessionDate.month.toString().padLeft(2, '0') +
      sessionDate.day.toString().padLeft(2, '0');

  // yyyyMMdd -> day of the session
  static DateTime getDateFromSessionId(String sessionId) => DateTime(
    int.parse(sessionId.substring(0, 4)),
    int.parse(sessionId.substring(4, 6)),
    int.parse(sessionId.substring(6, 8)),
  );

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
    final deviceLocale = PlatformDispatcher.instance.locale; // OS locale
    final localeStr =
        deviceLocale.countryCode != null
            ? '${deviceLocale.languageCode}_${deviceLocale.countryCode}'
            : deviceLocale.languageCode;

    return localeStr;
  }

  // chosen by the user in configurations (loaded on start), null -> currency of the device country
  static String? selectedCurrencyCode;

  static String getCurrencyCode() =>
      selectedCurrencyCode.isNullOrEmpty
          ? getDeviceCurrencyCode()
          : selectedCurrencyCode!;

  static String getDeviceCurrencyCode([Locale? locale]) {
    final countryCode =
        (locale ?? PlatformDispatcher.instance.locale).countryCode;

    try {
      return CountryPickerUtils.getCountryByIsoCode(
            countryCode ?? 'PT',
          ).currencyCode ??
          'EUR';
    } catch (_) {
      return 'EUR';
    }
  }

  static String getCurrencyFormat(double value, {int decDigits = -1}) {
    final currency = getCurrencyCode();
    final decimalDigits = decDigits == -1 ? null : decDigits;

    NumberFormat format;
    try {
      format = NumberFormat.simpleCurrency(
        locale: GenericHelper.getDeviceLocale(),
        name: currency,
        decimalDigits: decimalDigits,
      );
    } catch (_) {
      // device locale unknown by intl
      format = NumberFormat.simpleCurrency(
        name: currency,
        decimalDigits: decimalDigits,
      );
    }

    return format.format(value);
  }
}
