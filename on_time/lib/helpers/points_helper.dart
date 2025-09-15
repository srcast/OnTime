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
    double valueHourBase,
    List<Ponto> sessionPoints,
    List<HourValuePolitic> rules,
  ) {
    int sessionMinutes = 0;

    if (sessionPoints.isEmpty) {
      return 0;
    } else {
      sessionMinutes = PointsHelper.getMinutesWorkedSession(sessionPoints);
    }

    // first by day
    String day = CommonObjs.daysOfWeek[sessionDate.weekday - 1];
    var dayValue =
        (rules.where((r) => r.dayOffWeek == day).toList()
              ..sort((a, b) => a.id.compareTo(b.id)))
            .firstOrNull;

    if (dayValue != null) return dayValue.hourValue! * sessionMinutes / 60;

    double val = valueHourBase;
    double profit = 0;

    // after schedule

    final start = sessionPoints[0].date;
    final end = sessionPoints.last.date;

    final rulesSchedule =
        rules.where((r) => r.afterSchedule != null).toList()
          ..sort((a, b) => a.afterSchedule!.compareTo(b.afterSchedule!));

    List<HourValuePolitic> rulesApplied = [];
    if (rulesSchedule.isNotEmpty) {
      for (int i = 0; i < rulesSchedule.length; i++) {
        DateTime regraDateTime = DateTime(
          start.year,
          start.month,
          start.day,
          rulesSchedule[i].afterSchedule!.hour,
          rulesSchedule[i].afterSchedule!.minute,
        );

        DateTime workStartAtTime = DateTime(
          sessionDate.year,
          sessionDate.month,
          sessionDate.day,
          rulesSchedule[i].workStartAt!.hour,
          rulesSchedule[i].workStartAt!.minute,
        );

        if (regraDateTime.isBefore(workStartAtTime)) {
          regraDateTime = regraDateTime.add(const Duration(days: 1));
        }

        if (regraDateTime.isAfter(start) && regraDateTime.isBefore(end)) {
          rulesApplied.add(
            HourValuePolitic(
              id: rulesSchedule[i].id,
              ruleDescription: rulesSchedule[i].ruleDescription,
              afterSchedule: regraDateTime,
              hourValue: rulesSchedule[i].hourValue,
            ),
          );
        }
      }

      if (rulesApplied.isNotEmpty) {
        for (int i = 1; i < sessionPoints.length; i += 2) {
          var rulesAppliedBetweenPoints =
              rulesApplied
                  .where(
                    (r) =>
                        !sessionPoints[i - 1].date.isAfter(r.afterSchedule!) &&
                        !sessionPoints[i].date.isBefore(r.afterSchedule!),
                  )
                  .toList()
                ..sort((a, b) => a.afterSchedule!.compareTo(b.afterSchedule!));

          if (rulesAppliedBetweenPoints.isNotEmpty) {
            DateTime begin = sessionPoints[i - 1].date;
            for (int j = 0; j < rulesAppliedBetweenPoints.length; j++) {
              profit +=
                  (rulesAppliedBetweenPoints[j].afterSchedule!.difference(
                    begin,
                  )).inMinutes *
                  val /
                  60;

              begin = rulesAppliedBetweenPoints[j].afterSchedule!;
              val = rulesAppliedBetweenPoints[j].hourValue!;
            }

            //last point
            profit +=
                (sessionPoints[i].date!.difference(begin)).inMinutes * val / 60;
          } else {
            profit +=
                (sessionPoints[i].date.difference(
                  sessionPoints[i - 1].date,
                )).inMinutes *
                val /
                60;
          }
        }

        return profit;
      }
    }

    // after X hours
    var rulesHours =
        rules
            .where(
              (r) => r.afterMinutesWorked != null && r.afterMinutesWorked! > 0,
            )
            .toList()
          ..sort(
            (a, b) => a.afterMinutesWorked!.compareTo(b.afterMinutesWorked!),
          );

    if (rulesHours.isNotEmpty) {
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
            profit +=
                ((rulesApplied[j].afterMinutesWorked! - begin) * val) / 60;

            begin = rulesApplied[j].afterMinutesWorked!;
            val = rulesApplied[j].hourValue!;
          }

          //last point
          profit += ((minTotal - begin) * val) / 60;
        } else {
          profit +=
              (sessionPoints[i].date
                  .difference(sessionPoints[i - 1].date)
                  .inMinutes) *
              val /
              60;
        }
      }

      return profit;
    }

    // base
    return sessionMinutes * valueHourBase / 60;
  }

  static double getHourValueInUseFromRules(
    DateTime currentDate,
    DateTime sessionDate,
    List<Ponto> sessionPoints,
    List<HourValuePolitic> rules,
    double hourValueBase,
  ) {
    // first by day
    String day = CommonObjs.daysOfWeek[sessionDate.weekday - 1];
    var dayValue =
        (rules.where((r) => r.dayOffWeek == day).toList()
              ..sort((a, b) => a.id.compareTo(b.id)))
            .firstOrNull;

    if (dayValue != null) return dayValue.hourValue!;

    // after schedule
    final rulesSchedule = rules.where((r) => r.afterSchedule != null).toList();

    List<HourValuePolitic> rulesApplied = [];
    DateTime lastComparisonDate =
        sessionPoints.isNotEmpty ? sessionPoints.last.date : currentDate;

    for (int i = 0; i < rulesSchedule.length; i++) {
      DateTime regraDateTime = DateTime(
        sessionDate.year,
        sessionDate.month,
        sessionDate.day,
        rulesSchedule[i].afterSchedule!.hour,
        rulesSchedule[i].afterSchedule!.minute,
      );

      DateTime workStartAtTime = DateTime(
        sessionDate.year,
        sessionDate.month,
        sessionDate.day,
        rulesSchedule[i].workStartAt!.hour,
        rulesSchedule[i].workStartAt!.minute,
      );

      if (regraDateTime.isBefore(workStartAtTime)) {
        regraDateTime = regraDateTime.add(const Duration(days: 1));
      }

      if (regraDateTime.isBefore(lastComparisonDate)) {
        rulesApplied.add(
          HourValuePolitic(
            id: rulesSchedule[i].id,
            ruleDescription: rulesSchedule[i].ruleDescription,
            afterSchedule: regraDateTime,
            hourValue: rulesSchedule[i].hourValue,
          ),
        );
      }
    }

    // desc order
    if (rulesApplied.isNotEmpty) {
      rulesApplied.sort((a, b) => b.afterSchedule!.compareTo(a.afterSchedule!));
      return rulesApplied[0].hourValue!;
    }
    //}

    // after X hours
    int minWorkedSession = PointsHelper.getMinutesWorkedSession(sessionPoints);

    var afterXHours =
        (rules
                .where(
                  (r) =>
                      (r.afterMinutesWorked ?? 0) <= minWorkedSession &&
                      (r.afterMinutesWorked ?? 0) > 0,
                )
                .toList()
              ..sort(
                (a, b) =>
                    b.afterMinutesWorked!.compareTo(a.afterMinutesWorked!),
              ))
            .firstOrNull;

    if (afterXHours != null) return afterXHours.hourValue!;

    // base
    return hourValueBase;
  }
}
