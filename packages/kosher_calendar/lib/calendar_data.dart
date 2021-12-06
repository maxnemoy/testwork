import 'package:dart_date/dart_date.dart';
import 'package:kosher_dart/kosher_dart.dart';

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

  static List<List<ComplexDate>> getCleanCalendar(){
    List<List<ComplexDate>> month = [];
    for (int i = 0; i < 6; i++) {
      List<ComplexDate> week = [];
      for (int j = 0; j < 7; j++) {
        week.add(ComplexDate());
      }
      month.add(week);
    }
    return month;
  }

  static List<List<ComplexDate>> getRawGregorianCalendar(ComplexDate date) {
    List<List<ComplexDate>> month = getCleanCalendar();

    int week = 0;
    for (int i = 1; i <= date.gregorianDate!.getDaysInMonth; i++) {
      final DateTime day = DateTime(date.gregorianDate!.year, date.gregorianDate!.month, i);
      month[week][day.weekday - 1] = ComplexDate(
        initialDate: day,
      );

      if (day.weekday == 7) week++;
    }

    return month;
  }

  static List<List<ComplexDate>> getRawJewishCalendar(ComplexDate date) {
    List<List<ComplexDate>> month = getCleanCalendar();

    int week = 0;
    for (int i = 1; i <= date.jewishDate!.getDaysInJewishMonth(); i++) {
      JewishDate jDate = JewishDate.initDate(jewishYear: date.jewishDate!.getJewishYear(), jewishMonth: date.jewishDate!.getJewishMonth(), jewishDayOfMonth: i);
      int weekDay = jDate.getDayOfWeek();
      if(weekDay == 1){
        if(week == 0){
          month[week][6] = ComplexDate.fromJewish(jDate);
          week++;
          continue;
        }
        month[week-1][6] = ComplexDate.fromJewish(jDate);
      } else{
        month[week][weekDay-2] = ComplexDate.fromJewish(jDate);
      }
      if (jDate.getDayOfWeek() == 7) week++;
    }
    month.forEach((element) {
      print("${element[0].jewishDay} ${element[1].jewishDay} ${element[2].jewishDay} ${element[3].jewishDay} ${element[4].jewishDay} ${element[5].jewishDay} ${element[6].jewishDay}");
    });
    return month;
  }
}

class ComplexDate {
  final bool isHolyDay;
  DateTime? gregorianDate;
  JewishDate? jewishDate;

  ComplexDate({DateTime? initialDate, this.isHolyDay = false})
      : gregorianDate = initialDate,
        jewishDate = initialDate == null ? null : JewishDate.fromDateTime(initialDate);

  ComplexDate.fromJewish(JewishDate initDate, {this.isHolyDay = false}):gregorianDate = initDate.getGregorianCalendar(), jewishDate = initDate;

  void nextMonth() {
    if (gregorianDate != null) {
      gregorianDate = gregorianDate!.add(const Duration(days: 29));
      jewishDate = JewishDate.fromDateTime(gregorianDate!);
    }
  }

  void previosMonth() {
    if (gregorianDate != null) {
      gregorianDate = gregorianDate!.subtract(const Duration(days: 29));
      jewishDate = JewishDate.fromDateTime(gregorianDate!);
    }
  }

  String get gregorianMonthName => gregorianDate != null
      ? CalendarData.gregoreanMonthNames[gregorianDate!.month - 1]
      : "";
  String get jewishMonthName => gregorianDate != null
      ? CalendarData.jewishMonthNames[jewishDate!.getJewishMonth() - 1]
      : "";


  int get gregorianYear => gregorianDate != null ? gregorianDate!.year : -1;
  int get jewishYear => jewishDate != null ? jewishDate!.getJewishYear() : -1;

  int get gregorianDay => gregorianDate != null ? gregorianDate!.day : -1;
  int get jewishDay => jewishDate != null ?  jewishDate!.getJewishDayOfMonth() : -1;
  
  bool equalsDate(DateTime date){
    return gregorianDate!.day == date.day &&
           gregorianDate!.month == date.month &&
           gregorianDate!.year == date.year;
  }
}
