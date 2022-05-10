import 'package:intl/intl.dart';

abstract class CalendarUtils {
  static const int kMaxWeekInSemester = 17;

  static int getCurrentWeek([DateTime? mCurrentDate]) {
    DateTime currentDate = mCurrentDate ?? DateTime.now();
    DateTime startDate = getSemesterStart(currentDate);

    if (currentDate.isBefore(startDate)){
      return 1;
    }

    int week = _weekNumber(currentDate) - _weekNumber(startDate);

    if (currentDate.weekday != 0) {
      week++;
    }

    return week;
  }

  static DateTime getSemesterStart([DateTime? mCurrentDate]) {
    DateTime currentDate = mCurrentDate ?? DateTime.now();
    DateTime expectedStart = _getExpectedSemesterStart(currentDate);
    return _getCorrectedDate(expectedStart);
  }

  static List<DateTime> getDaysInWeek(int week, [DateTime? mCurrentDate]) {
    List<DateTime> daysInWeek = [];

    DateTime semStart = getSemesterStart(mCurrentDate);

    // Понедельник недели начала семестра
    var firstDayOfWeek =
    semStart.subtract(Duration(days: semStart.weekday - 1));

    // Прибавляем сколько дней прошло с начала семестра
    var firstDayOfChosenWeek =
    firstDayOfWeek.add(Duration(days: (week - 1) * 7));

    // Добавляем дни в массив, увеличивая счётчик на 1 день
    for (int i = 0; i < 7; ++i) {
      daysInWeek.add(firstDayOfChosenWeek);
      firstDayOfChosenWeek = firstDayOfChosenWeek.add(const Duration(days: 1));
    }
    return daysInWeek;
  }

  static DateTime getSemesterLastDay(
      [DateTime? mCurrentDate]) {
    return getDaysInWeek(
        kMaxWeekInSemester,
        getSemesterStart(
            mCurrentDate))
        .last;
  }

  static DateTime _getCorrectedDate(DateTime date) {
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return _getFirstMondayOfMonth(date.year, date.month);
    } else {
      return date;
    }
  }

  static DateTime _getFirstMondayOfMonth(int year, int month) {
    var firstOfMonth = DateTime(year, month, 1);
    var firstMonday = firstOfMonth.add(
        Duration(days: (7 - (firstOfMonth.weekday - DateTime.monday)) % 7));
    return firstMonday;
  }

  static DateTime _getExpectedSemesterStart(DateTime currentDate) {
    if (currentDate.month >= DateTime.september) {
      return DateTime(currentDate.year, DateTime.september, 1);
    } else {
      return DateTime(currentDate.year, DateTime.february, 9);
    }
  }

  static int _weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat('D').format(date));
    int weekOfYear = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (weekOfYear < 1) {
      weekOfYear = _numOfWeeks(date.year - 1);
    } else if (weekOfYear > _numOfWeeks(date.year)) {
      weekOfYear = 1;
    }
    return weekOfYear;
  }

  static int _numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat('D').format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }
}