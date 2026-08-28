import 'package:intl/intl.dart';
import 'package:paged_vertical_calendar/utils/date_models.dart';

abstract class DateUtils {
  static Month getMonth(
    DateTime? minDate,
    DateTime? maxDate,
    int monthPage,
    bool up, {
    bool startWeekWithSunday = false,
  }) {
    DateTime startDate = (minDate ?? DateTime.now()).removeTime();

    if (monthPage > 1) {
      final offset = monthPage - 1;
      if (up) {
        startDate = DateTime(startDate.year, startDate.month - offset, 1);
      } else {
        startDate = DateTime(startDate.year, startDate.month + offset, 1);
      }
    }

    final weekMinDate = _findDayOfWeekInMonth(
      startDate,
      getWeekDay(startDate, startWeekWithSunday),
      startWeekWithSunday: startWeekWithSunday,
    );

    DateTime firstDayOfWeek = weekMinDate;
    DateTime lastDayOfWeek = _lastDayOfWeek(weekMinDate, startWeekWithSunday);

    List<Week> weeks = [];

    while (true) {
      if (up) {
        Week week;
        if (maxDate != null && firstDayOfWeek.isBefore(maxDate)) {
          week = Week(maxDate, lastDayOfWeek);
        } else {
          week = Week(firstDayOfWeek, lastDayOfWeek);
        }

        if (maxDate != null && lastDayOfWeek.isSameDayOrAfter(maxDate)) {
          weeks.add(week);
        } else if (maxDate == null) {
          weeks.add(week);
        }
        if (week.isLastWeekOfMonth) break;
      } else {
        if (maxDate != null && lastDayOfWeek.isSameDayOrAfter(maxDate)) {
          Week week = Week(firstDayOfWeek, maxDate);
          weeks.add(week);
          break;
        }

        Week week = Week(firstDayOfWeek, lastDayOfWeek);
        weeks.add(week);

        if (week.isLastWeekOfMonth) break;
      }

      firstDayOfWeek = lastDayOfWeek.nextDay;
      lastDayOfWeek = _lastDayOfWeek(firstDayOfWeek, startWeekWithSunday);
    }

    return Month(weeks);
  }

  static int getWeekDay(DateTime date, bool startWeekWithSunday) {
    if (startWeekWithSunday) {
      return date.weekday == DateTime.sunday ? 1 : date.weekday + 1;
    } else {
      return date.weekday;
    }
  }

  /// calculates the last of the week by calculating the remaining days in a
  /// standard week and evaluating if this week extends beyond the total days
  /// in that month, and capping it to the end of the month if it does
  static DateTime _lastDayOfWeek(DateTime firstDayOfWeek, bool startWeekWithSunday) {
    int daysInMonth = firstDayOfWeek.daysInMonth;

    final dayOfWeek = getWeekDay(firstDayOfWeek, startWeekWithSunday);
    final restOfWeek = DateTime.daysPerWeek - dayOfWeek;

    return firstDayOfWeek.day + restOfWeek > daysInMonth
        ? DateTime(firstDayOfWeek.year, firstDayOfWeek.month, daysInMonth)
        : firstDayOfWeek.addDays(restOfWeek);
  }

  static DateTime _findDayOfWeekInMonth(
    DateTime date,
    int dayOfWeek, {
    bool startWeekWithSunday = false,
  }) {
    date = date.removeTime();

    if (date.weekday == (startWeekWithSunday ? DateTime.sunday : DateTime.monday)) {
      return date;
    } else {
      return date.subtract(Duration(days: getWeekDay(date, startWeekWithSunday) - dayOfWeek));
    }
  }

  static List<int> daysPerMonth(int year) => <int>[
    31,
    _isLeapYear(year) ? 29 : 28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31,
  ];

  /// efficient leapyear calcualtion transcribed from a C stackoverflow answer
  static bool _isLeapYear(int year) {
    return (year & 3) == 0 && ((year % 25) != 0 || (year & 15) == 0);
  }

  static List<DateTime> listOfValidDatesInMonth(Month month, List<int> weekdaysToHide) {
    final totalDays = month.daysInMonth;
    final validDates = <DateTime>[];
    for (int i = 1; i <= totalDays; i++) {
      final date = DateTime(month.year, month.month, i);
      if (!weekdaysToHide.contains(date.weekday)) {
        validDates.add(date);
      }
    }
    return (validDates);
  }

  static int getNoOfSpaceRequiredBeforeFirstValidDate(
    List<int> weekdaysToHide,
    int weekdayValueForFirstValidDay, [
    bool isSundayFirstDayOfWeek = false,
  ]) {
    final mondayWeekDayList = [1, 2, 3, 4, 5, 6, 7];
    final sundayWeekDayList = [7, 1, 2, 3, 4, 5, 6];

    mondayWeekDayList.removeWhere((weekday) => weekdaysToHide.contains(weekday));
    sundayWeekDayList.removeWhere((weekday) => weekdaysToHide.contains(weekday));

    return isSundayFirstDayOfWeek
        ? sundayWeekDayList.indexOf(weekdayValueForFirstValidDay)
        : mondayWeekDayList.indexOf(weekdayValueForFirstValidDay);
  }
}

extension DateUtilsExtensions on DateTime {
  int get daysInMonth => DateUtils.daysPerMonth(year)[month - 1];

  DateTime get nextDay => DateTime(year, month, day + 1);

  bool isSameDayOrAfter(DateTime other) => isAfter(other) || isSameDay(other);

  bool isSameDayOrBefore(DateTime other) => isBefore(other) || isSameDay(other);

  bool isSameDay(DateTime other) => year == other.year && month == other.month && day == other.day;

  DateTime removeTime() => DateTime(year, month, day);

