import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:table_calendar/table_calendar.dart';

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
        calendarStyle: const CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekendStyle: TextStyle(color: Colors.red),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, date, events) {
            if (habitDoneDateStore(widget.habit,widget.selectedCategory).any((element) => isSameDay(element, date))) {
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
            } else if (habitMissedDateStore(widget.habit,widget.selectedCategory).any((element) => isSameDay(element, date))) {
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
            } else if (habitSkippedDateStore(widget.habit,widget.selectedCategory).any((element) => isSameDay(element, date))) {
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
            return null;
          },
        ),
      ),
    );
  }
}
