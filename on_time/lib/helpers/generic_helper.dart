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
}
