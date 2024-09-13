import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_challenge/features/statistics/statistics_overall.dart';
import 'package:hard_challenge/utils/image_resource.dart';
import 'package:hard_challenge/features/statistics/statistics_habit_wise_screen.dart';
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
    _selectedDate = DateTime.now();
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
        return
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
                      "Today",
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      DateTime.now().toString().split(" ")[0],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black.withOpacity(0.8),
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
          );
      }
          ),
          // Calendar
          Container(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.withOpacity(0.09),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TableCalendar(
              rowHeight: 55,
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _selectedDate,
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 24,
                ),
                formatButtonVisible: false,
                titleCentered: true,
              ),
              availableGestures: AvailableGestures.all,
              calendarFormat: CalendarFormat.week,
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle:
                TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                weekendStyle: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  print("selectedDay: $selectedDay");
                });
              },
            ),
          ),
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
                                            isSkipped
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
                                    onTap: () => _handleHabitTap(
                                        context, habit),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 22.w),
                                      child: Container(
                                        height: 28.h,
                                        width: 28.w,
                                        color: Colors.blue,
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

  Widget _buildTrailingWidget(
      BuildContext context, Habit habit, double progress) {
    switch (habit.taskType) {
      case TaskType.time:
        return const Icon(Icons.timer);
      case TaskType.count:
        return Text('${habit.value}');
      case TaskType.task:
      default:
        return Checkbox(
          value: progress == 1.0,
          onChanged: (bool? value) {
            setState(() {
              double newProgress = value == true ? 1.0 : 0.0;
              Provider.of<HabitProvider>(context, listen: false)
                  .updateHabitProgress(habit, _selectedDate, newProgress);
            });
          },
        );
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
          double newProgress =
          (habit.progressJson[_selectedDate]?.progress ?? 0.0) == 1.0
              ? 0.0
              : 1.0;
          Provider.of<HabitProvider>(context, listen: false)
              .updateHabitProgress(habit, _selectedDate, newProgress);
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
                      habit, _selectedDate, newProgress);
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