  bool isSameMonth(DateTime other) => other.year == year && other.month == month;

  DateTime addDays(int daysToAdd) {
    return DateTime(year, month, day + daysToAdd, hour, minute, second, millisecond, microsecond);
  }
}

/// Date format: HH:mm (Example: 15:30)
const String hourMinutes24 = "HH:mm";

/// Date format: d MMM (Example: 20 Jul)
const String shortD = "d";

/// Date format: d MMM (Example: 20 Jul)
const String shortDM = "d MMM";

/// Date format: dd MMM yyyy(Example: 20 Jul 2023)
const String shortDDMY = "dd MMM yyyy";

/// Date format: dd MMMM yyyy(Example: 20 July 2023)
const String shortDDMMY = "dd MMMM yyyy";

/// Date format: MMM d, yyyy (Example: July 20, 2023)
const String shortMDY = "MMMM d, yyyy";

/// Date format: MMM d, yyyy (Example: Jul 20, 2023)
const String shortMDYAbbr = "MMM d, yyyy";

/// Date format: EEEE, MMMM d, yyyy (Example: Thursday, July 20, 2023)
const String weekdayMDY = "EEEE, MMMM d, yyyy";

/// Date format: EEEE, MMM d, yyyy (Example: Thursday, Jul 20, 2023)
const String weekdayMDYAbbr = "EEEE, MMM d, yyyy";

/// Date format: MMM d, yyyy HH:mm:ss (Example: Jul 20, 2023 15:30:45)
const String shortMDYTime = "MMM d, yyyy HH:mm:ss";

/// Date format: EEEE, MMMM d, yyyy HH:mm:ss (Example: Thursday, July 20, 2023 15:30:45)
const String weekdayMDYTime = "EEEE, MMMM d, yyyy HH:mm:ss";

/// Date format: EEEE, MMM d, yyyy HH:mm:ss (Example: Thursday, Jul 20, 2023 15:30:45)
const String weekdayMDYTimeAbbr = "EEEE, MMM d, yyyy HH:mm:ss";

/// Date format: MMMM d, yyyy h:mm a (Example: July 20, 2023 3:30 PM)
const String longMDYTime = "MMMM d, yyyy h:mm a";

/// Date format: MMM d, yyyy h:mm a (Example: Jul 20, 2023 3:30 PM)
const String shortMDYTimeWithTimezone = "MMM d, yyyy h:mm a";

/// Date format: EEE, MMM d, ''yy (Example: Thu, Jul 20, '23)
const String shortWeekdayMDY = "EEE, MMM d, ''yy";

/// Date format: dd-MMM-yyyy (Example: 15-AUG-2023)
const String flightFormatDate = "dd-MMM-yyyy";

/// Date format: dd-MMM-yyyy (Example: 2023-10-15)
const String flightFormatDateReversed = "yyyy-MM-dd";

const String flightFormatDateReversed2 = "yyyy-MM-dd HH:mm";

/// Date format: dd MMM yyyy (Example: 15-AUG-2023)
const String flightFormatDate2 = "dd MMM yyyy";

extension DateTimeExtensions on DateTime {
  String toFormattedString(String format, {String? locale}) {
    var formatter = DateFormat(format, locale);
    return formatter.format(this);
  }

  String toISO8601String() {
    String y = (year >= -9999 && year <= 9999) ? _fourDigits(year) : _sixDigits(year);
    String m = twoDigits(n: month);
    String d = twoDigits(n: day);
    return "$y-$m-$d";
  }

  String dateFormatRange(DateTime checkinDate, DateTime checkoutDate) {
    String y = checkoutDate.year.toString();
    String checkInDay = checkinDate.day.toString();
    String checkOutDay = checkoutDate.day.toString();
    String mIn = DateFormat("MMM").format(checkinDate);
    String mOut = DateFormat("MMM").format(checkoutDate);
    if (checkInDay.length == 1) {
      checkInDay = '0$checkInDay';
    }
    if (checkOutDay.length == 1) {
      checkOutDay = '0$checkOutDay';
    }
    var date = '';
    if (mOut == mIn) {
      date = "$checkInDay - $checkOutDay $mOut $y";
    } else {
      date = "$checkInDay $mIn - $checkOutDay $mOut $y";
    }
    return date;
  }

  String distanceFromDate(DateTime toDate) {
    String journeyDate = '${toFormattedString(shortDDMY)} - ${toDate.toFormattedString(shortDDMY)}';
    if (isSameMonth(toDate) && isSameYear(toDate)) {
      journeyDate = '${twoDigits()} - ${toDate.toFormattedString(shortDDMMY)}';
    }
    return journeyDate;
  }

  bool isBeforeDate(DateTime date) {
    return isBefore(date) && !isSameDay(date);
  }

  bool isNotSameDay(DateTime other) =>
      year == other.year && month == other.month && day != other.day;

  bool isSameYear(DateTime date) {
    return year == date.year;
  }

  bool isAfterAndBefore(DateTime after, DateTime before) {
    bool isAfter = this.isAfter(after) || isAtSameMomentAs(after);
    bool isBefore = this.isBefore(before) || isAtSameMomentAs(before);
    return isAfter && isBefore;
  }

  static String _fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }

  static String _sixDigits(int n) {
    assert(n < -9999 || n > 9999);
    int absN = n.abs();
    String sign = n < 0 ? "-" : "+";
    if (absN >= 100000) return "$sign$absN";
    return "${sign}0$absN";
  }

  static String threeDigits(int n) {
    if (n >= 100) return "$n";
    if (n >= 10) return "0$n";
    return "00$n";
  }

  String twoDigits({int? n}) {
    n = n ?? day;
    if (n >= 10) return "$n";
    return "0$n";
  }
}
