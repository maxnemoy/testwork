import 'package:dart_date/dart_date.dart';
import 'package:kosher_calendar/calendar_data.dart';
import 'package:kosher_dart/kosher_dart.dart';

extension KosherDate on DateTime {

  DateTime get previousMonth{
    return subtract(Duration(days: getDaysInMonth));
  }

  DateTime get nextMonth {
    return add(Duration(days: getDaysInMonth));
  }

  String get gregorianMonthName {
    return CalendarData.gregoreanMonthNames[month - 1];
  }

  String get jewishMonthName{
    JewishDate date = JewishDate.fromDateTime(this);
    return CalendarData.jewishMonthNames[date.getJewishMonth() - 1];
  }

  JewishDate get jewishDateTime{
    return JewishDate.fromDateTime(this);
  }

  int get jewishYear{
    return JewishDate.fromDateTime(this).getJewishYear();
  }

  int get jewishDay{
    return JewishDate.fromDateTime(this).getJewishDayOfMonth();
  }

  int get jewishMonth{
    return JewishDate.fromDateTime(this).getJewishMonth();
  }

  int get daysInJewishMonth{
    return JewishDate.fromDateTime(this).getDaysInJewishMonth();
  }

  bool equalsDate(DateTime date){
    return day == date.day &&
           month == date.month &&
           year == date.year;
  }
}