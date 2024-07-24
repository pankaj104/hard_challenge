import 'package:flutter/material.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final Habit habit;

  const CalendarPage({super.key, required this.habit});
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

   List<DateTime> habitDoneDateList = [];
   List<DateTime> habitMissedDateList =[];
   List<DateTime> habitSkippedDateList= [];

  @override
    void initState(){
    super.initState();
    habitDoneDateStore(widget.habit);
    habitSkippedDateStore(widget.habit);
    habitMissedDateStore(widget.habit);

}

  List<DateTime> habitDoneDateStore(Habit habit){
    habit.progressJson.forEach((date, progress) {
      if(progress.status == TaskStatus.done){
        habitDoneDateList.add(date);
      }
    });
    return habitDoneDateList;
  }
  List<DateTime> habitSkippedDateStore(Habit habit){
    habit.progressJson.forEach((date, progress) {
      if(progress.status == TaskStatus.skipped){
        habitSkippedDateList.add(date);
      }
    });
    return habitSkippedDateList;
  }

  List<DateTime> habitMissedDateStore(Habit habit){
    habit.progressJson.forEach((date, progress) {
      if(progress.status == TaskStatus.missed){
        habitMissedDateList.add(date);
      }
    });
    return habitMissedDateList;
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2022, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
            });
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: CalendarStyle(
            // Customize today and selected day styles

            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            // Customize weekdays row
            weekendStyle: TextStyle(color: Colors.red),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          // Customize day cell builders
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, date, events) {
              if (habitDoneDateList.any((element) => isSameDay(element, date))) {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              else if   (habitMissedDateList.any((element) => isSameDay(element, date)))  {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              else if   (habitSkippedDateList.any((element) => isSameDay(element, date)))  {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return null;
            },
          ),
        ),

    );
  }
}