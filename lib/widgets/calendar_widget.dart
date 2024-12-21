import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/colors.dart';
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
    return habitMissedDateList;
  }





  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          headerVisible: true,
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
          calendarStyle:
          CalendarStyle(

            // selectedDecoration: BoxDecoration(
            //   color: Colors.blue,
            //   shape: BoxShape.circle,
            //   // borderRadius: BorderRadius.circular(9.6),
            // ),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            // Customize weekdays row
            weekdayStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
            weekendStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
          ),
          headerStyle:  HeaderStyle(
            titleTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 16),
            leftChevronIcon: SvgPicture.asset(
              ImageResource.calenderLeft,
            ),
            rightChevronIcon: SvgPicture.asset(
              ImageResource.calenderRight,
            ),
            formatButtonVisible: false,
            titleCentered: true,
          ),
          // Customize day cell builders
          calendarBuilders: CalendarBuilders(
            outsideBuilder: (context, date, events) {
              // Custom decoration for the days of the previous or next month
              return Center(
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: ColorStrings.whiteColor, // Background color for days outside the current month
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                        spreadRadius: 0.4, // Light spread for subtle effect
                        blurRadius: 1, // Smooth blur for softer shadow
                        offset: Offset(0, 2), // Shadow slightly below the element
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400), // White text color for outside days
                    ),
                  ),
                ),
              );
            },
            defaultBuilder: (context, date, events) {

              if (habitDoneDateStore(widget.habit).any((element) => isSameDay(element, date))) {
                return Center(
                  child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                          color: widget.habit.habitType == HabitType.quit ?  Colors.red : Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                            spreadRadius: 0.4, // Light spread for subtle effect
                            blurRadius: 1, // Smooth blur for softer shadow
                            offset: Offset(0, 2), // Shadow slightly below the element
                          ),
                        ],
                      ),

                      child: Icon(
                          widget.habit.habitType == HabitType.quit ? Icons.close : Icons.done, color: ColorStrings.whiteColor, size: 18,)),
                );
              }

               if   (habitSkippedDateStore(widget.habit).any((element) => isSameDay(element, date)))  {
                return Center(
                  child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                            spreadRadius: 0.4, // Light spread for subtle effect
                            blurRadius: 1, // Smooth blur for softer shadow
                            offset: Offset(0, 2), // Shadow slightly below the element
                          ),
                        ],
                      ),

                      child: Icon(Icons.last_page,color: ColorStrings.whiteColor,)
                  ),
                );
              }

               if   (habitMissedDateStore(widget.habit).any((element) => isSameDay(element, date)))  {
                return Center(
                  child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                          color: widget.habit.habitType == HabitType.quit ? Colors.green : Colors.red  ,
                          borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                            spreadRadius: 0.4, // Light spread for subtle effect
                            blurRadius: 1, // Smooth blur for softer shadow
                            offset: Offset(0, 2), // Shadow slightly below the element
                          ),
                        ],
                      ),

                      child: Icon(
                          widget.habit.habitType == HabitType.quit ? Icons.done : Icons.close, color: ColorStrings.whiteColor, size: 18,)),
                );
              }

              return Center(
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: ColorStrings.whiteColor, // Background color for days outside the current month
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                        spreadRadius: 0.4, // Light spread for subtle effect
                        blurRadius: 1, // Smooth blur for softer shadow
                        offset: Offset(0, 2), // Shadow slightly below the element
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400), // White text color for outside days
                    ),
                  ),
                ),
              );
            },
            todayBuilder: (context, date, events) {
              if (habitDoneDateStore(widget.habit).any((element) => isSameDay(element, date))) {
                return Center(
                  child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                          color: widget.habit.habitType == HabitType.quit ?  Colors.red : Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                            spreadRadius: 0.4, // Light spread for subtle effect
                            blurRadius: 1, // Smooth blur for softer shadow
                            offset: Offset(0, 2), // Shadow slightly below the element
                          ),
                        ],
                      ),

                      child: Icon(
                          widget.habit.habitType == HabitType.quit ? Icons.close : Icons.done, color: ColorStrings.whiteColor, size: 18,)),
                );
              }

              if   (habitSkippedDateStore(widget.habit).any((element) => isSameDay(element, date)))  {
                return Center(
                  child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                            spreadRadius: 0.4, // Light spread for subtle effect
                            blurRadius: 1, // Smooth blur for softer shadow
                            offset: Offset(0, 2), // Shadow slightly below the element
                          ),
                        ],
                      ),

                      child: Icon(Icons.last_page,color: ColorStrings.whiteColor,)),
                );
              }

              if   (habitMissedDateStore(widget.habit).any((element) => isSameDay(element, date)))  {
                return Center(
                  child: Container(
                      height: 32,
                      width: 35,
                      decoration: BoxDecoration(
                          color: widget.habit.habitType == HabitType.quit ? Colors.green : Colors.red ,
                          borderRadius: BorderRadius.circular(9.6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                            spreadRadius: 0.4, // Light spread for subtle effect
                            blurRadius: 1, // Smooth blur for softer shadow
                            offset: Offset(0, 2), // Shadow slightly below the element
                          ),
                        ],
                      ),

                      child: Icon(
                          widget.habit.habitType == HabitType.quit ? Icons.close : Icons.done, color: ColorStrings.whiteColor, size: 18,)),
                );
              }

              return Center(
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: ColorStrings.whiteColor, // Background color for days outside the current month
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                        spreadRadius: 0.4, // Light spread for subtle effect
                        blurRadius: 1, // Smooth blur for softer shadow
                        offset: Offset(0, 2), // Shadow slightly below the element
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600), // White text color for outside days
                    ),
                  ),
                ),
              );
            },
            selectedBuilder: (context, date, events) {
              if (habitDoneDateStore(widget.habit).any((element) => isSameDay(element, date))) {
                return Center(
                  child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                          color: widget.habit.habitType == HabitType.quit ?  Colors.red: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                            spreadRadius: 0.4, // Light spread for subtle effect
                            blurRadius: 1, // Smooth blur for softer shadow
                            offset: Offset(0, 2), // Shadow slightly below the element
                          ),
                        ],
                      ),


                      child: Icon(
                        widget.habit.habitType == HabitType.quit ? Icons.close : Icons.done, color: ColorStrings.whiteColor, size: 18,)),
                );
              }

              if   (habitSkippedDateStore(widget.habit).any((element) => isSameDay(element, date)))  {
                return Center(
                  child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                            spreadRadius: 0.4, // Light spread for subtle effect
                            blurRadius: 1, // Smooth blur for softer shadow
                            offset: Offset(0, 2), // Shadow slightly below the element
                          ),
                        ],
                      ),

                      child: Icon(Icons.last_page,color: ColorStrings.whiteColor,)),
                );
              }

              if   (habitMissedDateStore(widget.habit).any((element) => isSameDay(element, date)))  {
                return Center(
                  child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                          color: widget.habit.habitType == HabitType.quit ? Color(0xff079455) : Color(0xffD92D20)  ,
                          borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                            spreadRadius: 0.4, // Light spread for subtle effect
                            blurRadius: 1, // Smooth blur for softer shadow
                            offset: Offset(0, 2), // Shadow slightly below the element
                          ),
                        ],
                      ),

                      child: Icon(
                          widget.habit.habitType == HabitType.quit ? Icons.done : Icons.close, color: ColorStrings.whiteColor)),
                );
              }

              return Center(
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: ColorStrings.cyanColor, // Background color for days outside the current month
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                        spreadRadius: 0.4, // Light spread for subtle effect
                        blurRadius: 1, // Smooth blur for softer shadow
                        offset: Offset(0, 2), // Shadow slightly below the element
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400), // White text color for outside days
                    ),
                  ),
                ),
              );
            },

          ),
        ),

    );
  }
}