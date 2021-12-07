library kosher_calendar;

import 'package:flutter/material.dart';
import 'package:kosher_calendar/calendar_data.dart';
import 'package:kosher_calendar/rectangle_button.dart';
import 'package:kosher_calendar/selector.dart';
import 'package:kosher_calendar/kosher_date_ext.dart';

class KosherCalendar extends StatefulWidget {
  final bool isKosher;
  final DateTime selectedDate;
  final Color secondaryColor;
  final Color accentColor;
  final Color backroundColor;
  const KosherCalendar(
      {Key? key,
      required this.selectedDate,
      this.isKosher = true,
      this.secondaryColor = Colors.grey,
      this.accentColor = Colors.blue,
      this.backroundColor = Colors.white})
      : super(key: key);

  @override
  State<KosherCalendar> createState() => _KosherCalendarState();
}

class _KosherCalendarState extends State<KosherCalendar> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentDate = DateTime.now();
  late int _calendarIndex;

  @override
  void initState() {
    _selectedDate = widget.selectedDate;
    _calendarIndex = widget.isKosher ? 1 : 0;
    super.initState();
  }

  List<Widget> buildCalendarView(DateTime date) {
    final List<Widget> rows = [];
    List<List<DateTime?>> calendar = _calendarIndex == 0 ? CalendarData.getRawGregorianCalendar(date) : CalendarData.getRawJewishCalendar(date);
    
    calendar.forEach((week) {
      final List<Widget> children = [];

      for (var element in week) {
        if (element == null) {
          children.add(Expanded(child: Container()));
          continue;
        }

        children.add(_CalendarItem(
          date: element, 
          isSelected: element.equalsDate(_selectedDate),
          isKosher: _calendarIndex == 1,
          selectedColor: widget.accentColor,
          onTap: !element.equalsDate(_selectedDate) ? (){
                setState(() {
                  _selectedDate = element;
                  _currentDate = element;
                });
              } : null,
          ));
      }

      rows.add(Expanded(child: Row(children: children)));
    });

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration:  BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Selector(borderColor: widget.accentColor, 
              sigments: [
                SelectorSigment(
                  title: "Обычный",
                  isSelected: _calendarIndex == 0,
                  onClick: () {
                    setState(() {
                      _calendarIndex = 0;
                    });
                  },
                  selectedColor: widget.accentColor,
                  selectedTextColor: widget.backroundColor,
                ),
                SelectorSigment(
                  title: "Еврейский",
                  isSelected: _calendarIndex == 1,
                  onClick: () {
                    setState(() {
                      _calendarIndex = 1;
                    });
                  },
                  selectedColor: widget.accentColor,
                  selectedTextColor: widget.backroundColor,
                ),
              ]),
            ),
            _MothView(
              secondaryColor: widget.secondaryColor,
              currentDate: _currentDate,
              isKosher: _calendarIndex == 1,
              onNextMothClick: () {
                setState(() {
                  _currentDate = _currentDate.nextMonth;
                });
              },
              onPreviosMothClick: () {
                setState(() {
                  _currentDate = _currentDate.previousMonth;
                });
              },
            ),
            _WeekDayView(color: widget.secondaryColor),
            Expanded(
                child: Column(
              children: buildCalendarView(_currentDate),
            ))
          ],
        ),
      ),
    );
  }
}

class _CalendarItem extends StatelessWidget {
  const _CalendarItem({
    Key? key,
    this.selectedColor = Colors.blue,
    this.isKosher = false,
    this.isSelected = false,
    this.onTap,
    required this.date,
  }) :  super(key: key);

  final Color selectedColor;
  final bool isSelected;
  final bool isKosher;
  final Function()? onTap;
  final DateTime date;


  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
          child: SizedBox(
            height: 45,
            width: 45,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onTap,
              child: Center(
                  child: Container(
              height: 45,
              width: 45,
              decoration: isSelected ? BoxDecoration(
                  color: selectedColor,
                  borderRadius: const BorderRadius.all(Radius.circular(22))) : null,
              child: Center(
                  child: Text(
                isKosher ? date.jewishDay.toString() : date.day.toString(),
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
              )),
                  ),
                ),
            ),
          ),
        ));
  }
}

class _MothView extends StatelessWidget {
  final Color secondaryColor;
  final DateTime currentDate;
  final bool isKosher;
  final Function onNextMothClick;
  final Function onPreviosMothClick;


  const _MothView(
      {Key? key,
      required this.secondaryColor,
      required this.currentDate,
      required this.isKosher,
      required this.onNextMothClick,
      required this.onPreviosMothClick})
      : super(key: key);


  String getMonthName() {
    return isKosher
        ? "${currentDate.jewishMonthName} ${currentDate.jewishYear}"
        : "${currentDate.gregorianMonthName} ${currentDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          RectangleButton(
              icon: Icon(
                Icons.chevron_left,
                color: secondaryColor,
              ),
              onClick: () => onPreviosMothClick()),
          Expanded(
              child: Center(
                  child: Text(
            getMonthName(),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(fontWeight: FontWeight.bold),
          ))),
          RectangleButton(
              onClick: () => onNextMothClick(),
              icon: Icon(
                Icons.chevron_right,
                color: secondaryColor,
              ))
        ],
      ),
    );
  }
}

class _WeekDayView extends StatelessWidget {
  const _WeekDayView({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: CalendarData.weekDays
          .map((e) => Expanded(
                  child: Center(
                child: Text(
                  e,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      //fontWeight: FontWeight.bold,
                      color: color),
                ),
              )))
          .toList(),
    );
  }
}
