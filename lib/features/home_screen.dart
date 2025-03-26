import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_challenge/features/timer/timer_screen.dart';
import 'package:hard_challenge/routers/app_routes.gr.dart';
import 'package:hard_challenge/themes/theme_provider.dart';
import 'package:hard_challenge/utils/app_strings.dart';
import 'package:hard_challenge/utils/colors.dart';
import 'package:hard_challenge/utils/helpers.dart';
import 'package:hard_challenge/widgets/habit_custom_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../model/habit_model.dart';
import '../../provider/habit_provider.dart';
import '../widgets/all_habit_display_with_progress_widget.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDate;
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
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
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                          const SizedBox(width: 20,),
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

                          const SizedBox(width: 20,),
                          IconButton(
                            onPressed: () {
                              context.pushRoute(const SettingsScreen()); // Navigates to ProfileScreen

                              // context.router.push(
                              //   const PageRouteInfo<dynamic>(
                              //     'SettingsScreen',
                              //     path: '/settings-screen',
                              //   ),
                              // );
                            },
                            icon: const Icon(Icons.settings),
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
                                      firstDay: DateTime.utc(2000, 1, 1),
                                      lastDay: DateTime.utc(2100, 1, 1),
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
                      const SizedBox(height: 10,)
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
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text(
                            AppStrings.noHabitThisDay.tr,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          HabitCustomButton(buttonText: 'Add Habit', onTap: (){
                            context.router.push(
                              const PageRouteInfo<dynamic>(
                                'AddHabitScreen',
                                path: '/add-habit-screen',
                              ),
                            );
                          },
                            color: ColorStrings.headingBlue, widthOfButton: 180, buttonTextColor: Colors.white,)
                        ],
                      );
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
                                                        habit.category,
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
                                          child: habit.progressJson[_selectedDate]?.status == TaskStatus.skipped ? Text('Skipped',  style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13.sp,
                                          ),):  _buildTrailingWidget(context, habit),
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
          const SizedBox(height: 5),
          // CircularPercentIndicator(
          //   radius: 20.0,
          //   lineWidth: 6.0,
          //   percent: completion.clamp(0.0, 1.0), // Ensures valid range
          //   center: Text(
          //     "${date.day}",
          //     style: const TextStyle(fontSize: 16, color: Colors.black),
          //   ),
          //   progressColor: completion == 1.0 ? Colors.green : Colors.blue,
          //   backgroundColor: Colors.grey.shade300,
          //   circularStrokeCap: CircularStrokeCap.round,
          // ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(
                    value: completion.clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blue),
                    strokeWidth: 6,
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
                        // inset: true
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "${date.day}",
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13), // White text color for outside days
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTrailingWidget(BuildContext context, Habit habit) {
    final TaskStatus? status = habit.progressJson[_selectedDate]?.status;
    if (status == TaskStatus.skipped) {
      return const SizedBox.shrink(); // Hide button if skipped
    }

    switch (habit.taskType) {
      case TaskType.time:
        return Selector<HabitProvider, double>(
          selector: (_, provider) => provider.getHabitProgress(habit, _selectedDate) ?? 0.0,
          builder: (context, progress, _) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerScreen(
                      habit: habit,
                      selectedDate: _selectedDate,
                    ),
                  ),
                );
              },
              child: Container(
                height: 40,
                color: Colors.transparent,
                child: Icon(
                  progress < 1.0 ? Icons.play_circle_outline_rounded : Icons.check_circle_rounded,
                  color: progress < 1.0 ? const Color(0xff2d2925) : const Color(0xff749d49),
                ),
              ),
            );
          },
        );


      case TaskType.count:
        return GestureDetector(
          onTap: () {
            _completeValueTask(context, habit);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 65.w),
            child: Selector<HabitProvider, double>(
              selector: (_, provider) => provider.getHabitProgress(habit, _selectedDate) ?? 0.0,
              builder: (context, progress, _) {
                return Icon(
                  progress < 1.0 ? Icons.add_circle_outline_rounded : Icons.check_circle_rounded,
                  color: progress < 1.0 ? const Color(0xff2d2925) : const Color(0xff749d49),
                );
              },
            ),
          ),
        );


      case TaskType.task:
        return GestureDetector(
          onTap: () {
            _toggleTaskStatus(context, habit);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 65.w),
            child: Selector<HabitProvider, TaskStatus?>(
              selector: (_, provider) => provider.getTaskStatus(habit, _selectedDate),
              builder: (context, status, _) {
                return Icon(
                  status != TaskStatus.done ? Icons.circle_outlined : Icons.check_circle_rounded,
                  color: status != TaskStatus.done ? const Color(0xff2d2925) : const Color(0xff749d49),
                );
              },
            ),
          ),
        );

      default:
        return Container();
    }
  }

  void _toggleTaskStatus(BuildContext context, Habit habit) {
    HabitProvider provider = Provider.of<HabitProvider>(context, listen: false);
    TaskStatus currentStatus = provider.getTaskStatus(habit, _selectedDate) ?? TaskStatus.missed;

    double newProgress;
    TaskStatus newStatus;

    switch (currentStatus) {
      case TaskStatus.reOpen:
        newProgress = 1.0;
        newStatus = TaskStatus.done;
        break;
      case TaskStatus.done:
        newProgress = 0.0;
        newStatus = TaskStatus.reOpen;
        break;
      case TaskStatus.skipped:
      case TaskStatus.missed:
        newProgress = 1.0;
        newStatus = TaskStatus.done;
        break;
      default:
        newProgress = 1.0;
        newStatus = TaskStatus.done;
    }

    provider.updateHabitProgress(habit, _selectedDate, newProgress, newStatus, null);
  }
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
        return '$multipliedProgress/${(habit.value!)} ${habit.goalCountLabel ?? ''}';
      case TaskType.task:
        return 'Task';
      default:
        return '';

    }
  }

  void _completeValueTask(BuildContext context, Habit habit) {
    log('Specific habit: $habit');
    // setState(() {
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
    // });
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