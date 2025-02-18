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

  @override
  void initState() {
    super.initState();
    habitDoneDates = _getFilteredHabitDates(TaskStatus.done);
    habitSkippedDates = _getFilteredHabitDates(TaskStatus.skipped);
    habitMissedDates = _getMissedHabitDates();
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
    List<DateTime> missedDates = [];
    DateTime now = DateTime.now();

    for (var habit in widget.habit) {
      if (habit.category == widget.selectedCategory) {
        DateTime startDate = habit.startDate ?? now;
        DateTime endDate = habit.endDate ?? now;

        Map<DateTime, ProgressWithStatus> categoryProgressJson = Map.fromEntries(
          habit.progressJson.entries.where((entry) => habit.category == widget.selectedCategory),
        );

        for (DateTime date = startDate; date.isBefore(now) || date.isAtSameMomentAs(now); date = date.add(const Duration(days: 1))) {
          bool isValidDate = _isValidDateForHabit(habit, date);

          if (isValidDate && !categoryProgressJson.containsKey(date)) {
            missedDates.add(date);
          }
        }
      }
    }

    return missedDates;
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


  Widget _buildDateWidget(DateTime date) {
    if (habitDoneDates.any((element) => isSameDay(element, date))) {
      return _buildStatusWidget(date, Colors.green, Icons.done);
    } else if (habitMissedDates.any((element) => isSameDay(element, date))) {
      return _buildStatusWidget(date, Colors.red, Icons.close);
    } else if (habitSkippedDates.any((element) => isSameDay(element, date))) {
      return _buildStatusWidget(date, Colors.amberAccent, Icons.last_page);
    }
    return _buildDefaultDateWidget(date);
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
            return _buildDateWidget(date);
          },
          defaultBuilder: (context, date, events) {
            return _buildDateWidget(date);
          },
          todayBuilder: (context, date, events) {
            return _buildDateWidget(date);
          },
          selectedBuilder: (context, date, events) {
            return _buildDateWidget(date);
          },
        ),
      ),
    );
  }
}
