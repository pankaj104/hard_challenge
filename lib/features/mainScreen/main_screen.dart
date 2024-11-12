import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_challenge/features/statistics/statistics_overall.dart';
import 'package:hard_challenge/utils/image_resource.dart';
import 'package:hard_challenge/features/statistics/statistics_habit_wise_screen.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../addChallenge/add_challenge_screen.dart';
import '../../model/habit_model.dart';
import '../../provider/habit_provider.dart';
import '../statistics/statistics_category_wise.dart';
import '../timer/timer_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late DateTime _selectedDate;
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().toUtc();
    _selectedDate = DateTime.utc(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    print('_selectedDate $_selectedDate'); // Output: 2024-11-10 00:00:00.000Z
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final selectedDate = DateTime(date.year, date.month, date.day);
    if (selectedDate.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (selectedDate.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else if (selectedDate.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow';
    } else {
      // Check if the selected date is in the same year
      if (date.year == now.year) {
        return DateFormat('d MMM').format(date); // Format without year
      } else {
        return DateFormat('d MMM yyyy').format(date); // Format with year
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Habits'),
      ),
      body: Column(
        children: [
          Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        List<Habit> get_all_habit = habitProvider.getAllHabit();
        // final Map<DateTime, double> taskCompletion; // Map of date to completion percentage
        // double completion = taskCompletion[date] ?? 0.0;


        return
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        StatisticsCategoryWise(habit: get_all_habit,)));
                  },
                      icon: const Icon(
                        Icons.add_chart, size: 40, color: Colors.blue,)),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          formatDate(_selectedDate),
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 35.h,
                    width: 35.w,
                    child: SvgPicture.asset(ImageResource.calenderIcon),
                  ),
                ],
              ),
              Container(
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Consumer<HabitProvider>(
                  builder: (context, habitProvider, child) {
                    return Consumer<HabitProvider>(
                        builder: (context, habitProvider, child) {
                          return TableCalendar(
                            rowHeight: 55,
                            firstDay: DateTime.utc(2020, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            focusedDay: _selectedDate,
                            availableGestures: AvailableGestures.all,
                            calendarFormat: CalendarFormat.week,
                            daysOfWeekStyle: const DaysOfWeekStyle(
                              weekdayStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                              weekendStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.w300, fontSize: 15),
                            ),
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDate, day);
                            },
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              leftChevronVisible: false,
                              rightChevronVisible: false,
                              headerPadding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                              titleTextStyle: TextStyle(fontSize: 0),
                            ),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDate = selectedDay;
                              });
                            },
                            calendarBuilders: CalendarBuilders(
                              defaultBuilder: (context, date, _) {
                                log('date check $date');
                                double completion = habitProvider.getAverageProgressForDate(date).clamp(0.0, 1.0);
                                return Center(
                                  child: CircularPercentIndicator(
                                    radius: 20.0,
                                    lineWidth: 5.0,
                                    percent: completion,
                                    center: Text(
                                      "${date.day}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    progressColor: completion == 1.0 ? Colors.green : Colors.blue,
                                    backgroundColor: Colors.grey.shade300,
                                  ),
                                );
                              },
                              todayBuilder: (context, date, _) {
                                log('date check1 $date');
                                double completion = habitProvider.getAverageProgressForDate(date).clamp(0.0, 1.0);
                                return Center(
                                  child: CircularPercentIndicator(
                                    radius: 20.0,
                                    lineWidth: 5.0,
                                    percent: completion,
                                    center: Text(
                                      "${date.day}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    progressColor: completion == 1.0 ? Colors.green : Colors.blue,
                                    backgroundColor: Colors.grey.shade300,
                                  ),
                                );
                              },
                              selectedBuilder: (context, date, _) {
                                double completion = habitProvider.getAverageProgressForDate(date).clamp(0.0, 1.0);
                                return Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: CircularPercentIndicator(
                                      radius: 20.0,
                                      lineWidth: 5.0,
                                      percent: completion,
                                      center: Text(
                                        "${date.day}",
                                        style: const TextStyle(fontSize: 16, color: Colors.black),
                                      ),
                                      progressColor: completion == 1.0 ? Colors.green : Colors.red,
                                      backgroundColor: Colors.white60,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );

                  },
                )

              ),
            ],
          );
      }
          ),
          // Calendar
          // Display habits for the selected date
          Expanded(
            child: Consumer<HabitProvider>(
              builder: (context, habitProvider, child) {
                List<Habit> habitsForSelectedDate =
                habitProvider.getHabitsForDate(_selectedDate);
                return ListView.builder(
                  itemCount: habitsForSelectedDate.length,
                  itemBuilder: (context, index) {
                    Habit habit = habitsForSelectedDate[index];
                    double progress =
                        habit.progressJson[_selectedDate]?.progress ?? 0.0;
                    bool isSkipped =
                        habit.progressJson[_selectedDate]?.status ==
                            TaskStatus.skipped;

                    return Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(22.w),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0.0, 4.0),
                              color: Colors.grey,
                              blurRadius: 4.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        height: 65.h,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: LinearProgressIndicator(
                                value: isSkipped ? 0.0 : progress,
                                color: Colors.blue.withAlpha(100),
                                backgroundColor: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.h),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsets.only(left: 5.w, right: 15.w),
                                    child: Container(
                                      height: 50.h,
                                      width: 48.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(18.w),
                                        color: habit.iconBgColor
                                      ),
                                      child: Icon(habit.habitIcon, size: 20,),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StatisticsHabitWiseScreen(
                                                habit: habit,
                                                selectedDateforSkip: _selectedDate,),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 5.h, left: 10.w),
                                          child: Text(
                                            habit.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontSize: 21),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          EdgeInsets.only(left: 10.w),
                                          child: Text(
                                            habit.progressJson[_selectedDate]?.status ==
                                                TaskStatus.skipped
                                                ? 'Skipped'
                                                : '${habit.category}',
                                            style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.7),
                                              fontSize: 19,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 42.w),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        log('print handle habit tap');
                                        _handleHabitTap(
                                            context, habit);
                                      });

                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 22.w),
                                      child: Container(
                                        child: _buildTrailingWidget(
                                            context, habit, progress),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddChallengeScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTrailingWidget(BuildContext context, Habit habit, double progress) {
    // Check if the task status is skipped
    if (habit.progressJson[_selectedDate]?.status == TaskStatus.skipped) {
      return const SizedBox.shrink(); // Return an empty widget
    }
    switch (habit.taskType) {
      case TaskType.time:
        return Padding(
          padding: EdgeInsets.only(left: 22.w),
          child: Container(
              height: 28.h,
              width: 28.w,
              color: Colors.blue,
              child: const Icon(Icons.timer)),
        );
      case TaskType.count:
        return Padding(
          padding: EdgeInsets.only(left: 22.w),
          child: Container(
              height: 28.h,
              width: 28.w,
              color: Colors.blue,
              child: Text('${habit.value}')),
        );
      case TaskType.task:
        return Padding(
          padding: EdgeInsets.only(left: 22.w),
          child: Container(
            height: 28.h,
            width: 28.w,
            color: Colors.blue,
            child: Checkbox(
              value: habit.progressJson[_selectedDate]?.progress == 1.0,
              onChanged: (bool? value) {
                setState(() {
                  // Fetch the current status for the selected date
                  TaskStatus? currentStatus = habit.progressJson[_selectedDate]?.status;

                  // Log the current status (for debugging purposes)
                  log('current status: $currentStatus');

                  double newProgress = value == true ? 1.0 : 0.0;
                  TaskStatus newStatus;

                  // Check the current status and toggle accordingly
                  if (currentStatus == TaskStatus.reOpen) {
                    // If the current status is 'reOpen', mark it as completed (done)
                    newProgress = 1.0; // Mark progress as 100%
                    newStatus = TaskStatus.done; // Change status to 'done'
                  } else if (currentStatus == TaskStatus.done) {
                    // If the task is already done, uncheck it (mark as reOpen)
                    newProgress = 0.0; // Mark progress as 0%
                    newStatus = TaskStatus.reOpen; // Change status to 'reOpen'
                  } else if (currentStatus == TaskStatus.skipped) {
                    // If the task was skipped, check it (mark as done)
                    newProgress = 1.0; // Mark progress as 100%
                    newStatus = TaskStatus.done; // Change status to 'done'
                  }
     else if (currentStatus == TaskStatus.missed) {
    // If the task was skipped, check it (mark as done)
    newProgress = 1.0; // Mark progress as 100%
    newStatus = TaskStatus.done; // Change status to 'done'
    }
                  else {
                    // Default case: Mark as 'done' (progress is 100% initially)
                    newProgress = 1.0;
                    newStatus = TaskStatus.done; // Set status to 'done'
                  }

                  // Update the habit progress for the selected date with the new status and progress
                  Provider.of<HabitProvider>(context, listen: false).updateHabitProgress(habit, _selectedDate, newProgress, newStatus);
                });
              },
            )

          ),
        );
      default:
        return Container();

    }
  }


  void _handleHabitTap(BuildContext context, Habit habit) {
    switch (habit.taskType) {
      case TaskType.time:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TimerScreen(
              habit: habit,
              selectedDate: _selectedDate,
            ),
          ),
        );
        break;
      case TaskType.count:
        _completeValueTask(context, habit);
        break;
      case TaskType.task:
        setState(() {
          // Get the current progress and status for the selected date
          double currentProgress = habit.progressJson[_selectedDate]?.progress ?? 0.0;
          TaskStatus currentStatus = habit.progressJson[_selectedDate]?.status ?? TaskStatus.missed;
          log('current status init $currentStatus');

          double newProgress;
          TaskStatus newStatus;

          // Check the current status and toggle accordingly
          if (currentStatus == TaskStatus.reOpen) {
            // If the current status is 'reOpen', mark it as completed (done)
            newProgress = 1.0; // Mark progress as 100% (or any other appropriate value)
            newStatus = TaskStatus.done; // Change status to 'done'
          } else if (currentStatus == TaskStatus.done) {
            log('current status $currentStatus');
            // If the task is already done, uncheck it (mark as skipped)
            newProgress = 0.0; // Mark progress as 0%
            newStatus = TaskStatus.reOpen; // Change status to 'skipped'
          } else if (currentStatus == TaskStatus.skipped) {
            // If the task was skipped, check it (mark as done)
            newProgress = 1.0; // Mark progress as 100%
            newStatus = TaskStatus.done; // Change status to 'done'
          } else {
            // Default case: Mark as 'reOpen' (progress is 0% initially)
            newProgress = 0.0;
            newStatus = TaskStatus.reOpen; // Set status to 'reOpen'
          }

          // Update the habit progress for the selected date with the new status and progress
          Provider.of<HabitProvider>(context, listen: false).updateHabitProgress(habit, _selectedDate, newProgress, newStatus);
        });


        break;
    }
  }

  void _completeValueTask(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _valueCompleteController =
        TextEditingController();
        return AlertDialog(
          title: Text('Complete Task: ${habit.title}'),
          content: TextField(
            controller: _valueCompleteController,
            decoration:
            const InputDecoration(hintText: 'Enter completed value'),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final completedValue =
                    int.tryParse(_valueCompleteController.text) ?? 0;
                setState(() {
                  double newProgress =
                      completedValue / (habit.value ?? 1);
                  Provider.of<HabitProvider>(context, listen: false)
                      .updateHabitProgress(
                      habit, _selectedDate, newProgress, TaskStatus.done);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Complete'),
            ),
          ],
        );
      },
    );
  }
}
