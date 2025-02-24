import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_challenge/features/statistics/statistics_category_wise.dart';
import 'package:hard_challenge/features/statistics/statistics_overall.dart';
import 'package:hard_challenge/features/timer/timer_screen.dart';
import 'package:hard_challenge/routers/app_routes.gr.dart';
import 'package:hard_challenge/utils/helpers.dart';
import 'package:hard_challenge/utils/image_resource.dart';
import 'package:hard_challenge/features/statistics/statistics_habit_wise_screen.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../model/habit_model.dart';
import '../../provider/habit_provider.dart';
import '../widgets/all_habit_display_with_progress_widget.dart';
import 'addChallenge/add_challenge_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDate;
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().toUtc();
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    print('_selectedDate $_selectedDate'); // Output: 2024-11-10 00:00:00.000
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
     toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Consumer<HabitProvider>(
              builder: (context, habitProvider, child) {
                List<Habit> get_all_habit = habitProvider.getAllHabit();
                // final Map<DateTime, double> taskCompletion; // Map of date to completion percentage
                // double completion = taskCompletion[date] ?? 0.0;


                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(

                      children: [

                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           crossAxisAlignment: CrossAxisAlignment.center,

                           children: [
                             IconButton(onPressed: () {
                               showHabitBottomSheet(context);
                             },
                                 icon:  Icon(Icons.list_outlined, size: 30, color: Colors.black.withOpacity(0.85),)),
                             Center(
                               child: SizedBox(
                                 width: 150,
                                 child: Text(
                                        formatDate(_selectedDate),
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                   textAlign: TextAlign.center,
                                      ),
                               ),
                             ),

                            IconButton(onPressed: () {
                              setState(() async {
                                await habitProvider.clearHabits();
                              });
                            }, icon: const Icon(Icons.clear))
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
                                    return Center(
                                      child: TableCalendar(
                                        rowHeight: 75,
                                        firstDay: DateTime.utc(2020, 10, 16),
                                        lastDay: DateTime.utc(2050, 3, 14),
                                        focusedDay: _selectedDate,
                                        calendarFormat: CalendarFormat.week,
                                        daysOfWeekStyle: const DaysOfWeekStyle(
                                          weekdayStyle: TextStyle(color: Colors.transparent, fontSize: 0), // Hide weekday labels
                                          weekendStyle: TextStyle(color: Colors.transparent, fontSize: 0), // Hide weekend labels
                                        ),
                                        selectedDayPredicate: (day) {
                                          return isSameDay(_selectedDate, day);
                                        },
                                        headerStyle: const HeaderStyle(
                                          formatButtonVisible: false,
                                          leftChevronVisible: false,
                                          rightChevronVisible: false,
                                          headerPadding: EdgeInsets.only(left: 10, bottom: 2, top: 5),
                                          titleTextStyle: TextStyle(fontSize: 0),
                                        ),
                                        onDaySelected: (selectedDay, focusedDay) {
                                          setState(() {
                                            Provider.of<HabitProvider>(context, listen: false).loadHabits();
                                            _selectedDate = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                                            log('selected date from calender $_selectedDate');
                                          });
                                        },

                                        calendarBuilders: CalendarBuilders(
                                          defaultBuilder: (context, date, _) => _buildCalendarCell(context, date, habitProvider),
                                          todayBuilder: (context, date, _) => _buildCalendarCell(context, date, habitProvider),
                                          selectedBuilder: (context, date, _) => _buildCalendarCell(context, date, habitProvider, isSelected: true),
                                          outsideBuilder: (context, date, _) => _buildCalendarCell(context, date, habitProvider),
                                        ),

                                      ),
                                    );
                                  },
                                );

                              },
                            )

                        ),
                        SizedBox(height: 10,)
                      ],
                    ),
                );
              }
          ),
          // Calendar
          // Display habits for the selected date
          Expanded(
            child: Consumer<HabitProvider>(
              builder: (context, habitProvider, child) {
                return FutureBuilder<List<Habit>>(
                  // Replace this with the actual method that fetches habits asynchronously
                  future: habitProvider.getHabitsForDate(_selectedDate),
                  builder: (context, snapshot) {
                    // Check if the Future has completed and whether there were any errors
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No habits available'));
                    } else {
                      // Get the habits list for the selected date
                      List<Habit> habitsForSelectedDate = snapshot.data!;
                      log('snapshot data $habitsForSelectedDate');

                      return ListView.builder(
                        itemCount: habitsForSelectedDate.length,
                        itemBuilder: (context, index) {
                          Habit habit = habitsForSelectedDate[index];
                          double progress =
                              habit.progressJson[_selectedDate]?.progress ?? 0.0;
                          log('_selectedDate on top ${setSelectedDate(_selectedDate)}');
                          bool isSkipped =
                              habit.progressJson[_selectedDate]?.status ==
                                  TaskStatus.skipped;

                          return Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              margin: EdgeInsets.symmetric(horizontal: 14.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0.0, 4.0),
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 2.0,
                                    spreadRadius: 1.0,
                                  ),
                                ],
                              ),
                              height: 65,
                              child: Stack(
                                children: [
                                  // Progress indicator background
                                  Positioned.fill(
                                    child: LinearProgressIndicator(
                                      value: isSkipped ? 0.0 : progress,
                                      color: Colors.blue.withOpacity(0.3),
                                      backgroundColor: Colors.white,
                                    ),
                                  ),

                                  // Content
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Icon container
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: habit.iconBgColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(child: Text(habit.habitEmoji , style: const TextStyle(fontSize: 30),)),
                                          //
                                          // Icon(
                                          //     IconData(convertToIconData(habit.habitEmoji.toString()), fontFamily: 'MaterialIcons')
                                          //     ,  size: 24.sp, color: Colors.white),
                                        ),

                                        // Habit details
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              context.router.push(
                                                 PageRouteInfo<dynamic>(
                                                  'StatisticsHabitWiseScreen',
                                                  path: '/statistics-habit-wise-screen',
                                                  args: StatisticsHabitWiseScreenArgs(
                                                    habit: habit,
                                                    selectedDateforSkip: _selectedDate,
                                                  )
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 12.w),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    habit.title,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black,
                                                      fontSize: 20.sp,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        habit.progressJson[_selectedDate]?.status == TaskStatus.skipped
                                                            ? 'Skipped'
                                                            : habit.category,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.sp,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.w), // Dynamic width spacing for better responsiveness
                                                      Container(
                                                        height: 15.h, // Adjust height as needed
                                                        width: 1, // Thin vertical line
                                                        color: Colors.black, // Divider color
                                                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                                                      ),
                                                      Text(
                                                        _buildTrailingString(context, habit),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Trailing widget
                                        Padding(
                                          padding: const EdgeInsets.only(left: 0),
                                          child: _buildTrailingWidget(context, habit, progress),
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
                    }
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
  Widget _buildCalendarCell(BuildContext context, DateTime date, HabitProvider habitProvider, {bool isSelected = false}) {
    // Ensure correct date format (year, month, day only)
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Fetch progress safely
    double completion = habitProvider.getAverageProgressForDate(normalizedDate) ?? 0.0;

    // Ensure percent is within valid range
    completion = completion.clamp(0.0, 1.0);

    return Container(
      margin: isSelected ? const EdgeInsets.symmetric(horizontal: 3) : null,
      decoration: isSelected
          ? BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      )
          : null,
      child: Column(
        children: [
          Text(
            DateFormat('EE').format(date).substring(0, 2),
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 2),
          Center(
            child: CircularPercentIndicator(
              radius: 20.0,
              lineWidth: 5.0,
              percent: completion,
              center: Text(
                "${date.day}",
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              progressColor: completion == 1.0 ? Colors.green : Colors.blue,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTrailingWidget(BuildContext context, Habit habit, double progress) {
    // Check if the task status is skipped

    if (habit.progressJson[_selectedDate]?.status == TaskStatus.skipped) {
      return const SizedBox.shrink(); // Return an empty widget
    }
    log('_selectedDate format on main screen $_selectedDate');
    switch (habit.taskType) {
      case TaskType.time:
        return GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TimerScreen(
                  habit: habit,
                  selectedDate: _selectedDate,
                ),
              ),
            );
          },          child: const Icon(Icons.play_arrow_rounded),
        );
      case TaskType.count:
        return GestureDetector(
          onTap: (){
            _completeValueTask(context, habit);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 65.w),
            child: (habit.progressJson[_selectedDate]?.progress ?? 0.0) < 1.0
                ? const Icon(Icons.add_rounded)
                : const Icon(Icons.check_rounded),
          ),
        );
      case TaskType.task:
        return GestureDetector(
          onTap: (){
            setState(() {
              // Get the current progress and status for the selected date
              double currentProgress = habit.progressJson[_selectedDate]?.progress ?? 0.0;
              log('_selectedDate in task  $_selectedDate');
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
              Provider.of<HabitProvider>(context, listen: false).updateHabitProgress(habit, _selectedDate, newProgress, newStatus, null);
            });


          },
          child: Padding(
            padding: EdgeInsets.only(left: 65.w),
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
                  Provider.of<HabitProvider>(context, listen: false).updateHabitProgress(habit, _selectedDate, newProgress, newStatus, null);
                });
              },
            ),
          ),
        );
      default:
        return Container();

    }
  }

  // String formatDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //
  //   int hours = duration.inHours;
  //   String minutes = twoDigits(duration.inMinutes.remainder(60));
  //   String seconds = twoDigits(duration.inSeconds.remainder(60));
  //
  //   if (hours > 0) {
  //     return "$hours:$minutes:$seconds";  // Format as HH:MM:SS when hours > 0
  //   } else {
  //     return "$minutes:$seconds";  // Format as MM:SS when hours == 0
  //   }
  // }
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    int hours = duration.inHours;
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    // Always return HH:MM:SS format
    return "$hours:$minutes:$seconds";
  }



  String _buildTrailingString(BuildContext context, Habit habit) {
    switch (habit.taskType) {
      case TaskType.time:

        Duration runningDuration = habit.progressJson[_selectedDate]?.duration ?? const Duration();
        return '${formatDuration(runningDuration)}/${formatDuration(habit.timer!)}';

      case TaskType.count:
        int multipliedProgress = ((habit.progressJson[_selectedDate]?.progress ?? 0.0) * (habit.value ?? 1.0)).toInt();
        return '$multipliedProgress/${(habit.value!)}';
      case TaskType.task:
        return 'Task';
      default:
        return '';

    }
  }

  void _completeValueTask(BuildContext context, Habit habit) {
    log('Specific habit: $habit');

    setState(() {
      // Get the current progress for the selected date or default to 0.0 if not set
      double currentProgress = habit.progressJson[_selectedDate]?.progress ?? 0.0;

      // Increment progress by 1.0 and divide by habit.value, but keep it within a max of 1.0
      double newProgress = ((currentProgress * (habit.value ?? 1.0)) + 1.0) / (habit.value ?? 1.0);

      // Ensure newProgress doesn't exceed 1.0
      newProgress = newProgress.clamp(0.0, 1.0);

      // Update the habit's progress in HabitProvider with newProgress and status 'done'

      if (newProgress >= 1.0){
        Provider.of<HabitProvider>(context, listen: false)
            .updateHabitProgress(habit, _selectedDate, newProgress, TaskStatus.done, null);
      }
      else{
        Provider.of<HabitProvider>(context, listen: false)
            .updateHabitProgress(habit, _selectedDate, newProgress, TaskStatus.goingOn , null);
      }
    });
  }


  void showHabitBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.90,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'All Habits',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                   HabitTile (isForCategoryWiseStatistics: false, ),
                ],
              ),
            );
          },
        );
      },
    );
  }

}
