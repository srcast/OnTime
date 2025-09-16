extension StringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
}

class GenericHelper {
  static String getSessionId(DateTime sessionDate) =>
      sessionDate.year.toString() +
      sessionDate.month.toString() +
      sessionDate.day.toString();
}
