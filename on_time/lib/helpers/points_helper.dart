import 'package:drift/drift.dart';
import 'package:on_time/database/database.dart';
import 'package:on_time/utils/common_objs.dart';

class PointsHelper {
  static int getMinutesWorkedSession(List<Ponto> points) {
    if (points == null || points.isEmpty) return 0;

    int lastPoint = points.length % 2 == 0 ? points.length : points.length - 1;
    int minutesWorked = 0;

    for (int i = lastPoint - 1; i >= 0; i -= 2) {
      minutesWorked += points[i].date.difference(points[i - 1].date).inMinutes;
    }

    return minutesWorked;
  }

  static double getSessionProfit(
    DateTime sessionDate,
    int sessionMinutes,
    double valueHourBase,
    List<Ponto> sessionPoints,
    List<HourValuePolitic> rules,
  ) {
    // first by day
    String day = CommonObjs.daysOfWeek[sessionDate.weekday];
    var dayValue =
        (rules.where((r) => r.dayOffWeek == day).toList()
              ..sort((a, b) => a.id.compareTo(b.id)))
            .firstOrNull;

    if (dayValue != null) return dayValue.hourValue! * sessionMinutes;

    double val = valueHourBase;
    double profit = 0;

    // after schedule

    if (sessionPoints.isNotEmpty) {
      final start = sessionPoints[0].date;
      final end = sessionPoints.last.date;

      final rulesSchedule =
          rules.where((r) => r.afterSchedule != null).toList()
            ..sort((a, b) => a.afterSchedule!.compareTo(b.afterSchedule!));

      for (int i = 0; i < rulesSchedule.length; i++) {
        DateTime regraDateTime = DateTime(
          start.year,
          start.month,
          start.day,
          rulesSchedule[i].afterSchedule!.hour,
          rulesSchedule[i].afterSchedule!.minute,
        );

        if (regraDateTime.isBefore(start)) {
          regraDateTime = regraDateTime.add(const Duration(days: 1));
        }

        if (regraDateTime.isAfter(start) && regraDateTime.isBefore(end)) {
          rulesSchedule[i].copyWith(afterSchedule: Value(regraDateTime));
        } else {
          rulesSchedule.remove(rulesSchedule[i]);
        }
      }

      for (int i = 1; i < sessionPoints.length; i += 2) {
        var rulesApplied =
            rulesSchedule
                .where(
                  (r) =>
                      !sessionPoints[i - 1].date.isAfter(r.afterSchedule!) &&
                      !sessionPoints[i].date.isBefore(r.afterSchedule!),
                )
                .toList();

        if (rulesApplied.isNotEmpty) {
          DateTime begin = sessionPoints[i - 1].date;
          for (int j = 0; j < rulesApplied.length; j++) {
            profit +=
                (rulesApplied[j].afterSchedule!.difference(begin)).inMinutes *
                val;

            begin = rulesApplied[j].afterSchedule!;
            val = rulesApplied[j].hourValue!;
          }

          //last point
          profit += (sessionPoints[i].date!.difference(begin)).inMinutes * val;
        } else {
          profit +=
              (sessionPoints[i].date.difference(
                sessionPoints[i - 1].date,
              )).inMinutes *
              val;
        }
      }

      return profit;
    }

    // after X hours

    if (sessionPoints.isNotEmpty) {
      final start = sessionPoints[0].date;
      final end = sessionPoints.last.date;

      var rulesHours =
          rules.where((r) => r.afterMinutesWorked != null).toList()..sort(
            (a, b) => a.afterMinutesWorked!.compareTo(b.afterMinutesWorked!),
          );

      int minTotal = 0;
      for (int i = 1; i < sessionPoints.length; i += 2) {
        int min =
            sessionPoints[i].date
                .difference(sessionPoints[i - 1].date)
                .inMinutes;

        minTotal += min;

        var rulesApplied =
            rulesHours.where((r) => r.afterMinutesWorked! <= minTotal).toList();

        if (rulesApplied.isNotEmpty) {
          int begin = minTotal - min; // minutes at the start
          for (int j = 0; j < rulesApplied.length; j++) {
            profit += ((rulesApplied[j].afterMinutesWorked! - begin) * val);

            begin = rulesApplied[j].afterMinutesWorked!;
            val = rulesApplied[j].hourValue!;
          }

          //last point
          profit += ((minTotal - begin) * val);
        } else {
          profit +=
              (sessionPoints[i].date
                  .difference(sessionPoints[i - 1].date)
                  .inMinutes) *
              val;
        }
      }

      return profit;
    }

    // base
    return sessionMinutes * valueHourBase;
  }
}
