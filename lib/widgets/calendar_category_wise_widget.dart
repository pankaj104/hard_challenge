import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:hard_challenge/utils/helpers.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/colors.dart';
import '../utils/image_resource.dart';

class CalendarCategoryWisePage extends StatefulWidget {
  final List<Habit> habit;
  final String selectedCategory; // Add a selected category

  const CalendarCategoryWisePage({super.key, required this.habit, required this.selectedCategory}); // Include the selected category
  @override
  _CalendarCategoryWisePageState createState() => _CalendarCategoryWisePageState();
}

class _CalendarCategoryWisePageState extends State<CalendarCategoryWisePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    habitDoneDateStore(widget.habit, widget.selectedCategory); // Pass the category
    habitSkippedDateStore(widget.habit, widget.selectedCategory); // Pass the category
    habitMissedDateStore(widget.habit, widget.selectedCategory); // Pass the category
  }

  List<DateTime> habitDoneDateStore(List<Habit> habits, String category) {
    List<DateTime> habitDoneDateList = [];
    for (var habit in habits) {
      if (habit.category == category) { // Filter by category
        habit.progressJson.forEach((date, progress) {
          if (progress.status == TaskStatus.done) {
            habitDoneDateList.add(date);
          }
        });
      }
    }
    return habitDoneDateList;
  }

  List<DateTime> habitSkippedDateStore(List<Habit> habits, String category) {
    List<DateTime> habitSkippedDateList = [];
    for (var habit in habits) {
      if (habit.category == category) { // Filter by category
        habit.progressJson.forEach((date, progress) {
          if (progress.status == TaskStatus.skipped) {
            habitSkippedDateList.add(date);
          }
        });
      }
    }
    return habitSkippedDateList;
  }

  List<DateTime> habitMissedDateStore(List<Habit> habits, String category) {
    List<DateTime> habitMissedDateList = [];
    DateTime now = DateTime.now();

    for (var habit in habits) {
      if (habit.category == category) {
        DateTime startDate = habit.startDate ?? now;
        DateTime endDate = habit.endDate ?? now;

        // Filter the progressJson based on the category
        Map<DateTime, ProgressWithStatus> categoryProgressJson = Map.fromEntries(
          habit.progressJson.entries.where((entry) => habit.category == category),
        );

        // Iterate over the date range from startDate to endDate
        for (DateTime date = startDate; date.isBefore(now) || date.isAtSameMomentAs(now); date = date.add(const Duration(days: 1))) {
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
          if (isValidDate && (!categoryProgressJson.containsKey(date) ||
              (categoryProgressJson[date]!.status != TaskStatus.done &&
                  categoryProgressJson[date]!.status != TaskStatus.skipped))) {
            habitMissedDateList.add(date);
          }
        }
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
        // onFormatChanged: (format) {
        //   if (_calendarFormat != format) {
        //     setState(() {
        //       _calendarFormat = format;
        //     });
        //   }
        // },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: const CalendarStyle(
          // selectedDecoration: BoxDecoration(
          //   color: Colors.blue,
          //   shape: BoxShape.circle,
          // ),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
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
        calendarBuilders:
        CalendarBuilders(
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
            if (habitDoneDateStore(widget.habit,widget.selectedCategory).any((element) => isSameDay(element, setSelectedDate(date)))) {
              return Center(
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: widget.habit == HabitType.quit ?  Colors.red : Colors.green,
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

                    child: Icon(Icons.done, size: 18,color: ColorStrings.whiteColor,)
                ),
                    // SvgPicture.asset(ImageResource.doneTick, height: 10, width: 10,)),
              );

              //   Container(
              //   margin: const EdgeInsets.all(6.0),
              //   alignment: Alignment.center,
              //   decoration: BoxDecoration(
              //     color: Colors.green,
              //     shape: BoxShape.circle,
              //   ),
              //   child: Text(
              //     '${date.day}',
              //     style: TextStyle(color: Colors.white),
              //   ),
              // );
            } else if (habitMissedDateStore(widget.habit,widget.selectedCategory).any((element) => isSameDay(element, setSelectedDate(date)))) {
              return Center(
                child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: widget.habit == HabitType.quit ? Colors.green : Colors.red  ,
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

                    child: Icon(widget.habit == HabitType.quit ? Icons.done : Icons.close,
                      size: 18,color: ColorStrings.whiteColor,),
                ),
              );
            } else if (habitSkippedDateStore(widget.habit,widget.selectedCategory).any((element) => isSameDay(element, setSelectedDate(date)))) {
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

                    child: Icon(Icons.last_page, color: ColorStrings.whiteColor,),
                ),
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
            if (habitDoneDateStore(widget.habit,widget.selectedCategory).any((element) => isSameDay(element, setSelectedDate(date)))) {
              return Center(
                child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: widget.habit == HabitType.quit ?  Colors.red : Colors.green,
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

                    child:
                    Icon( widget.habit == HabitType.quit ? Icons.close : Icons.done, size: 18,color: ColorStrings.whiteColor,),
                ),
              );

              //   Container(
              //   margin: const EdgeInsets.all(6.0),
              //   alignment: Alignment.center,
              //   decoration: BoxDecoration(
              //     color: Colors.green,
              //     shape: BoxShape.circle,
              //   ),
              //   child: Text(
              //     '${date.day}',
              //     style: TextStyle(color: Colors.white),
              //   ),
              // );
            } else if (habitMissedDateStore(widget.habit,widget.selectedCategory).any((element) => isSameDay(element, setSelectedDate(date)))) {
              return Center(
                child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: widget.habit == HabitType.quit ? Colors.green : Colors.red ,
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

                    child: Icon( widget.habit == HabitType.quit ? Icons.close : Icons.done, size: 18,color: ColorStrings.whiteColor,),
                ),
              );
            } else if (habitSkippedDateStore(widget.habit,widget.selectedCategory).any((element) => isSameDay(element, setSelectedDate(date)))) {
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

                    child: Icon(Icons.last_page, color: ColorStrings.whiteColor,),
                ),
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
          selectedBuilder: (context, date, events) {
            if (habitDoneDateStore(widget.habit,widget.selectedCategory).any((element) => isSameDay(element, setSelectedDate(date)))) {
              return Center(
                child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: widget.habit == HabitType.quit ?  Colors.red: Colors.green,
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

                  child: Icon(widget.habit == HabitType.quit ? Icons.close : Icons.done, size: 18,),
                ),
              );

              //   Container(
              //   margin: const EdgeInsets.all(6.0),
              //   alignment: Alignment.center,
              //   decoration: BoxDecoration(
              //     color: Colors.green,
              //     shape: BoxShape.circle,
              //   ),
              //   child: Text(
              //     '${date.day}',
              //     style: TextStyle(color: Colors.white),
              //   ),
              // );
            } else if (habitMissedDateStore(widget.habit,widget.selectedCategory).any((element) => isSameDay(element, setSelectedDate(date)))) {
              return Center(
                child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: widget.habit == HabitType.quit ? Color(0xff079455) : Color(0xffD92D20)  ,
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

                    child: Icon( widget.habit == HabitType.quit ? Icons.done : Icons.close, size: 18,color: ColorStrings.whiteColor,),
                ),
              );
            } else if (habitSkippedDateStore(widget.habit,widget.selectedCategory).any((element) => isSameDay(element, setSelectedDate(date)))) {
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

                    child: Icon(Icons.last_page, size: 18,color: ColorStrings.whiteColor,),
                ),
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
