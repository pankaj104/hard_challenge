import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/image_resource.dart';

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


  @override
    void initState(){
    super.initState();
    habitDoneDateStore(widget.habit);
    habitSkippedDateStore(widget.habit);
    habitMissedDateStore(widget.habit);
}

  List<DateTime> habitDoneDateStore(Habit habit){
    List<DateTime> habitDoneDateList = [];
    habit.progressJson.forEach((date, progress) {
      if(progress.status == TaskStatus.done){
        habitDoneDateList.add(date);
      }
    });
    return habitDoneDateList;
  }


  List<DateTime> habitSkippedDateStore(Habit habit){
    List<DateTime> habitSkippedDateList= [];
    habit.progressJson.forEach((date, progress) {
      if(progress.status == TaskStatus.skipped){
        habitSkippedDateList.add(date);
      }
    });
    // log('habitSkippedDateList $habitSkippedDateList');
    return habitSkippedDateList;
  }


  List<DateTime> habitMissedDateStore(Habit habit) {
    List<DateTime> habitMissedDateList = [];
    DateTime nowWithUtc = DateTime.now().toUtc();
    DateTime now = DateTime.utc(nowWithUtc.year, nowWithUtc.month, nowWithUtc.day);

    log('test now $now');

    DateTime habitStartDate = habit.startDate ?? now;
    DateTime startDate = DateTime.utc(habitStartDate.year, habitStartDate.month, habitStartDate.day);

    // DateTime endDate = habit.endDate ?? now;

    // Iterate over the date range from startDate to one day before 'now'
    for (DateTime date = startDate; date.isBefore(now); date = date.add(const Duration(days: 1))) {
      bool isValidDate = false;

      // Check based on repeat type
      if (habit.repeatType == RepeatType.selectDays) {
        if (habit.days!.contains(date.weekday % 7)) {
          isValidDate = true;
        }
      } else if (habit.repeatType == RepeatType.selectedDate) {
        if (habit.selectedDates != null && habit.selectedDates!.contains(date)) {
          isValidDate = true;
        }
      } else if (habit.repeatType == RepeatType.weekly) {
        isValidDate = habit.days!.contains(date.weekday % 7);
      } else if (habit.repeatType == RepeatType.monthly) {
        if (habit.selectedDates != null && habit.selectedDates!.any((d) => d.month == date.month && d.day == date.day)) {
          isValidDate = true;
        }
      }

      // If the date is valid and missed, add it to the list
      if (isValidDate && (!habit.progressJson.containsKey(date) ||
          (habit.progressJson[date]!.status != TaskStatus.done &&
              habit.progressJson[date]!.status != TaskStatus.skipped))) {
        habitMissedDateList.add(date);
      }
    }

    log ('habitMissedDateList $habitMissedDateList');

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
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            // Customize weekdays row
            weekendStyle: TextStyle(color: Colors.red),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          // Customize day cell builders
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, date, events) {
              if (habitDoneDateStore(widget.habit).any((element) => isSameDay(element, date))) {
                return Center(
                  child: Container(
                      height: 32,
                      width: 35,
                      decoration: BoxDecoration(
                          color: const Color(0xff079455),
                          borderRadius: BorderRadius.circular(9.6)
                      ),

                      child: SvgPicture.asset(ImageResource.doneTick, height: 10, width: 10,)),
                );
              }



               if   (habitSkippedDateStore(widget.habit).any((element) => isSameDay(element, date)))  {
                return Center(
                  child: Container(
                      height: 32,
                      width: 35,
                      decoration: BoxDecoration(
                          color: const Color(0xffF79009),
                          borderRadius: BorderRadius.circular(9.6)
                      ),

                      child: SvgPicture.asset(ImageResource.skipTick, height: 10, width: 10,)),
                );
              }

               if   (habitMissedDateStore(widget.habit).any((element) => isSameDay(element, date)))  {
                return Center(
                  child: Container(
                      height: 32,
                      width: 35,
                      decoration: BoxDecoration(
                          color: const Color(0xffD92D20),
                          borderRadius: BorderRadius.circular(9.6)
                      ),

                      child: SvgPicture.asset(ImageResource.crossTick, height: 10, width: 10,)),
                );
              }

              return null;
            },
            todayBuilder: (context, date, events) {
              if (habitDoneDateStore(widget.habit).any((element) => isSameDay(element, date))) {
                return Center(
                  child: Container(
                      height: 32,
                      width: 35,
                      decoration: BoxDecoration(
                          color: const Color(0xff079455),
                          borderRadius: BorderRadius.circular(9.6)
                      ),

                      child: SvgPicture.asset(ImageResource.doneTick, height: 10, width: 10,)),
                );
              }



              if   (habitSkippedDateStore(widget.habit).any((element) => isSameDay(element, date)))  {
                return Center(
                  child: Container(
                      height: 32,
                      width: 35,
                      decoration: BoxDecoration(
                          color: const Color(0xffF79009),
                          borderRadius: BorderRadius.circular(9.6)
                      ),

                      child: SvgPicture.asset(ImageResource.skipTick, height: 10, width: 10,)),
                );
              }

              if   (habitMissedDateStore(widget.habit).any((element) => isSameDay(element, date)))  {
                return Center(
                  child: Container(
                      height: 32,
                      width: 35,
                      decoration: BoxDecoration(
                          color: const Color(0xffD92D20),
                          borderRadius: BorderRadius.circular(9.6)
                      ),

                      child: SvgPicture.asset(ImageResource.crossTick, height: 10, width: 10,)),
                );
              }

              return null;
            },
            selectedBuilder: (context, date, events) {
              if (habitDoneDateStore(widget.habit).any((element) => isSameDay(element, date))) {
                return Center(
                  child: Container(
                      height: 32,
                      width: 35,
                      decoration: BoxDecoration(
                          color: const Color(0xff079455),
                          borderRadius: BorderRadius.circular(9.6)
                      ),

                      child: SvgPicture.asset(ImageResource.doneTick, height: 10, width: 10,)),
                );
              }



              if   (habitSkippedDateStore(widget.habit).any((element) => isSameDay(element, date)))  {
                return Center(
                  child: Container(
                      height: 32,
                      width: 35,
                      decoration: BoxDecoration(
                          color: const Color(0xffF79009),
                          borderRadius: BorderRadius.circular(9.6)
                      ),

                      child: SvgPicture.asset(ImageResource.skipTick, height: 10, width: 10,)),
                );
              }

              if   (habitMissedDateStore(widget.habit).any((element) => isSameDay(element, date)))  {
                return Center(
                  child: Container(
                      height: 32,
                      width: 35,
                      decoration: BoxDecoration(
                          color: const Color(0xffD92D20),
                          borderRadius: BorderRadius.circular(9.6)
                      ),

                      child: SvgPicture.asset(ImageResource.crossTick, height: 10, width: 10,)),
                );
              }

              return null;
            },

          ),
        ),

    );
  }
}