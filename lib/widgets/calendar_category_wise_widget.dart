import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:hard_challenge/utils/helpers.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/colors.dart';
import '../utils/image_resource.dart';

class CalendarCategoryWisePage extends StatefulWidget {
  final List<Habit> habit;
  final String selectedCategory;

  const CalendarCategoryWisePage({super.key, required this.habit, required this.selectedCategory});

  @override
  _CalendarCategoryWisePageState createState() => _CalendarCategoryWisePageState();
}

class _CalendarCategoryWisePageState extends State<CalendarCategoryWisePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  late List<DateTime> habitDoneDates;
  late List<DateTime> habitSkippedDates;
  late List<DateTime> habitMissedDates;
  late Map<DateTime, double> _habitProgress;



  @override
  void initState() {
    super.initState();
    habitDoneDates = _getFilteredHabitDates(TaskStatus.done);
    habitSkippedDates = _getFilteredHabitDates(TaskStatus.skipped);
    habitMissedDates = _getMissedHabitDates();
    _habitProgress = _getHabitProgress(); // Fetch progress

  }

  List<DateTime> _getFilteredHabitDates(TaskStatus status) {
    List<DateTime> filteredDates = [];
    for (var habit in widget.habit) {
      if (habit.category == widget.selectedCategory) {
        habit.progressJson.forEach((date, progress) {
          if (progress.status == status) {
            filteredDates.add(date);
          }
        });
      }
    }
    return filteredDates;
  }

  List<DateTime> _getMissedHabitDates() {
    Set<DateTime> missedDates = {}; // Use a Set to avoid duplicates
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day); // Get only the date part (no time)

    for (var habit in widget.habit) {
      if (habit.category == widget.selectedCategory) {
        DateTime startDate = habit.startDate ?? now;
        DateTime endDate = habit.endDate ?? now;

        // Get progress JSON only for the selected category
        Map<DateTime, ProgressWithStatus> categoryProgressJson = habit.progressJson;

        for (DateTime date = startDate; date.isBefore(today); date = date.add(const Duration(days: 1))) {
          DateTime cleanDate = DateTime(date.year, date.month, date.day); // Remove time part

          bool isValidDate = _isValidDateForHabit(habit, cleanDate);

          // Ensure today's date is not added
          if (isValidDate && !categoryProgressJson.containsKey(cleanDate)) {
            missedDates.add(cleanDate);
          }
        }
      }
    }

    return missedDates.toList()..sort(); // Convert to List & Sort for consistency
  }


  bool _isValidDateForHabit(Habit habit, DateTime date) {
    int weekday = date.weekday; // No need to use % 7, as Sunday is already 7 in Dart.
    switch (habit.repeatType) {
      case RepeatType.selectDays:
        return habit.days!.contains(weekday); // Direct comparison without % 7
      case RepeatType.selectedDate:
        return habit.selectedDates != null && habit.selectedDates!.contains(date);
      case RepeatType.weekly:
        return habit.days!.contains(weekday);
      case RepeatType.monthly:
        return habit.selectedDates != null &&
            habit.selectedDates!.any((d) => d.month == date.month && d.day == date.day);
      default:
        return false;
    }
  }

  // Map<DateTime, double> _getHabitProgress() {
  //   Map<DateTime, List<double>> progressMap = {};
  //
  //   for (var habit in widget.habit) {
  //     if (habit.category == widget.selectedCategory) {
  //       habit.progressJson.forEach((date, progress) {
  //         if (!progressMap.containsKey(date)) {
  //           progressMap[date] = [];
  //         }
  //         progressMap[date]!.add(progress.progress); // Collect all progress values
  //       });
  //     }
  //   }
  //
  //   // Compute the average progress for each date
  //   return progressMap.map((date, progressList) =>
  //       MapEntry(date, progressList.reduce((a, b) => a + b) / progressList.length));
  // }

  Map<DateTime, double> _getHabitProgress() {
    Map<DateTime, List<double>> progressMap = {};  // Stores progress values per date
    Map<DateTime, int> habitCountMap = {};  // Tracks the number of habits per date

    for (var habit in widget.habit) {
      if (habit.category == widget.selectedCategory) {
        DateTime startDate = habit.startDate ?? DateTime.now();
        DateTime endDate = habit.endDate ?? DateTime.now();

        // Check if habit's active period overlaps with the date range
        for (DateTime date = startDate; !date.isAfter(endDate); date = date.add(const Duration(days: 1))) {
          // If progress exists for this date, use it
          habit.progressJson.forEach((progressDate, progress) {
            if (date.isAtSameMomentAs(progressDate)) {
              // If there's progress for this specific date, add it to the list
              if (!progressMap.containsKey(date)) {
                progressMap[date] = [];
              }
              progressMap[date]!.add(progress.progress);
              // Count the habit for this date
              habitCountMap[date] = (habitCountMap[date] ?? 0) + 1;
            }
          });

          // If no progress exists for this date, still consider the habit as "inactive" (progress = 0.0)
          if (!habit.progressJson.containsKey(date)) {
            if (!progressMap.containsKey(date)) {
              progressMap[date] = [];
            }
            progressMap[date]!.add(0.0); // Add 0 progress for the habit on this date
            habitCountMap[date] = (habitCountMap[date] ?? 0) + 1; // Increment habit count
          }
        }
      }
    }

    // Calculate average progress by dividing total progress by habit count for each date
    Map<DateTime, double> habitProgress = {};
    progressMap.forEach((date, progressList) {
      int habitCount = habitCountMap[date] ?? 1; // Avoid division by zero
      double totalProgress = progressList.reduce((a, b) => a + b);
      double averageProgress = totalProgress / habitCount;

      habitProgress[date] = averageProgress;
    });

    log('habitProgress ttt $habitProgress'); // Debugging log

    return habitProgress;
  }





  Widget _buildDateWidget(DateTime date) {
    double? progress = _habitProgress[date]; // Fetch progress for this date
    log('check progress with date wise $progress');

    if (progress != null) {
      if (progress == 1) {
        return _buildStatusWidget(date, Colors.green, Icons.done); // Show Done ✅
      } else if (progress > 0 && progress < 1) {
        return _buildProgressWidget(date, progress); // Show progress bar
      }
    }

    if (habitMissedDates.any((element) => isSameDay(element, date))) {
      return _buildStatusWidget(date, Colors.red, Icons.close);
    } else if (habitSkippedDates.any((element) => isSameDay(element, date))) {
      return _buildStatusWidget(date, Colors.amberAccent, Icons.last_page);
    }

    return _buildDefaultDateWidget(date);
  }




  Widget _buildProgressWidget(DateTime date, double progress) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.withOpacity(0.5),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.green),
              strokeWidth: 4,
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25), // Subtle grey shadow
                  spreadRadius: 0.4,
                  blurRadius: 1,
                  offset: const Offset(0, 2), // Shadow slightly below
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${(progress*100).toInt()}%',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13), // White text color for outside days
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildStatusWidget(DateTime date, Color color, IconData icon) {
    return Center(
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0.4,
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: ColorStrings.whiteColor),
      ),
    );
  }

  Widget _buildDefaultDateWidget(DateTime date) {
    return Center(
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: ColorStrings.whiteColor, // Background color for days outside the current month
          borderRadius: BorderRadius.circular(36),
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TableCalendar(
        headerVisible: true,
        sixWeekMonthsEnforced: true,
        availableGestures: AvailableGestures.none,//this single code will solve
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        // selectedDayPredicate: (day) {
        //   return isSameDay(_selectedDay, day);
        // },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: const CalendarStyle(),
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          leftChevronIcon: SvgPicture.asset(ImageResource.calenderLeft),
          rightChevronIcon: SvgPicture.asset(ImageResource.calenderRight),
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarBuilders: CalendarBuilders(
          outsideBuilder: (context, date, events) {
            return IgnorePointer(
              ignoring: true, // Prevents any interaction
              child: Center(
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: ColorStrings.silverColor.withOpacity(0.1), // Background color for days outside the current month
                    borderRadius: BorderRadius.circular(36),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                    //     spreadRadius: 0.4, // Light spread for subtle effect
                    //     blurRadius: 1, // Smooth blur for softer shadow
                    //     offset: const Offset(0, 2), // Shadow slightly below the element
                    //   ),
                    // ],
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400), // White text color for outside days
                    ),
                  ),
                ),
              ),
            );
          },
          defaultBuilder: (context, date, events) {
            return _buildDateWidget(setSelectedDate(date));
          },
          todayBuilder: (context, date, events) {
            return _buildDateWidget(setSelectedDate(date));
          },
          selectedBuilder: (context, date, events) {
            return _buildDateWidget(setSelectedDate(date));
          },
        ),
      ),
    );
  }
}
