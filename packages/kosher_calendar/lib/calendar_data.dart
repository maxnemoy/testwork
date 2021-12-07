import 'package:dart_date/dart_date.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:kosher_calendar/kosher_date_ext.dart';

class CalendarData {
  static const List<String> weekDays = [
    "Пн",
    "Вт",
    "Ср",
    "Чт",
    "Пт",
    "Сб",
    "Вс"
  ];
  static const List<String> gregoreanMonthNames = [
    "Январь",
    "Февраль",
    "Март",
    "Апрель",
    "Май",
    "Июнь",
    "Июль",
    "Август",
    "Сентябрь",
    "Октябрь",
    "Ноябрь",
    "Декабрь"
  ];
  static const List<String> jewishMonthNames = [
    "Нисан",
    "Ияр",
    "Сиван",
    "Тамуз",
    "Ав",
    "Элул",
    "Тишрей",
    "Хешван",
    "Кислев",
    "Тевет",
    "Шват",
    "Адар",
    "Адар"
  ];

  static List<List<DateTime?>> getCleanCalendar(){
    List<List<DateTime?>> month = [];
    for (int i = 0; i < 6; i++) {
      List<DateTime?> week = [];
      for (int j = 0; j < 7; j++) {
        week.add(null);
      }
      month.add(week);
    }
    return month;
  }

  static List<List<DateTime?>> getRawGregorianCalendar(DateTime date) {
    List<List<DateTime?>> month = getCleanCalendar();

    int week = 0;
    for (int i = 1; i <= date.getDaysInMonth; i++) {
      final DateTime day = DateTime(date.year, date.month, i);
      month[week][day.weekday - 1] = day;
      if (day.weekday == 7) week++;
    }

    return month;
  }

  static List<List<DateTime?>> getRawJewishCalendar(DateTime date) {
    List<List<DateTime?>> month = getCleanCalendar();

    int week = 0;
    for (int i = 1; i <= date.daysInJewishMonth; i++) {
      JewishDate jDate = JewishDate.initDate(jewishYear: date.jewishYear, jewishMonth: date.jewishMonth, jewishDayOfMonth: i);
      int weekDay = jDate.getDayOfWeek();
      if(weekDay == 1){
        if(week == 0){
          month[week][6] = jDate.getGregorianCalendar();
          week++;
          continue;
        }
        month[week-1][6] = jDate.getGregorianCalendar();
      } else{
        month[week][weekDay-2] = jDate.getGregorianCalendar();
      }
      if (jDate.getDayOfWeek() == 7) week++;
    }
    return month;
  }
}
